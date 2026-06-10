# Dummy Data That Needs Backend Connection

## Summary
This document lists all screens and features that currently use dummy/mock/hardcoded data and need to be connected to the backend.

---

## 🔴 HIGH PRIORITY - User-Facing Features

### 1. Lifestyle Tracker (`lib/screens/lifestyle_tracker.dart`)
**Current State:** Uses hardcoded mock data
**Dummy Data:**
- Water intake: 1.2 liters (hardcoded)
- Sleep hours: 6.5 hours (hardcoded)
- Steps: 4500 (hardcoded)
- All data is local state, not persisted

**Backend Needed:**
- Create `Icare_backend-main/models/lifestyleTracking.js` with fields:
  - user, date, waterIntake, sleepHours, steps, exercise
- Create `Icare_backend-main/controllers/lifestyleController.js` with methods:
  - `getLifestyleData(userId, date)` - Get today's data
  - `updateLifestyleData(userId, data)` - Update/create entry
  - `getLifestyleHistory(userId, startDate, endDate)` - Get history
- Create routes at `/api/lifestyle`

**Frontend Changes:**
- Create `lib/services/lifestyle_service.dart`
- Update `lib/screens/lifestyle_tracker.dart` to:
  - Load data from API on init
  - Save data to API when user updates
  - Show loading/error states

**Requirements:** 18.16 (Integrate lifestyle tracking with Health Programs)

---

### 2. Instructor Assigned Learners (`lib/screens/instructor_assigned_learners.dart`)
**Current State:** Shows 4 hardcoded mock learners
**Dummy Data:**
- Names: "John Doe", "Dr. Sarah Smith", "Emma Wilson"
- Roles: Alternating Patient/Doctor
- Courses: "Diabetes Management 101", "Advanced Cardiac Care"
- Progress: 40%, 60%, 80%, 100%

**Backend Needed:**
- Already exists: `StudentCourse` model tracks enrollments
- Update `Icare_backend-main/controllers/instructorController.js`:
  - Add `getAssignedLearners(instructorId)` method
  - Query StudentCourse where instructor matches
  - Populate student user data and course data
  - Calculate progress from completed modules

**Frontend Changes:**
- Update `lib/services/instructor_service.dart`:
  - Add `getAssignedLearners()` method
- Update `lib/screens/instructor_assigned_learners.dart`:
  - Replace mock data with API call
  - Map real data to UI
  - Add error handling

**Requirements:** Instructor can view enrolled learners

---

### 3. SOAP Notes ICD-10 Code Search (`lib/screens/soap_notes_redesign.dart`)
**Current State:** Uses 5 hardcoded ICD-10 codes
**Dummy Data:**
```dart
{'code': 'I10', 'desc': 'Essential (primary) hypertension'},
{'code': 'E11.9', 'desc': 'Type 2 diabetes mellitus without complications'},
{'code': 'J06.9', 'desc': 'Acute upper respiratory infection, unspecified'},
{'code': 'M54.5', 'desc': 'Low back pain'},
{'code': 'K21.9', 'desc': 'Gastro-esophageal reflux disease without esophagitis'},
```

**Backend Needed:**
- Create `Icare_backend-main/models/icdCode.js` with fields:
  - code, description, category
- Create `Icare_backend-main/controllers/icdController.js` with methods:
  - `searchICDCodes(query)` - Search by code or description
  - `getICDCodesByCategory(category)` - Get codes by category
- Create routes at `/api/icd-codes`
- Seed database with common ICD-10 codes (at least 100-200 codes)

**Frontend Changes:**
- Create `lib/services/icd_service.dart`
- Update `lib/screens/soap_notes_redesign.dart`:
  - Replace `_searchICD10` method to call API
  - Add debouncing for search (wait 300ms after typing)
  - Show loading indicator during search
  - Handle no results case

**Requirements:** 5.7 (ICD-10 code search and autocomplete)

---

### 4. Credential Vault Document Upload (`lib/screens/credential_vault_screen.dart`)
**Current State:** Uses mock document URL
**Dummy Data:**
- `'documentUrl': 'https://example.com/mock-doc.pdf'`

**Backend Needed:**
- Already has credential model and controller
- Update `Icare_backend-main/controllers/credentialController.js`:
  - Add file upload handling (use multer)
  - Store files in `uploads/credentials/` directory
  - Return actual file URL

**Frontend Changes:**
- Update `lib/screens/credential_vault_screen.dart`:
  - Add file picker functionality
  - Upload actual file to backend
  - Use returned URL instead of mock URL
  - Show upload progress

**Requirements:** 9.1-9.5 (Credential vault with document upload)

---

### 5. Course Q&A Section (`lib/screens/view_course.dart`)
**Current State:** Shows mock Q&A with 3 hardcoded questions
**Dummy Data:**
- Mock questions count: 3
- Mock answer for first question only

