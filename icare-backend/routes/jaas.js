const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');

// POST /api/jaas/token — generate JaaS JWT for a meeting participant
// No auth required: only signs meeting access, no user data exposed.
router.post('/token', (req, res) => {
  const appId    = process.env.JAAS_APP_ID;
  const apiKeyId = process.env.JAAS_API_KEY_ID;
  // Vercel stores multiline secrets with literal \n — restore real newlines
  const privateKey = (process.env.JAAS_PRIVATE_KEY || '').replace(/\\n/g, '\n');

  if (!appId || !apiKeyId || !privateKey) {
    return res.status(500).json({
      success: false,
      message: 'JAAS_APP_ID, JAAS_API_KEY_ID, or JAAS_PRIVATE_KEY not configured on server',
    });
  }

  const displayName = ((req.body.displayName || 'User') + '').trim().slice(0, 50) || 'User';
  const email       = ((req.body.email || 'user@icare.app') + '').trim();
  const isModerator = req.body.isModerator === true || req.body.isModerator === 'true';
  const userId      = ((req.body.userId || '') + '').trim() || ('uid_' + Math.random().toString(36).substr(2, 8));

  const now = Math.floor(Date.now() / 1000);

  const payload = {
    iss: 'chat',
    sub: appId,
    aud: 'jitsi',
    nbf: now - 10,
    exp: now + 7200, // 2-hour token
    room: '*',       // allow any room for this app
    context: {
      user: {
        id:        userId,
        name:      displayName,
        email:     email,
        avatar:    '',
        moderator: isModerator ? 'true' : 'false',
      },
      features: {
        livestreaming:   'true',
        recording:       'false',
        transcription:   'false',
        'outbound-call': 'false',
      },
    },
  };

  try {
    const token = jwt.sign(payload, privateKey, {
      algorithm: 'RS256',
      header: { kid: apiKeyId, alg: 'RS256' },
    });
    return res.json({ success: true, token, appId });
  } catch (e) {
    console.error('JaaS token error:', e.message);
    return res.status(500).json({ success: false, message: 'Token generation failed: ' + e.message });
  }
});

// GET /api/jaas/ping — verify route + config is present
router.get('/ping', (req, res) => {
  res.json({
    success: true,
    configured: !!(process.env.JAAS_APP_ID && process.env.JAAS_API_KEY_ID && process.env.JAAS_PRIVATE_KEY),
  });
});

module.exports = router;
