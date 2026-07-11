const express = require('express');
const router = express.Router();

// Optional: server SDK for generating LiveKit AccessTokens
let AccessToken;
try {
  AccessToken = require('livekit-server-sdk').AccessToken;
} catch (e) {
  try { AccessToken = require('@livekit/server-sdk').AccessToken; } catch (_) { AccessToken = null; }
}

// POST /api/livekit/token
// Body: { room: 'roomName', identity: 'userIdentity' }
router.post('/token', (req, res) => {
  const room = (req.body.room || req.query.room || '').toString();
  const identity = (req.body.identity || req.query.identity || ('user_' + Math.random().toString(36).substr(2,6))).toString();

  if (!process.env.LIVEKIT_API_KEY || !process.env.LIVEKIT_API_SECRET) {
    return res.status(500).json({ success: false, message: 'LIVEKIT_API_KEY or LIVEKIT_API_SECRET not configured on server' });
  }

  if (!AccessToken) {
    return res.status(500).json({ success: false, message: 'livekit-server-sdk not installed. Please add it to package.json' });
  }

  try {
    const at = new AccessToken(process.env.LIVEKIT_API_KEY, process.env.LIVEKIT_API_SECRET, { identity });
    // Grant join permission for the requested room
    at.addGrant({ roomJoin: true, room });
    const token = at.toJwt();
    return res.json({ success: true, token, identity, room, livekitUrl: process.env.LIVEKIT_URL || '' });
  } catch (e) {
    console.error('LiveKit token error', e);
    return res.status(500).json({ success: false, message: 'Failed to generate token' });
  }
});

// GET /api/livekit/ping - quick health check to verify route is deployed
router.get('/ping', (req, res) => {
  res.json({ success: true, message: 'livekit route is present' });
});

module.exports = router;
