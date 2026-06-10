const mongoose = require('mongoose');

const appointmentSchema = new mongoose.Schema({
  patient_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  doctor_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  appointment_date: { type: String },
  appointment_time: { type: String },
  consultation_type: { type: String, default: 'in-person' },
  notes: { type: String, default: '' },
  channel_name: { type: String }, // for video consultations
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'completed', 'cancelled', 'in_progress', 'missed'],
    default: 'pending',
  },
  // Patient rating after completed consultation (optional)
  rating: { type: Number, min: 1, max: 5 },
  ratingComment: { type: String, default: '' },
  ratedAt: { type: Date },
}, { timestamps: true });

module.exports = mongoose.models.Appointment || mongoose.model('Appointment', appointmentSchema);
