const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const { connectMongoDB } = require('../config/mongodb');
const { authMiddleware } = require('../middleware/auth');
const Quiz = require('../models/Quiz');
const QuizAttempt = require('../models/QuizAttempt');
const Enrollment = require('../models/Enrollment');

function toId(id) {
  try { return new mongoose.Types.ObjectId(id); } catch { return null; }
}

// ── INSTRUCTOR: Create quiz ─────────────────────────────────────────────────
router.post('/', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const quiz = await Quiz.create(req.body);
    res.status(201).json({ success: true, quiz });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── Get quizzes for a course ────────────────────────────────────────────────
router.get('/course/:courseId', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const quizzes = await Quiz.find({ 
      courseId: toId(req.params.courseId), 
      isPublished: true 
    }).select('-questions.correctAnswer').lean();
    
    res.json({ success: true, quizzes });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── STUDENT: Get quiz (without answers) ─────────────────────────────────────
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const quiz = await Quiz.findById(toId(req.params.id)).lean();
    
    if (!quiz) {
      return res.status(404).json({ success: false, message: 'Quiz not found' });
    }

    // Remove correct answers for students
    const sanitizedQuiz = {
      ...quiz,
      questions: quiz.questions.map(q => ({
        _id: q._id,
        type: q.type,
        question: q.question,
        options: q.options,
        points: q.points,
        order: q.order
      }))
    };

    res.json({ success: true, quiz: sanitizedQuiz });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── STUDENT: Submit quiz attempt ────────────────────────────────────────────
router.post('/:id/submit', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const { answers, timeSpent } = req.body;
    const quizId = toId(req.params.id);
    const studentId = toId(req.user.id);

    const quiz = await Quiz.findById(quizId).lean();
    if (!quiz) {
      return res.status(404).json({ success: false, message: 'Quiz not found' });
    }

    // Check attempt count
    const previousAttempts = await QuizAttempt.countDocuments({ quizId, studentId });
    if (previousAttempts >= quiz.maxAttempts) {
      return res.status(400).json({ 
        success: false, 
        message: `Maximum ${quiz.maxAttempts} attempts allowed` 
      });
    }

    // Grade the quiz
    let totalPoints = 0;
    let earnedPoints = 0;
    const gradedAnswers = [];

    for (const question of quiz.questions) {
      totalPoints += question.points;
      const studentAnswer = answers.find(a => a.questionId === question._id.toString());
      
      if (studentAnswer) {
        let isCorrect = false;
        
        if (question.type === 'mcq' || question.type === 'true_false') {
          isCorrect = studentAnswer.answer === question.correctAnswer;
        } else if (question.type === 'short_answer') {
          isCorrect = studentAnswer.answer.toLowerCase().trim() === 
                     question.correctAnswer.toLowerCase().trim();
        }
        // Essay questions need manual grading
        
        const pointsEarned = isCorrect ? question.points : 0;
        earnedPoints += pointsEarned;

        gradedAnswers.push({
          questionId: question._id.toString(),
          answer: studentAnswer.answer,
          isCorrect,
          pointsEarned
        });
      }
    }

    const percentage = totalPoints > 0 ? (earnedPoints / totalPoints * 100) : 0;
    const passed = percentage >= quiz.passingScore;

    const attempt = await QuizAttempt.create({
      quizId,
      studentId,
      answers: gradedAnswers,
      score: earnedPoints,
      totalPoints,
      percentage: Math.round(percentage),
      passed,
      submittedAt: new Date(),
      attemptNumber: previousAttempts + 1,
      timeSpent
    });

    // Return with correct answers if allowed
    let result = attempt.toObject();
    if (quiz.showCorrectAnswers) {
      result.correctAnswers = quiz.questions.map(q => ({
        questionId: q._id,
        correctAnswer: q.correctAnswer,
        explanation: q.explanation
      }));
    }

    res.json({ success: true, attempt: result });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── STUDENT: Get my attempts for a quiz ─────────────────────────────────────
router.get('/:id/my-attempts', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const attempts = await QuizAttempt.find({
      quizId: toId(req.params.id),
      studentId: toId(req.user.id)
    }).sort({ attemptNumber: -1 }).lean();

    res.json({ success: true, attempts });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── INSTRUCTOR: Get all attempts for a quiz ─────────────────────────────────
router.get('/:id/attempts', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const attempts = await QuizAttempt.find({ quizId: toId(req.params.id) })
      .populate('studentId', 'name username email')
      .sort({ submittedAt: -1 })
      .lean();

    res.json({ success: true, attempts });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── INSTRUCTOR: Update quiz ─────────────────────────────────────────────────
router.put('/:id', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    const quiz = await Quiz.findByIdAndUpdate(
      toId(req.params.id),
      { $set: req.body },
      { new: true }
    );
    
    if (!quiz) {
      return res.status(404).json({ success: false, message: 'Quiz not found' });
    }

    res.json({ success: true, quiz });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// ── INSTRUCTOR: Delete quiz ─────────────────────────────────────────────────
router.delete('/:id', authMiddleware, async (req, res) => {
  try {
    await connectMongoDB();
    await Quiz.findByIdAndDelete(toId(req.params.id));
    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = router;
