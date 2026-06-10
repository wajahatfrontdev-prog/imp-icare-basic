const express = require('express');
const router  = express.Router();
const mongoose = require('mongoose');
const { connectMongoDB } = require('../config/mongodb');
const { authMiddleware }  = require('../middleware/auth');
const Attendance  = require('../models/Attendance');
const Enrollment  = require('../models/Enrollment');

function toId(id) {
  try { return new mongoose.Types.ObjectId(id); } catch { return null; }
}

// ── INSTRUCTOR: create attendance session ─────────────────────────────────────
router.post('/', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const { courseId, sessionTitle, sessionDate, records } = req.body;
    if (!courseId || !sessionDate) return res.status(400).json({ success: false, message: 'courseId and sessionDate required' });
    const session = await Attendance.create({
      courseId, instructorId: req.user.id,
      sessionTitle: sessionTitle || 'Class Session',
      sessionDate: new Date(sessionDate),
      records: records || [],
    });
    res.json({ success: true, session });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── Get all sessions for a course ─────────────────────────────────────────────
router.get('/course/:courseId', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const sessions = await Attendance.find({ courseId: toId(req.params.courseId) })
      .sort({ sessionDate: -1 }).lean();
    res.json({ success: true, sessions });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── STUDENT: my attendance for a course ───────────────────────────────────────
router.get('/course/:courseId/my', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const studentId = req.user.id;
    const sessions  = await Attendance.find({ courseId: toId(req.params.courseId) })
      .sort({ sessionDate: -1 }).lean();
    const result = sessions.map(s => {
      const rec = s.records.find(r => r.studentId?.toString() === studentId);
      return {
        sessionId:    s._id,
        sessionTitle: s.sessionTitle,
        sessionDate:  s.sessionDate,
        status:       rec?.status || 'absent',
      };
    });
    const total   = result.length;
    const present = result.filter(r => r.status === 'present').length;
    res.json({ success: true, attendance: result, total, present, percentage: total ? Math.round((present/total)*100) : 0 });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── INSTRUCTOR: update attendance for a session ───────────────────────────────
router.put('/:sessionId', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const { records } = req.body;
    const session = await Attendance.findById(toId(req.params.sessionId));
    if (!session) return res.status(404).json({ success: false, message: 'Session not found' });
    session.records = records;
    await session.save();
    res.json({ success: true, session });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = router;
