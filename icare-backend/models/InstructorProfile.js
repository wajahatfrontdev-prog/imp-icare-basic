const mongoose = require('mongoose');

const instructorProfileSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
  bio: String,
  specialization: String,
  experience_years: { type: Number, default: 0 },
  profile_image: String,
  rating: { type: Number, default: 0 },
  total_reviews: { type: Number, default: 0 },
}, { timestamps: true });

module.exports = mongoose.models.InstructorProfile || mongoose.model('InstructorProfile', instructorProfileSchema);
