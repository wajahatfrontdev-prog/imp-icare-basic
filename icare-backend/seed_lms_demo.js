require('dotenv').config({ path: '.env.production' }); // Load production env
const mongoose = require('mongoose');
const { connectMongoDB } = require('./config/mongodb');
const Course = require('./models/Course');
const User = require('./models/User');
const Quiz = require('./models/Quiz');
const LiveSession = require('./models/LiveSession');

async function seedLMSDemo() {
  try {
    await connectMongoDB();
    console.log('🔗 Connected to MongoDB');

    // Find or create instructor
    let instructor = await User.findOne({ role: 'Instructor' });
    if (!instructor) {
      instructor = await User.findOne({ role: 'Doctor' });
    }
    if (!instructor) {
      console.log('❌ No instructor found. Please create a doctor/instructor account first.');
      process.exit(1);
    }

    console.log(`✅ Using instructor: ${instructor.username || instructor.name}`);

    // Create demo courses
    const courses = [
      {
        title: 'Diabetes Management & Care',
        description: 'Learn comprehensive diabetes management including diet, exercise, medication, and lifestyle changes. This course covers blood sugar monitoring, meal planning, and preventing complications.',
        category: 'HealthProgram',
        targetAudience: 'Patient',
        difficulty: 'Beginner',
        duration: 8,
        thumbnail: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800',
        visibility: 'public',
        isPublished: true,
        instructor_id: instructor._id,
        modules: [
          {
            title: 'Understanding Diabetes',
            description: 'Learn the basics of diabetes and how it affects your body',
            order: 0,
            lessons: [
              {
                title: 'What is Diabetes?',
                content: 'Introduction to diabetes types and causes',
                videoUrl: 'https://www.youtube.com/watch?v=wZAjVQWbMlE',
                duration: 15,
                order: 0
              },
              {
                title: 'Blood Sugar Monitoring',
                content: 'How to check and track your blood sugar levels',
                videoUrl: 'https://www.youtube.com/watch?v=example2',
                duration: 20,
                order: 1
              }
            ]
          },
          {
            title: 'Diet & Nutrition',
            description: 'Creating a healthy meal plan for diabetes',
            order: 1,
            lessons: [
              {
                title: 'Carbohydrate Counting',
                content: 'Understanding carbs and their impact on blood sugar',
                videoUrl: 'https://www.youtube.com/watch?v=example3',
                duration: 25,
                order: 0
              },
              {
                title: 'Meal Planning',
                content: 'Creating balanced meals for diabetes management',
                videoUrl: 'https://www.youtube.com/watch?v=example4',
                duration: 30,
                order: 1
              }
            ]
          }
        ],
        rating: 4.8,
        total_reviews: 156
      },
      {
        title: 'Heart Health Basics',
        description: 'Essential knowledge about cardiovascular health, prevention strategies, and lifestyle modifications for a healthy heart.',
        category: 'HealthProgram',
        targetAudience: 'Patient',
        difficulty: 'Beginner',
        duration: 6,
        thumbnail: 'https://images.unsplash.com/photo-1628348068343-c6a848d2b6dd?w=800',
        visibility: 'public',
        isPublished: true,
        instructor_id: instructor._id,
        modules: [
          {
            title: 'Heart Health Fundamentals',
            description: 'Understanding your cardiovascular system',
            order: 0,
            lessons: [
              {
                title: 'How Your Heart Works',
                content: 'Anatomy and function of the heart',
                videoUrl: 'https://www.youtube.com/watch?v=example5',
                duration: 18,
                order: 0
              }
            ]
          }
        ],
        rating: 4.9,
        total_reviews: 203
      },
      {
        title: 'Mental Wellness & Stress Management',
        description: 'Practical techniques for managing stress, anxiety, and improving mental health through mindfulness and healthy habits.',
        category: 'Wellness',
        targetAudience: 'Patient',
        difficulty: 'Beginner',
        duration: 5,
        thumbnail: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
        visibility: 'public',
        isPublished: true,
        instructor_id: instructor._id,
        modules: [
          {
            title: 'Understanding Stress',
            description: 'What is stress and how it affects you',
            order: 0,
            lessons: [
              {
                title: 'Types of Stress',
                content: 'Identifying different stress types',
                videoUrl: 'https://www.youtube.com/watch?v=example6',
                duration: 12,
                order: 0
              }
            ]
          }
        ],
        rating: 4.7,
        total_reviews: 89
      },
      {
        title: 'Clinical Skills for Healthcare Professionals',
        description: 'Advanced clinical skills training for doctors and nurses including patient assessment, diagnostic techniques, and treatment protocols.',
        category: 'Medical Training',
        targetAudience: 'Doctor',
        difficulty: 'Advanced',
        duration: 20,
        thumbnail: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800',
        visibility: 'public',
        isPublished: true,
        instructor_id: instructor._id,
        modules: [
          {
            title: 'Patient Assessment',
            description: 'Comprehensive patient evaluation techniques',
            order: 0,
            lessons: [
              {
                title: 'History Taking',
                content: 'Effective patient history documentation',
                videoUrl: 'https://www.youtube.com/watch?v=example7',
                duration: 45,
                order: 0
              }
            ]
          }
        ],
        rating: 4.9,
        total_reviews: 67
      },
      {
        title: 'Nutrition & Healthy Eating',
        description: 'Complete guide to nutrition, meal planning, and developing healthy eating habits for optimal health.',
        category: 'Wellness',
        targetAudience: 'Patient',
        difficulty: 'Beginner',
        duration: 7,
        thumbnail: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
        visibility: 'public',
        isPublished: true,
        instructor_id: instructor._id,
        modules: [
          {
            title: 'Nutrition Basics',
            description: 'Understanding macronutrients and micronutrients',
            order: 0,
            lessons: [
              {
                title: 'Macronutrients Explained',
                content: 'Proteins, carbs, and fats',
                videoUrl: 'https://www.youtube.com/watch?v=example8',
                duration: 22,
                order: 0
              }
            ]
          }
        ],
        rating: 4.6,
        total_reviews: 124
      }
    ];

    console.log('📚 Creating demo courses...');
    const createdCourses = [];
    for (const courseData of courses) {
      const existing = await Course.findOne({ 
        title: courseData.title, 
        instructor_id: instructor._id 
      });
      
      if (existing) {
        console.log(`⏭️  Course already exists: ${courseData.title}`);
        createdCourses.push(existing);
      } else {
        const course = await Course.create(courseData);
        console.log(`✅ Created: ${course.title}`);
        createdCourses.push(course);
      }
    }

    // Create demo quizzes
    console.log('\n📝 Creating demo quizzes...');
    if (createdCourses.length > 0) {
      const diabetesCourse = createdCourses[0];
      const existingQuiz = await Quiz.findOne({ courseId: diabetesCourse._id });
      
      if (!existingQuiz) {
        const quiz = await Quiz.create({
          courseId: diabetesCourse._id,
          moduleId: diabetesCourse.modules[0]._id.toString(),
          title: 'Understanding Diabetes - Quiz',
          description: 'Test your knowledge about diabetes basics',
          questions: [
            {
              type: 'mcq',
              question: 'What is the normal fasting blood sugar level?',
              options: ['70-100 mg/dL', '100-125 mg/dL', '126-150 mg/dL', 'Above 150 mg/dL'],
              correctAnswer: '70-100 mg/dL',
              points: 10,
              explanation: 'Normal fasting blood sugar is between 70-100 mg/dL',
              order: 0
            },
            {
              type: 'true_false',
              question: 'Type 2 diabetes can be managed with lifestyle changes.',
              options: ['True', 'False'],
              correctAnswer: 'True',
              points: 10,
              explanation: 'Diet, exercise, and weight management can help control Type 2 diabetes',
              order: 1
            },
            {
              type: 'mcq',
              question: 'Which food has the highest impact on blood sugar?',
              options: ['Vegetables', 'Proteins', 'Carbohydrates', 'Fats'],
              correctAnswer: 'Carbohydrates',
              points: 10,
              explanation: 'Carbohydrates have the most direct impact on blood sugar levels',
              order: 2
            }
          ],
          timeLimit: 15,
          passingScore: 70,
          maxAttempts: 3,
          shuffleQuestions: true,
          showCorrectAnswers: true,
          isPublished: true
        });
        console.log(`✅ Created quiz: ${quiz.title}`);
      } else {
        console.log('⏭️  Quiz already exists');
      }
    }

    // Create demo live session
    console.log('\n🎥 Creating demo live session...');
    if (createdCourses.length > 0) {
      const diabetesCourse = createdCourses[0];
      const futureDate = new Date();
      futureDate.setDate(futureDate.getDate() + 7); // 7 days from now
      
      const existingSession = await LiveSession.findOne({ 
        courseId: diabetesCourse._id,
        status: 'scheduled'
      });
      
      if (!existingSession) {
        const session = await LiveSession.create({
          courseId: diabetesCourse._id,
          instructorId: instructor._id,
          title: 'Live Q&A: Diabetes Management',
          description: 'Join us for a live session where we answer your questions about diabetes management',
          scheduledAt: futureDate,
          duration: 60,
          meetingLink: 'https://meet.google.com/example-link',
          meetingId: 'example-123',
          meetingPassword: 'demo123',
          status: 'scheduled',
          maxParticipants: 100,
          isRecorded: true
        });
        console.log(`✅ Created live session: ${session.title}`);
      } else {
        console.log('⏭️  Live session already exists');
      }
    }

    console.log('\n🎉 LMS demo data seeded successfully!');
    console.log(`\n📊 Summary:`);
    console.log(`   - Courses: ${createdCourses.length}`);
    console.log(`   - Instructor: ${instructor.username || instructor.name}`);
    console.log(`\n✅ You can now:`);
    console.log(`   1. Visit /lms/catalog to browse courses`);
    console.log(`   2. Login as instructor to manage courses`);
    console.log(`   3. Test the complete LMS flow`);

    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding LMS demo data:', error);
    process.exit(1);
  }
}

seedLMSDemo();
