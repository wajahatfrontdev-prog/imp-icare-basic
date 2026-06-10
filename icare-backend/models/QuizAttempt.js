const mongoose = require('mongoose');

const quizAttemptSchema = new mongoose.Schema({
  quizId: { type: mongoose.Schema.Types.ObjectId, ref: 'Quiz', required: true },
  studentId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  answers: [{
    questionId: String,
    answer: mongoose.Schema.Types.Mixed, // String or Array
    isCorrect: Boolean,
    pointsEarned: Number
  }],
  score: { type: Number, default: 0 },
  totalPoints: { type: Number, default: 0 },
  percentage: { type: Number, default: 0 },
  passed: { type: Boolean, default: false },
  startedAt: { type: Date, default: Date.now },
  submittedAt: Date,
  attemptNumber: { type: Number, default: 1 },
  timeSpent: Number, // seconds
}, { timestamps: true });

quizAttemptSchema.index({ quizId: 1, studentId: 1, attemptNumber: 1 }, { unique: true });

module.exports = mongoose.models.QuizAttempt || mongoose.model('QuizAttempt', quizAttemptSchema);