**Backend Needed:**
- Create `Icare_backend-main/models/courseQuestion.js` with fields:
  - course, student, question, answer, instructor, createdAt, answeredAt
- Create `Icare_backend-main/controllers/courseQuestionController.js` with methods:
  - `getCourseQuestions(courseId)` - Get all Q&A for course
  - `askQuestion(courseId, studentId, question)` - Post new question
  - `answerQuestion(questionId, instructorId, answer)` - Instructor answers
- Create routes at `/api/course-questions`

**Frontend Changes:**
- Create `lib/services/course_question_service.dart`
- Update `lib/screens/view_course.dart`:
  - Load real Q&A from API
  - Allow students to post questions
  - Show instructor answers
  - Real-time updates when instructor answers

**Requirements:** Course Q&A functionality

---

## 🟡 MEDIUM PRIORITY - Analytics & Reporting

### 6. Pharmacy Top Selling Products (`lib/services/pharmacy_service.dart`)
**Current State:** Uses mock sales data
**Dummy Data:**
```dart
'sales': 100, // Mock value
'revenue': (m['price'] ?? 0) * 100,
```

**Backend Needed:**
- Update `Icare_backend-main/controllers/pharmacyController.js`:
  - Add `getTopSellingProducts(pharmacyId)` method
  - Query PharmacyOrder items, group by product
  - Calculate actual sales count and revenue
  - Return top 5-10 products

**Frontend Changes:**
- Update `lib/services/pharmacy_service.dart`:
  - Replace mock calculation with API call
  - Use real sales data in analytics

**Requirements:** Pharmacy analytics

---

## 🟢 LOW PRIORITY - UI Enhancements

### 7. Pusher Real-time Chat (`lib/services/pusher_service.dart`)
**Current State:** All Pusher code is commented out
**Status:** Intentionally disabled, not dummy data
**Note:** Pusher integration exists but is commented out. Can be enabled when needed.

---

### 8. Upload Prescription Fake Delay (`lib/screens/upload_prescription.dart`)
**Current State:** Uses 2-second fake delay
**Dummy Data:**
```dart
await Future.delayed(const Duration(seconds: 2));
```

**Backend Needed:**
- Already has prescription upload endpoint
- Just remove the fake delay

**Frontend Changes:**
- Remove `Future.delayed` line
- Actual API call already exists

---

### 9. Patient Profile Progress Indicators (`lib/screens/patient_profile_view.dart`)
**Current State:** Shows mock progress for health programs
**Dummy Data:**
```dart
_buildProgressRow('Diabetes Management', 0.75),
```

**Backend Needed:**
- Already tracked in StudentCourse model
- Just need to fetch and display real progress

**Frontend Changes:**
- Fetch enrolled courses with progress
- Display actual progress instead of hardcoded 0.75

---

## ✅ ALREADY CONNECTED (No Action Needed)

These were found in search but are already properly connected:
- ✅ Doctor appointments
- ✅ Lab bookings
- ✅ Pharmacy orders
- ✅ Medical records
- ✅ Prescriptions
- ✅ Notifications
- ✅ Chat messages
- ✅ Courses (enrollment, modules, progress)
- ✅ Gamification (points, badges, leaderboard)
- ✅ Subscriptions
- ✅ Referrals
- ✅ Lab supplies (just implemented)
- ✅ Health journey timeline
- ✅ Vitals tracking (has VitalService)

---

## 📊 Priority Implementation Order

### Phase 1 (Critical User Features):
1. **Lifestyle Tracker** - Patient health tracking
2. **ICD-10 Code Search** - Doctor workflow essential
3. **Instructor Assigned Learners** - Instructor dashboard

### Phase 2 (Enhanced Features):
4. **Credential Vault File Upload** - Document management
5. **Course Q&A** - Learning engagement
6. **Pharmacy Top Selling** - Analytics accuracy

### Phase 3 (Polish):
7. **Patient Profile Progress** - UI enhancement
8. **Upload Prescription Delay** - Remove fake delay

---

## 🔧 Implementation Checklist

For each feature:
- [ ] Create/update backend model
- [ ] Create/update backend controller
- [ ] Create/update backend routes
- [ ] Register routes in server.js
- [ ] Create/update frontend service
- [ ] Update frontend screen
- [ ] Test API endpoints
- [ ] Test frontend integration
- [ ] Handle loading states
- [ ] Handle error states
- [ ] Update documentation

---

## 📝 Notes

- Most core features are already connected to backend
- Remaining dummy data is mostly in:
  - Health/lifestyle tracking
  - Learning management system (LMS) features
  - Analytics calculations
  - Document uploads
- Priority should be on user-facing features that affect workflow
- Some "dummy" data is actually just placeholder UI (like empty states)
