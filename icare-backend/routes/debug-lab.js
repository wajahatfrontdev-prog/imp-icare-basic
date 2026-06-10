/**
 * Temporary debug route — DELETE after fixing
 * GET /api/debug-lab?secret=icare_debug_2026
 */
const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const { connectMongoDB } = require('../config/mongodb');
const User = require('../models/User');
const LabTestRequest = require('../models/LabTestRequest');
const LabProfile = require('../models/LabProfile');

router.get('/', async (req, res) => {
  if (req.query.secret !== 'icare_debug_2026') {
    return res.status(403).json({ error: 'Forbidden' });
  }
  try {
    await connectMongoDB();

    // All lab users
    const labUsers = await User.find({ role: { $in: ['lab', 'Lab', 'laboratory', 'Laboratory'] } }).lean();

    // All bookings
    const allBookings = await LabTestRequest.find().sort({ createdAt: -1 }).limit(20).lean();

    // For each lab user, count their bookings
    const labSummary = await Promise.all(labUsers.map(async (u) => {
      const count = await LabTestRequest.countDocuments({ lab_id: u._id });
      const profile = await LabProfile.findOne({ user_id: u._id }).lean();
      return {
        user_id: u._id.toString(),
        name: u.username || u.name,
        role: u.role,
        lab_name: profile?.lab_name,
        booking_count: count,
      };
    }));

    res.json({
      success: true,
      total_bookings: allBookings.length,
      lab_users: labSummary,
      recent_bookings: allBookings.map(b => ({
        _id: b._id.toString(),
        lab_id: b.lab_id?.toString(),
        patient_id: b.patient_id?.toString(),
        test_type: b.test_type,
        status: b.status,
        collection_type: b.collection_type,
        createdAt: b.createdAt,
      })),
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
