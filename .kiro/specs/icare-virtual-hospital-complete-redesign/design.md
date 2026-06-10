# Design Document: iCare Virtual Hospital Platform Redesign

## Overview

The iCare Virtual Hospital Platform is a comprehensive healthcare ecosystem that integrates patients, doctors, laboratories, pharmacies, and healthcare educators into a unified digital environment. This design document provides the technical architecture and specifications for implementing all 45 requirements defined in the requirements document.

### System Context

The platform consists of:
- **Frontend**: Flutter/Dart mobile application with web support
- **Backend**: Node.js/Express REST API server
- **Database**: MongoDB for data persistence
- **Real-time Communication**: Pusher for notifications and chat
- **Video Consultation**: Agora SDK integration
- **Payment Processing**: Third-party payment gateway integration
- **Cloud Storage**: For medical documents, images, and reports

### Design Goals

1. **Integrated Healthcare Workflow**: Seamless coordination between consultations, prescriptions, lab tests, and education
2. **Role-Based Architecture**: Specialized dashboards and workflows for 7 distinct user roles
3. **Clinical Quality**: Professional documentation standards with SOAP notes and digital health records
4. **Scalability**: Support for concurrent users and growing data volumes
5. **Security**: HIPAA-compliant data handling with encryption and access controls
6. **User Experience**: Intuitive interfaces with healthcare-focused design language
7. **Business Intelligence**: Comprehensive analytics and reporting for all stakeholders

### Key Architectural Principles

- **Separation of Concerns**: Clear boundaries between presentation, business logic, and data layers
- **API-First Design**: RESTful APIs enabling mobile and web clients
- **Event-Driven Architecture**: Real-time notifications and updates using Pusher
- **Data Integrity**: Referential integrity through MongoDB relationships
- **Extensibility**: Modular design allowing feature additions without core changes
- **Testability**: Clear interfaces enabling unit, integration, and end-to-end testing

## Architecture

### System Architecture Overview

The platform follows a three-tier architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  ┌──────────────────────┐    ┌──────────────────────┐      │
│  │  Flutter Mobile App  │    │   Flutter Web App    │      │
│  │  (iOS/Android)       │    │   (Browser)          │      │
│  └──────────────────────┘    └──────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
                    HTTPS/REST API
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Application Layer                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │           Node.js/Express API Server                  │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐     │  │
│  │  │Controllers │  │  Services  │  │ Middleware │     │  │
│  │  └────────────┘  └────────────┘  └────────────┘     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   MongoDB    │  │ Cloud Storage│  │  Redis Cache │     │
│  │   Database   │  │  (Documents) │  │  (Sessions)  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   External Services                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Pusher  │  │  Agora   │  │ Payment  │  │ Firebase │   │
│  │  (Chat)  │  │  (Video) │  │ Gateway  │  │   (FCM)  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Role-Based Access Control Architecture

The platform implements role-based access control (RBAC) with 7 distinct user roles:

**Public Roles** (Self-signup enabled):
- Patient
- Doctor

**Controlled Roles** (Admin-managed only):
- Lab_Technician
- Pharmacist
- Instructor
- Student

**Administrative Roles**:
- Admin
- Super_Admin

Each role has:
- Dedicated dashboard with role-specific widgets
- Restricted API endpoints based on permissions
- Customized navigation and features
- Role-specific data models and relationships

### Authentication and Authorization Flow

```
User Login Request
      │
      ▼
┌─────────────────┐
│ Validate        │
│ Credentials     │
└─────────────────┘
      │
      ▼
┌─────────────────┐
│ Generate JWT    │
│ Token           │
└─────────────────┘
      │
      ▼
┌─────────────────┐
│ Detect User     │
│ Role            │
└─────────────────┘
      │
      ▼
┌─────────────────────────────────────────┐
│ Route to Role-Specific Dashboard        │
│                                          │
│ Patient → Patient Dashboard              │
│ Doctor → Doctor Dashboard                │
│ Lab_Technician → Laboratory Dashboard    │
│ Pharmacist → Pharmacy Dashboard          │
│ Instructor → Instructor Dashboard        │
│ Student → Student Dashboard              │
│ Admin → Admin Panel                      │
└─────────────────────────────────────────┘
```

### Integrated Healthcare Workflow Architecture

The platform's core value is the integration of healthcare services:

```
┌──────────────────────────────────────────────────────────┐
│                   Patient Journey                         │
└──────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────┐
│  1. Book Appointment with Doctor                         │
└──────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────┐
│  2. Video Consultation                                    │
│     - Doctor creates SOAP notes                          │
│     - Doctor makes diagnosis                             │
└──────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
┌─────────────────────────┐   ┌─────────────────────────┐
│  3a. Prescription       │   │  3b. Lab Test Order     │
│      Created            │   │      Created            │
└─────────────────────────┘   └─────────────────────────┘
            │                             │
            ▼                             ▼
┌─────────────────────────┐   ┌─────────────────────────┐
│  4a. Send to Pharmacy   │   │  4b. Lab Processes Test │
└─────────────────────────┘   └─────────────────────────┘
            │                             │
            ▼                             ▼
┌─────────────────────────┐   ┌─────────────────────────┐
│  5a. Pharmacy Fulfills  │   │  5b. Lab Uploads Report │
└─────────────────────────┘   └─────────────────────────┘
            │                             │
            └─────────┬───────────────────┘
                      ▼
┌──────────────────────────────────────────────────────────┐
│  6. Health Program Assignment                            │
│     - Patient receives educational content               │
│     - Tracks progress                                    │
└──────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────┐
│  7. Follow-up Appointment (if needed)                    │
└──────────────────────────────────────────────────────────┘
```

### Real-Time Communication Architecture

The platform uses Pusher for real-time features:

```
┌─────────────────────────────────────────────────────────┐
│                    Pusher Channels                       │
└─────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Chat         │    │ Notifications│    │ Status       │
│ Messages     │    │ (Real-time)  │    │ Updates      │
└──────────────┘    └──────────────┘    └──────────────┘

Channel Naming Convention:
- private-chat-{userId1}-{userId2}
- private-notifications-{userId}
- presence-consultation-{appointmentId}
```

### Video Consultation Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Agora Video SDK                        │
└──────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Video Stream │    │ Audio Stream │    │ Screen Share │
└──────────────┘    └──────────────┘    └──────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              ▼
┌──────────────────────────────────────────────────────────┐
│  Consultation Session                                     │
│  - Timer tracking                                        │
│  - Note-taking interface                                 │
│  - Document sharing                                      │
│  - Recording (with consent)                              │
└──────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### Frontend Architecture (Flutter)

The Flutter application follows a layered architecture:

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── user.dart
│   ├── doctor.dart
│   ├── appointment.dart
│   ├── prescription.dart
│   ├── lab_request.dart
│   ├── medical_record.dart
│   ├── course.dart
│   └── ...
├── providers/                   # State management (Provider pattern)
│   ├── auth_provider.dart
│   ├── appointment_provider.dart
│   ├── chat_provider.dart
│   └── ...
├── services/                    # API and business logic
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── doctor_service.dart
│   ├── appointment_service.dart
│   ├── prescription_service.dart
│   ├── laboratory_service.dart
│   ├── pharmacy_service.dart
│   ├── medical_record_service.dart
│   ├── notification_service.dart
│   ├── pusher_service.dart
│   ├── fcm_service.dart
│   └── ...
├── screens/                     # UI screens
│   ├── auth/
│   │   ├── login.dart
│   │   ├── signup.dart
│   │   ├── role_selection.dart
│   │   └── verify_email.dart
│   ├── patient/
│   │   ├── patient_dashboard.dart
│   │   ├── book_appointment.dart
│   │   ├── my_appointments.dart
│   │   ├── patient_prescriptions.dart
│   │   ├── patient_medical_records.dart
│   │   ├── health_tracker.dart
│   │   └── my_learning.dart
│   ├── doctor/
│   │   ├── doctor_dashboard.dart
│   │   ├── doctor_appointments.dart
│   │   ├── patient_history_view.dart
│   │   ├── soap_notes.dart
│   │   ├── prescription_templates.dart
│   │   ├── doctor_availability.dart
│   │   └── doctor_analytics.dart
│   ├── laboratory/
│   │   ├── laboratory_dashboard.dart
│   │   ├── lab_bookings_management.dart
│   │   ├── lab_tests_management.dart
│   │   └── lab_analytics.dart
│   ├── pharmacy/
│   │   ├── pharmacist_dashboard.dart
│   │   ├── pharmacy_orders.dart
│   │   ├── pharmacy_inventory.dart
│   │   └── pharmacy_analytics.dart
│   ├── instructor/
│   │   ├── instructor_dashboard.dart
│   │   ├── instructor_courses_management.dart
│   │   ├── instructor_create_course.dart
│   │   └── instructor_precautions_management.dart
│   ├── admin/
│   │   ├── admin_dashboard.dart
│   │   ├── user_management.dart
│   │   ├── quality_monitoring.dart
│   │   └── system_analytics.dart
│   └── shared/
│       ├── chat_screen.dart
│       ├── video_consultation.dart
│       ├── notifications.dart
│       └── profile_edit.dart
├── widgets/                     # Reusable UI components
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── appointment_card.dart
│   ├── prescription_card.dart
│   ├── doctor_card.dart
│   ├── course_card.dart
│   └── ...
└── utils/                       # Utilities and helpers
    ├── constants.dart
    ├── api_constants.dart
    ├── shared_pref.dart
    ├── validators.dart
    └── date_formatter.dart
```

### Backend Architecture (Node.js)

The Node.js backend follows MVC pattern with service layer:

```
Icare_backend-main/
├── server.js                    # App entry point
├── config/
│   ├── db.js                    # MongoDB connection
│   ├── pusher.config.js         # Pusher configuration
│   └── firebase.js              # Firebase admin SDK
├── models/                      # Mongoose schemas
│   ├── user.js
│   ├── doctor.js
│   ├── patient.js
│   ├── appointment.js
│   ├── prescription.js
│   ├── prescriptionTemplate.js
│   ├── labRequest.js
│   ├── laboratory.js
│   ├── pharmacyOrder.js
│   ├── pharmacy.js
│   ├── medicalRecord.js
│   ├── course.js
│   ├── instructor.js
│   ├── student.js
│   ├── notification.js
│   ├── chatMessage.js
│   ├── subscription.js
│   ├── clinicalAudit.js
│   └── ...
├── controllers/                 # Request handlers
│   ├── authController.js
│   ├── userController.js
│   ├── doctorController.js
│   ├── appointmentController.js
│   ├── prescriptionController.js
│   ├── laboratoryController.js
│   ├── pharmacyController.js
│   ├── medicalRecordController.js
│   ├── instructorController.js
│   ├── notificationController.js
│   ├── chatController.js
│   ├── analyticsController.js
│   └── ...
├── services/                    # Business logic
│   ├── emailService.js
│   ├── smsService.js
│   ├── notificationService.js
│   ├── paymentService.js
│   ├── analyticsService.js
│   └── ...
├── middleware/
│   ├── authMiddleware.js        # JWT verification
│   ├── roleMiddleware.js        # Role-based access
│   ├── errorMiddleware.js       # Error handling
│   └── validationMiddleware.js  # Input validation
├── routes/                      # API routes
│   ├── authRoutes.js
│   ├── userRoutes.js
│   ├── doctorRoutes.js
│   ├── appointmentsRoutes.js
│   ├── prescriptionRoutes.js
│   ├── laboratoryRoutes.js
│   ├── pharmacyRoutes.js
│   ├── medicalRecordRoutes.js
│   ├── instructorRoutes.js
│   ├── chatRoutes.js
│   ├── notificationRoutes.js
│   └── ...
├── utils/
│   ├── tokenGenerator.js
│   ├── validators.js
│   └── helpers.js
└── scripts/                     # Test data and utilities
    ├── add_test_doctors.js
    ├── add_test_patients.js
    └── ...
```

### State Management Strategy (Flutter)

The application uses the Provider pattern for state management:

**Provider Types:**
1. **AuthProvider**: User authentication state, login/logout, token management
2. **AppointmentProvider**: Appointment booking, status updates, history
3. **ChatProvider**: Real-time chat messages, conversation list
4. **NotificationProvider**: Notification list, unread count, mark as read
5. **DoctorProvider**: Doctor list, search, filters, availability
6. **PrescriptionProvider**: Prescription list, status tracking
7. **LabProvider**: Lab requests, reports, status updates
8. **PharmacyProvider**: Pharmacy orders, inventory
9. **CourseProvider**: Courses, health programs, progress tracking
10. **HealthTrackerProvider**: Health metrics, lifestyle tracking

**Provider Pattern Example:**

```dart
class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await AuthService.login(email, password);
      _user = response.user;
      _token = response.token;
      await SharedPref.saveToken(_token!);
      await SharedPref.saveUser(_user!);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> logout() async {
    _user = null;
    _token = null;
    await SharedPref.clearAll();
    notifyListeners();
  }
}
```

### API Service Layer (Flutter)

All API calls go through a centralized service layer:

```dart
class ApiService {
  static final String baseUrl = ApiConstants.baseUrl;
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ));
  
  static Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final token = await SharedPref.getToken();
      final response = await _dio.get(
        endpoint,
        queryParameters: params,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  static Future<Response> post(String endpoint, dynamic data) async {
    try {
      final token = await SharedPref.getToken();
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  static AppException _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return AppException('Connection timeout. Please check your internet.');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return AppException('Server is taking too long to respond.');
    } else if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message = error.response!.data['message'] ?? 'Something went wrong';
      return AppException(message, statusCode: statusCode);
    } else {
      return AppException('Unable to connect. Please check your internet.');
    }
  }
}
```


## Data Models

### Core Data Models

#### User Model

```javascript
// MongoDB Schema
const UserSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true, lowercase: true },
  password: { type: String, required: true, minlength: 6 },
  phoneNumber: { type: String },
  role: {
    type: String,
    enum: ['Patient', 'Doctor', 'Lab_Technician', 'Pharmacist', 'Instructor', 'Student', 'Admin', 'Super_Admin'],
    required: true
  },
  isEmailVerified: { type: Boolean, default: false },
  emailVerificationToken: { type: String },
  emailVerificationExpiry: { type: Date },
  resetPasswordToken: { type: String },
  resetPasswordExpiry: { type: Date },
  twoFactorEnabled: { type: Boolean, default: false },
  twoFactorSecret: { type: String },
  biometricEnabled: { type: Boolean, default: false },
  fcmToken: { type: String },
  lastLogin: { type: Date },
  isActive: { type: Boolean, default: true },
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // For controlled users
  profileCompleted: { type: Boolean, default: false }
}, { timestamps: true });
```

```dart
// Flutter Model
class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final UserRole role;
  final bool isEmailVerified;
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final bool isActive;
  final bool profileCompleted;
  final DateTime createdAt;
  final DateTime? lastLogin;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.isEmailVerified,
    this.twoFactorEnabled = false,
    this.biometricEnabled = false,
    this.isActive = true,
    this.profileCompleted = false,
    required this.createdAt,
    this.lastLogin,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: UserRole.fromString(json['role']),
      isEmailVerified: json['isEmailVerified'] ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      biometricEnabled: json['biometricEnabled'] ?? false,
      isActive: json['isActive'] ?? true,
      profileCompleted: json['profileCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }
}

enum UserRole {
  patient,
  doctor,
  labTechnician,
  pharmacist,
  instructor,
  student,
  admin,
  superAdmin;
  
  static UserRole fromString(String role) {
    switch (role) {
      case 'Patient': return UserRole.patient;
      case 'Doctor': return UserRole.doctor;
      case 'Lab_Technician': return UserRole.labTechnician;
      case 'Pharmacist': return UserRole.pharmacist;
      case 'Instructor': return UserRole.instructor;
      case 'Student': return UserRole.student;
      case 'Admin': return UserRole.admin;
      case 'Super_Admin': return UserRole.superAdmin;
      default: throw Exception('Unknown role: $role');
    }
  }
}
```

#### Patient Model

```javascript
const PatientSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
  dateOfBirth: { type: Date },
  gender: { type: String, enum: ['Male', 'Female', 'Other'] },
  bloodGroup: { type: String, enum: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'] },
  address: {
    street: String,
    city: String,
    state: String,
    country: String,
    postalCode: String
  },
  emergencyContact: {
    name: String,
    relationship: String,
    phoneNumber: String
  },
  allergies: [String],
  chronicConditions: [String],
  currentMedications: [String],
  insuranceInfo: {
    provider: String,
    policyNumber: String,
    expiryDate: Date
  },
  familyMembers: [{
    name: String,
    relationship: String,
    dateOfBirth: Date,
    patientId: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient' }
  }],
  subscriptionPlan: { type: mongoose.Schema.Types.ObjectId, ref: 'Subscription' },
  gamificationPoints: { type: Number, default: 0 },
  achievements: [String],
  preferredLanguage: { type: String, default: 'English' }
}, { timestamps: true });
```

#### Doctor Model

```javascript
const DoctorSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
  specialization: { type: String, required: true },
  subSpecialties: [String],
  licenseNumber: { type: String, required: true, unique: true },
  licenseExpiryDate: { type: Date },
  degrees: [String],
  experience: { type: Number }, // Years of experience
  bio: { type: String, maxlength: 1000 },
  languages: [String],
  consultationType: { type: String, enum: ['InPerson', 'Online', 'Both'], default: 'Both' },
  consultationFee: {
    online: { type: Number, required: true },
    inPerson: { type: Number },
    urgent: { type: Number }
  },
  clinicInfo: {
    name: String,
    address: String,
    city: String,
    state: String,
    country: String
  },
  availability: {
    monday: { enabled: Boolean, slots: [{ start: String, end: String }] },
    tuesday: { enabled: Boolean, slots: [{ start: String, end: String }] },
    wednesday: { enabled: Boolean, slots: [{ start: String, end: String }] },
    thursday: { enabled: Boolean, slots: [{ start: String, end: String }] },
    friday: { enabled: Boolean, slots: [{ start: String, end: String }] },
    saturday: { enabled: Boolean, slots: [{ start: String, end: String }] },
    sunday: { enabled: Boolean, slots: [{ start: String, end: String }] }
  },
  slotDuration: { type: Number, default: 30 }, // Minutes
  maxAppointmentsPerDay: { type: Number, default: 20 },
  bufferTime: { type: Number, default: 5 }, // Minutes between appointments
  unavailableDates: [Date],
  isVerified: { type: Boolean, default: false },
  verificationDocuments: [String], // URLs to uploaded documents
  verifiedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  verifiedAt: { type: Date },
  ratings: {
    average: { type: Number, default: 0 },
    count: { type: Number, default: 0 },
    communication: { type: Number, default: 0 },
    professionalism: { type: Number, default: 0 },
    diagnosisQuality: { type: Number, default: 0 }
  },
  totalConsultations: { type: Number, default: 0 },
  acceptingNewPatients: { type: Boolean, default: true }
}, { timestamps: true });
```

#### Appointment Model

```javascript
const AppointmentSchema = new mongoose.Schema({
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  appointmentDate: { type: Date, required: true },
  timeSlot: { 
    start: { type: String, required: true },
    end: { type: String, required: true }
  },
  consultationType: { type: String, enum: ['Online', 'InPerson'], required: true },
  reason: { type: String },
  symptoms: [String],
  urgency: { type: String, enum: ['Normal', 'Urgent'], default: 'Normal' },
  status: {
    type: String,
    enum: ['Pending', 'Confirmed', 'InProgress', 'Completed', 'Cancelled', 'NoShow'],
    default: 'Pending'
  },
  paymentStatus: {
    type: String,
    enum: ['Pending', 'Paid', 'Refunded'],
    default: 'Pending'
  },
  paymentAmount: { type: Number },
  paymentId: { type: String },
  videoCallDetails: {
    channelName: String,
    token: String,
    startedAt: Date,
    endedAt: Date,
    duration: Number // Minutes
  },
  intakeNotes: {
    chiefComplaint: String,
    historyOfPresentIllness: String,
    pastMedicalHistory: String,
    medications: String,
    allergies: String,
    socialHistory: String,
    familyHistory: String,
    reviewOfSystems: String
  },
  soapNotes: { type: mongoose.Schema.Types.ObjectId, ref: 'SOAPNote' },
  prescriptions: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Prescription' }],
  labRequests: [{ type: mongoose.Schema.Types.ObjectId, ref: 'LabRequest' }],
  referral: { type: mongoose.Schema.Types.ObjectId, ref: 'Referral' },
  followUpDate: { type: Date },
  followUpAppointment: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment' },
  cancellationReason: { type: String },
  cancelledBy: { type: String, enum: ['Patient', 'Doctor', 'System'] },
  cancelledAt: { type: Date },
  rating: {
    stars: { type: Number, min: 1, max: 5 },
    communication: { type: Number, min: 1, max: 5 },
    professionalism: { type: Number, min: 1, max: 5 },
    diagnosisQuality: { type: Number, min: 1, max: 5 },
    review: String,
    createdAt: Date
  },
  doctorResponse: { type: String }
}, { timestamps: true });
```

#### SOAP Notes Model

```javascript
const SOAPNoteSchema = new mongoose.Schema({
  appointment: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment', required: true },
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  subjective: {
    chiefComplaint: { type: String, required: true },
    historyOfPresentIllness: String,
    reviewOfSystems: String,
    patientConcerns: String
  },
  objective: {
    vitalSigns: {
      bloodPressure: String,
      heartRate: Number,
      temperature: Number,
      respiratoryRate: Number,
      oxygenSaturation: Number,
      weight: Number,
      height: Number,
      bmi: Number
    },
    physicalExamination: String,
    labResults: String,
    imagingResults: String
  },
  assessment: {
    diagnosis: [String],
    differentialDiagnosis: [String],
    clinicalImpression: String,
    icdCodes: [String]
  },
  plan: {
    treatment: String,
    medications: [String],
    labTests: [String],
    imaging: [String],
    referrals: [String],
    followUp: String,
    patientEducation: String,
    healthPrograms: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Course' }]
  },
  attachments: [{
    type: String,
    url: String,
    uploadedAt: Date
  }],
  isFinalized: { type: Boolean, default: false },
  finalizedAt: { type: Date },
  versionHistory: [{
    modifiedAt: Date,
    modifiedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    changes: String
  }]
}, { timestamps: true });
```

#### Prescription Model

```javascript
const PrescriptionSchema = new mongoose.Schema({
  appointment: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment', required: true },
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  medications: [{
    name: { type: String, required: true },
    genericName: String,
    dosage: { type: String, required: true },
    frequency: { type: String, required: true },
    duration: { type: String, required: true },
    instructions: String,
    quantity: Number,
    refills: { type: Number, default: 0 }
  }],
  diagnosis: [String],
  notes: String,
  status: {
    type: String,
    enum: ['Active', 'SentToPharmacy', 'Preparing', 'Dispatched', 'Delivered', 'Completed', 'Cancelled'],
    default: 'Active'
  },
  pharmacyOrder: { type: mongoose.Schema.Types.ObjectId, ref: 'PharmacyOrder' },
  expiryDate: { type: Date },
  isValid: { type: Boolean, default: true }
}, { timestamps: true });
```

#### Lab Request Model

```javascript
const LabRequestSchema = new mongoose.Schema({
  appointment: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment' },
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  laboratory: { type: mongoose.Schema.Types.ObjectId, ref: 'Laboratory' },
  tests: [{
    name: { type: String, required: true },
    category: String,
    code: String
  }],
  diagnosis: String,
  clinicalNotes: String,
  urgency: { type: String, enum: ['Normal', 'Urgent', 'STAT'], default: 'Normal' },
  status: {
    type: String,
    enum: ['Pending', 'Accepted', 'SampleCollected', 'InProgress', 'Completed', 'Cancelled'],
    default: 'Pending'
  },
  sampleCollectionDate: { type: Date },
  reportUploadDate: { type: Date },
  reportUrl: String,
  results: [{
    testName: String,
    value: String,
    unit: String,
    referenceRange: String,
    isAbnormal: Boolean,
    notes: String
  }],
  interpretation: String,
  technician: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  paymentStatus: { type: String, enum: ['Pending', 'Paid'], default: 'Pending' },
  paymentAmount: Number
}, { timestamps: true });
```

#### Medical Record Model

```javascript
const MedicalRecordSchema = new mongoose.Schema({
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  recordType: {
    type: String,
    enum: ['Consultation', 'Prescription', 'LabReport', 'Diagnosis', 'Allergy', 'Immunization', 'Surgery', 'Hospitalization', 'PersonalNote'],
    required: true
  },
  title: { type: String, required: true },
  description: String,
  date: { type: Date, required: true },
  doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  appointment: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment' },
  soapNotes: { type: mongoose.Schema.Types.ObjectId, ref: 'SOAPNote' },
  prescription: { type: mongoose.Schema.Types.ObjectId, ref: 'Prescription' },
  labRequest: { type: mongoose.Schema.Types.ObjectId, ref: 'LabRequest' },
  attachments: [{
    fileName: String,
    fileUrl: String,
    fileType: String,
    uploadedAt: Date
  }],
  tags: [String],
  isShared: { type: Boolean, default: false },
  sharedWith: [{
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    sharedAt: Date,
    expiresAt: Date
  }],
  accessLog: [{
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    accessedAt: Date,
    action: String
  }]
}, { timestamps: true });
```

#### Pharmacy Order Model

```javascript
const PharmacyOrderSchema = new mongoose.Schema({
  prescription: { type: mongoose.Schema.Types.ObjectId, ref: 'Prescription', required: true },
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  pharmacy: { type: mongoose.Schema.Types.ObjectId, ref: 'Pharmacy', required: true },
  medications: [{
    name: String,
    dosage: String,
    quantity: Number,
    price: Number
  }],
  totalAmount: { type: Number, required: true },
  deliveryAddress: {
    street: String,
    city: String,
    state: String,
    postalCode: String,
    phoneNumber: String
  },
  status: {
    type: String,
    enum: ['Pending', 'Accepted', 'Preparing', 'Dispatched', 'Delivered', 'Cancelled'],
    default: 'Pending'
  },
  pharmacist: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  acceptedAt: { type: Date },
  dispatchedAt: { type: Date },
  deliveredAt: { type: Date },
  trackingNumber: String,
  paymentStatus: { type: String, enum: ['Pending', 'Paid'], default: 'Pending' },
  paymentId: String
}, { timestamps: true });
```

#### Course Model (LMS)

```javascript
const CourseSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  instructor: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  category: {
    type: String,
    enum: ['HealthProgram', 'ProfessionalCourse'],
    required: true
  },
  targetAudience: {
    type: String,
    enum: ['Patient', 'Doctor', 'Both'],
    required: true
  },
  healthConditions: [String], // For health programs
  difficulty: { type: String, enum: ['Beginner', 'Intermediate', 'Advanced'] },
  duration: { type: Number }, // Hours
  modules: [{
    title: String,
    description: String,
    order: Number,
    lessons: [{
      title: String,
      content: String,
      videoUrl: String,
      duration: Number,
      order: Number,
      resources: [{
        title: String,
        url: String,
        type: String
      }]
    }],
    quiz: {
      questions: [{
        question: String,
        options: [String],
        correctAnswer: Number,
        explanation: String
      }],
      passingScore: Number
    }
  }],
  thumbnail: String,
  isPublished: { type: Boolean, default: false },
  publishedAt: { type: Date },
  enrollmentCount: { type: Number, default: 0 },
  rating: {
    average: { type: Number, default: 0 },
    count: { type: Number, default: 0 }
  }
}, { timestamps: true });
```

#### Course Enrollment Model

```javascript
const CourseEnrollmentSchema = new mongoose.Schema({
  course: { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  assignedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Doctor who assigned
  appointment: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment' }, // Related consultation
  enrollmentDate: { type: Date, default: Date.now },
  status: {
    type: String,
    enum: ['NotStarted', 'InProgress', 'Completed'],
    default: 'NotStarted'
  },
  progress: {
    completedModules: [Number],
    completedLessons: [{ moduleIndex: Number, lessonIndex: Number }],
    quizScores: [{ moduleIndex: Number, score: Number, attempts: Number }],
    overallPercentage: { type: Number, default: 0 }
  },
  startedAt: { type: Date },
  completedAt: { type: Date },
  certificateUrl: String
}, { timestamps: true });
```

#### Notification Model

```javascript
const NotificationSchema = new mongoose.Schema({
  recipient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  type: {
    type: String,
    enum: [
      'AppointmentConfirmed',
      'AppointmentReminder',
      'AppointmentCancelled',
      'PrescriptionReceived',
      'LabResultAvailable',
      'PrescriptionStatusUpdate',
      'NewMessage',
      'HealthProgramAssigned',
      'PaymentReceived',
      'ReferralReceived'
    ],
    required: true
  },
  title: { type: String, required: true },
  message: { type: String, required: true },
  data: mongoose.Schema.Types.Mixed, // Additional data
  isRead: { type: Boolean, default: false },
  readAt: { type: Date },
  channels: {
    push: { type: Boolean, default: true },
    email: { type: Boolean, default: false },
    sms: { type: Boolean, default: false }
  },
  sentAt: { type: Date, default: Date.now }
}, { timestamps: true });
```

#### Subscription Model

```javascript
const SubscriptionSchema = new mongoose.Schema({
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  planType: {
    type: String,
    enum: ['Basic', 'Premium', 'Family', 'ChronicCare', 'PreventiveHealth'],
    required: true
  },
  planName: { type: String, required: true },
  benefits: [{
    type: String,
    description: String
  }],
  price: { type: Number, required: true },
  billingCycle: { type: String, enum: ['Monthly', 'Quarterly', 'Yearly'], required: true },
  startDate: { type: Date, required: true },
  endDate: { type: Date, required: true },
  status: {
    type: String,
    enum: ['Active', 'Expired', 'Cancelled', 'Suspended'],
    default: 'Active'
  },
  autoRenew: { type: Boolean, default: true },
  paymentHistory: [{
    amount: Number,
    paymentDate: Date,
    paymentId: String,
    status: String
  }],
  usageStats: {
    consultationsUsed: { type: Number, default: 0 },
    consultationsLimit: Number,
    labTestsUsed: { type: Number, default: 0 },
    labTestsLimit: Number
  }
}, { timestamps: true });
```

#### Health Tracker Model

```javascript
const HealthTrackerSchema = new mongoose.Schema({
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: Date, required: true },
  vitalSigns: {
    bloodPressure: { systolic: Number, diastolic: Number },
    heartRate: Number,
    temperature: Number,
    oxygenSaturation: Number,
    bloodGlucose: Number,
    weight: Number
  },
  lifestyle: {
    exercise: {
      type: String,
      duration: Number, // Minutes
      intensity: String
    },
    meals: [{
      time: String,
      description: String,
      calories: Number
    }],
    waterIntake: Number, // Glasses
    sleep: {
      duration: Number, // Hours
      quality: String
    }
  },
  symptoms: [{
    name: String,
    severity: { type: Number, min: 1, max: 10 }
  }],
  medications: [{
    name: String,
    taken: Boolean,
    time: String
  }],
  notes: String
}, { timestamps: true });
```

#### Referral Model

```javascript
const ReferralSchema = new mongoose.Schema({
  patient: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  referringDoctor: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  referredToDoctor: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  appointment: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment' },
  reason: { type: String, required: true },
  clinicalNotes: String,
  diagnosis: [String],
  attachedRecords: [{
    type: { type: String },
    recordId: mongoose.Schema.Types.ObjectId,
    url: String
  }],
  urgency: { type: String, enum: ['Normal', 'Urgent'], default: 'Normal' },
  status: {
    type: String,
    enum: ['Pending', 'Accepted', 'Declined', 'Completed'],
    default: 'Pending'
  },
  specialistAppointment: { type: mongoose.Schema.Types.ObjectId, ref: 'Appointment' },
  specialistResponse: String,
  completedAt: { type: Date }
}, { timestamps: true });
```


## API Design

### API Architecture

The backend exposes RESTful APIs following these conventions:

- **Base URL**: `https://api.icare.com/api/v1`
- **Authentication**: JWT Bearer tokens in Authorization header
- **Request Format**: JSON
- **Response Format**: JSON with consistent structure
- **Error Handling**: Standard HTTP status codes with error details

### Standard Response Format

```javascript
// Success Response
{
  "success": true,
  "data": { ... },
  "message": "Operation completed successfully"
}

// Error Response
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "User-friendly error message",
    "details": { ... } // Optional additional details
  }
}

// Paginated Response
{
  "success": true,
  "data": [ ... ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "pages": 8
  }
}
```

### Authentication Endpoints

```
POST /auth/register
POST /auth/login
POST /auth/logout
POST /auth/verify-email
POST /auth/resend-verification
POST /auth/forgot-password
POST /auth/reset-password
POST /auth/change-password
POST /auth/enable-2fa
POST /auth/verify-2fa
POST /auth/refresh-token
```

**Example: User Registration**

```
POST /auth/register
Content-Type: application/json

Request Body:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "phoneNumber": "+923001234567",
  "role": "Patient",
  "agreeToTerms": true
}

Response (201 Created):
{
  "success": true,
  "data": {
    "user": {
      "id": "64a1b2c3d4e5f6g7h8i9j0k1",
      "name": "John Doe",
      "email": "john@example.com",
      "role": "Patient",
      "isEmailVerified": false
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "Registration successful. Please verify your email."
}
```

**Example: User Login**

```
POST /auth/login
Content-Type: application/json

Request Body:
{
  "email": "john@example.com",
  "password": "SecurePass123!",
  "rememberMe": true
}

Response (200 OK):
{
  "success": true,
  "data": {
    "user": {
      "id": "64a1b2c3d4e5f6g7h8i9j0k1",
      "name": "John Doe",
      "email": "john@example.com",
      "role": "Patient",
      "isEmailVerified": true,
      "profileCompleted": true
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": "30d"
  },
  "message": "Login successful"
}
```

### User Management Endpoints

```
GET /users/profile
PUT /users/profile
PUT /users/change-email
PUT /users/change-phone
PUT /users/settings
GET /users/:id
DELETE /users/account
```

### Doctor Endpoints

```
GET /doctors
GET /doctors/:id
POST /doctors/profile (Doctor creates/updates profile)
PUT /doctors/availability
GET /doctors/availability/:doctorId
POST /doctors/unavailable-dates
GET /doctors/appointments
GET /doctors/patients
GET /doctors/analytics
GET /doctors/reviews
POST /doctors/prescription-templates
GET /doctors/prescription-templates
```

**Example: Get Doctors List**

```
GET /doctors?specialty=Cardiology&city=Karachi&page=1&limit=10
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": [
    {
      "id": "64a1b2c3d4e5f6g7h8i9j0k1",
      "name": "Dr. Sarah Ahmed",
      "specialization": "Cardiology",
      "experience": 10,
      "ratings": {
        "average": 4.8,
        "count": 156
      },
      "consultationFee": {
        "online": 2000,
        "inPerson": 3000
      },
      "clinicInfo": {
        "city": "Karachi",
        "address": "Clifton Block 5"
      },
      "isVerified": true,
      "acceptingNewPatients": true,
      "nextAvailableSlot": "2024-01-15T10:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 45,
    "pages": 5
  }
}
```

### Appointment Endpoints

```
POST /appointments
GET /appointments
GET /appointments/:id
PUT /appointments/:id/confirm
PUT /appointments/:id/decline
PUT /appointments/:id/cancel
PUT /appointments/:id/reschedule
PUT /appointments/:id/start
PUT /appointments/:id/complete
POST /appointments/:id/intake-notes
POST /appointments/:id/soap-notes
GET /appointments/:id/video-token
POST /appointments/:id/rating
```

**Example: Book Appointment**

```
POST /appointments
Authorization: Bearer {token}
Content-Type: application/json

Request Body:
{
  "doctorId": "64a1b2c3d4e5f6g7h8i9j0k1",
  "appointmentDate": "2024-01-15",
  "timeSlot": {
    "start": "10:00",
    "end": "10:30"
  },
  "consultationType": "Online",
  "reason": "Follow-up consultation",
  "symptoms": ["Chest pain", "Shortness of breath"],
  "urgency": "Normal"
}

Response (201 Created):
{
  "success": true,
  "data": {
    "appointment": {
      "id": "64b2c3d4e5f6g7h8i9j0k1l2",
      "patient": {
        "id": "64a1b2c3d4e5f6g7h8i9j0k1",
        "name": "John Doe"
      },
      "doctor": {
        "id": "64a1b2c3d4e5f6g7h8i9j0k1",
        "name": "Dr. Sarah Ahmed",
        "specialization": "Cardiology"
      },
      "appointmentDate": "2024-01-15T10:00:00Z",
      "timeSlot": {
        "start": "10:00",
        "end": "10:30"
      },
      "consultationType": "Online",
      "status": "Pending",
      "paymentAmount": 2000,
      "paymentStatus": "Pending"
    }
  },
  "message": "Appointment booked successfully. Waiting for doctor confirmation."
}
```

### Prescription Endpoints

```
POST /prescriptions
GET /prescriptions
GET /prescriptions/:id
PUT /prescriptions/:id/send-to-pharmacy
GET /prescriptions/patient/:patientId
```

### Lab Request Endpoints

```
POST /lab-requests
GET /lab-requests
GET /lab-requests/:id
PUT /lab-requests/:id/accept
PUT /lab-requests/:id/start
PUT /lab-requests/:id/upload-report
PUT /lab-requests/:id/complete
GET /lab-requests/patient/:patientId
GET /lab-requests/doctor/:doctorId
```

### Pharmacy Endpoints

```
GET /pharmacy/orders
GET /pharmacy/orders/:id
PUT /pharmacy/orders/:id/accept
PUT /pharmacy/orders/:id/preparing
PUT /pharmacy/orders/:id/dispatch
PUT /pharmacy/orders/:id/deliver
GET /pharmacy/inventory
POST /pharmacy/inventory
PUT /pharmacy/inventory/:id
GET /pharmacy/analytics
```

### Medical Records Endpoints

```
GET /medical-records/patient/:patientId
POST /medical-records
GET /medical-records/:id
PUT /medical-records/:id
DELETE /medical-records/:id
POST /medical-records/:id/share
GET /medical-records/:id/access-log
GET /medical-records/export/:patientId
```

### Course/LMS Endpoints

```
GET /courses
GET /courses/:id
POST /courses (Instructor creates course)
PUT /courses/:id
DELETE /courses/:id
POST /courses/:id/enroll
GET /courses/enrollments
PUT /courses/enrollments/:id/progress
GET /courses/my-courses
POST /courses/:id/assign (Doctor assigns to patient)
```

### Notification Endpoints

```
GET /notifications
PUT /notifications/:id/read
PUT /notifications/read-all
DELETE /notifications/:id
POST /notifications/preferences
```

### Chat Endpoints

```
GET /chat/conversations
GET /chat/conversations/:conversationId/messages
POST /chat/conversations/:conversationId/messages
PUT /chat/messages/:messageId/read
POST /chat/conversations
```

### Analytics Endpoints

```
GET /analytics/doctor
GET /analytics/patient
GET /analytics/lab
GET /analytics/pharmacy
GET /analytics/admin
GET /analytics/platform (Super Admin)
```

### Admin Endpoints

```
POST /admin/users/controlled (Create controlled user)
GET /admin/users
PUT /admin/users/:id/activate
PUT /admin/users/:id/deactivate
GET /admin/doctors/pending-verification
PUT /admin/doctors/:id/verify
PUT /admin/doctors/:id/reject
GET /admin/audit-logs
GET /admin/quality-reports
POST /admin/subscriptions/plans
GET /admin/subscriptions/plans
```

### Health Tracker Endpoints

```
POST /health-tracker
GET /health-tracker
GET /health-tracker/:date
PUT /health-tracker/:id
GET /health-tracker/trends
```

### Subscription Endpoints

```
GET /subscriptions/plans
POST /subscriptions/subscribe
GET /subscriptions/my-subscription
PUT /subscriptions/cancel
PUT /subscriptions/upgrade
```

### Referral Endpoints

```
POST /referrals
GET /referrals
GET /referrals/:id
PUT /referrals/:id/accept
PUT /referrals/:id/decline
PUT /referrals/:id/complete
```

### Video Consultation Endpoints

```
GET /video/token/:appointmentId
POST /video/start/:appointmentId
POST /video/end/:appointmentId
POST /video/record/:appointmentId
```

### API Authentication Middleware

```javascript
// authMiddleware.js
const jwt = require('jsonwebtoken');
const User = require('../models/user');

const protect = async (req, res, next) => {
  let token;
  
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      token = req.headers.authorization.split(' ')[1];
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      req.user = await User.findById(decoded.id).select('-password');
      
      if (!req.user.isActive) {
        return res.status(403).json({
          success: false,
          error: {
            code: 'ACCOUNT_DEACTIVATED',
            message: 'Your account has been deactivated. Please contact support.'
          }
        });
      }
      
      next();
    } catch (error) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'INVALID_TOKEN',
          message: 'Not authorized. Please login again.'
        }
      });
    }
  }
  
  if (!token) {
    return res.status(401).json({
      success: false,
      error: {
        code: 'NO_TOKEN',
        message: 'Not authorized. No token provided.'
      }
    });
  }
};

module.exports = { protect };
```

### API Role-Based Access Control Middleware

```javascript
// roleMiddleware.js
const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'NOT_AUTHENTICATED',
          message: 'Please login to access this resource.'
        }
      });
    }
    
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        error: {
          code: 'INSUFFICIENT_PERMISSIONS',
          message: 'You do not have permission to access this resource.'
        }
      });
    }
    
    next();
  };
};

module.exports = { authorize };
```

### API Error Handling Middleware

```javascript
// errorMiddleware.js
const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;
  
  // Log error for debugging
  console.error(err);
  
  // Mongoose bad ObjectId
  if (err.name === 'CastError') {
    const message = 'Resource not found';
    error = { message, statusCode: 404 };
  }
  
  // Mongoose duplicate key
  if (err.code === 11000) {
    const field = Object.keys(err.keyValue)[0];
    const message = `${field} already exists`;
    error = { message, statusCode: 400 };
  }
  
  // Mongoose validation error
  if (err.name === 'ValidationError') {
    const message = Object.values(err.errors).map(val => val.message).join(', ');
    error = { message, statusCode: 400 };
  }
  
  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    const message = 'Invalid token. Please login again.';
    error = { message, statusCode: 401 };
  }
  
  if (err.name === 'TokenExpiredError') {
    const message = 'Your session has expired. Please login again.';
    error = { message, statusCode: 401 };
  }
  
  res.status(error.statusCode || 500).json({
    success: false,
    error: {
      code: error.code || 'SERVER_ERROR',
      message: error.message || 'Something went wrong. Please try again.',
      ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    }
  });
};

module.exports = errorHandler;
```


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property Reflection

After analyzing all acceptance criteria, I identified the following testable properties. During reflection, I consolidated redundant properties:

- Properties 11.2-11.7 (storing various items in health records) were combined into a single comprehensive property about health record completeness
- Properties 10.1-10.3 (automatic dashboard updates) were combined into a single workflow integration property
- Properties 5.2-5.4 (display field requirements) were combined into a single data completeness property
- Error handling properties 20.1 and 20.2 were kept separate as they test different aspects (user-friendliness vs technical detail hiding)

### Authentication and Access Control Properties

### Property 1: Testing bypass hidden from public users

*For any* public user (Patient or Doctor), the testing bypass option should not be visible or accessible in the UI.

**Validates: Requirements 1.6**

### Property 2: Error messages hide technical details

*For any* error condition, the error message displayed to users should not contain technical details such as exception names, HTTP status codes, stack traces, or database errors.

**Validates: Requirements 1.9, 20.2**

### Property 3: Session persistence with remember me

*For any* user who logs in with "remember me" enabled, subsequent app launches should maintain their authenticated session without requiring re-login.

**Validates: Requirements 1.11**

### Property 4: Email verification required for access

*For any* user account that has not completed email verification, attempts to access protected platform features should be blocked until verification is completed.

**Validates: Requirements 2.2**

### Property 5: Terms acceptance required for signup

*For any* signup attempt where the user has not agreed to terms and conditions, the account creation should fail with an appropriate validation error.

**Validates: Requirements 2.4**

### Property 6: Email change requires re-verification

*For any* email address change request, the system should require verification of the new email address before updating the user's account.

**Validates: Requirements 2.11**

### Property 7: Role selection only for first-time users

*For any* returning user with an existing role assignment, the login flow should skip role selection and route directly to their role-specific dashboard.

**Validates: Requirements 3.1, 3.5**

### Property 8: Public signup limited to Patient and Doctor roles

*For any* public signup flow, only Patient and Doctor roles should be available for selection; controlled roles (Lab_Technician, Pharmacist, Instructor, Student) should not be accessible.

**Validates: Requirements 3.2, 3.8**

### Property 9: Controlled users routed to assigned dashboard

*For any* controlled user (Lab_Technician, Pharmacist, Instructor, Student), login should automatically route them to their role-specific dashboard based on their assigned role.

**Validates: Requirements 3.6**

### Admin and User Management Properties

### Property 10: Controlled user creation requires mandatory fields

*For any* controlled user account creation by Admin, the system should require name, location, license number, and contact information; creation attempts missing these fields should fail validation.

**Validates: Requirements 4.5**

### Property 11: Credentials generated for controlled users

*For any* controlled user account created by Admin, the system should automatically generate secure login credentials.

**Validates: Requirements 4.6**

### Property 12: Credentials emailed to controlled users

*For any* controlled user account creation, the system should send the generated credentials to the user's email address.

**Validates: Requirements 4.7**

### Property 13: Controlled roles blocked from public signup

*For any* public signup attempt specifying a controlled role (Lab_Technician, Pharmacist, Instructor, Student), the registration should be rejected.

**Validates: Requirements 4.11**

### Property 14: Admin actions logged for audit

*For any* user management action performed by Admin (create, activate, deactivate, verify), an audit log entry should be created with timestamp, admin ID, action type, and target user.

**Validates: Requirements 4.12**

### Dashboard and Display Properties

### Property 15: Required fields present in data displays

*For any* appointment displayed in patient or doctor dashboard, the display should include patient/doctor name, date, time, and consultation type. *For any* prescription display, it should include medication names and fulfillment status. *For any* lab report display, it should include test name, date, and ordering doctor.

**Validates: Requirements 5.2, 5.3, 5.4, 6.2, 28.2**

### Property 16: Event notifications created

*For any* new prescription, lab result upload, or appointment reminder event, a notification should be created for the relevant user.

**Validates: Requirements 5.10**

### Integrated Workflow Properties

### Property 17: Workflow integration creates dashboard entries

*For any* prescription created by a doctor, it should automatically appear in the patient dashboard. *For any* lab test ordered, it should appear in the lab technician dashboard. *For any* health program assigned, it should appear in the patient's learning dashboard.

**Validates: Requirements 10.1, 10.2, 10.3**

### Property 18: Referral creates notification and pending appointment

*For any* referral created by a doctor, the system should create a notification for the specialist doctor and create a pending appointment record.

**Validates: Requirements 10.4**

### Property 19: Lab report added to health record

*For any* lab report uploaded by a lab technician, the report should be automatically added to the patient's digital health record.

**Validates: Requirements 10.5**

### Property 20: Lab report notifies ordering doctor

*For any* lab report uploaded by a lab technician, a notification should be sent to the doctor who ordered the test.

**Validates: Requirements 10.6**

### Property 21: Pharmacy order updates prescription status

*For any* pharmacy order accepted by a pharmacist, the associated prescription's status should be updated to reflect the acceptance.

**Validates: Requirements 10.8**

### Property 22: Module completion updates doctor view

*For any* health program module completed by a patient, the doctor's patient progress view should be updated to reflect the completion.

**Validates: Requirements 10.9**

### Property 23: Follow-up appointments scheduled automatically

*For any* treatment plan that specifies a follow-up period, the system should automatically schedule a follow-up appointment for the patient.

**Validates: Requirements 10.12**

### Digital Health Record Properties

### Property 24: Health record completeness

*For any* consultation with notes, prescription, lab report, diagnosis, allergy entry, medical condition entry, or immunization record, the corresponding data should be stored in the patient's digital health record.

**Validates: Requirements 11.2, 11.3, 11.4, 11.5, 11.6, 11.7**

### Property 25: Health records displayed chronologically

*For any* digital health record display, all entries should be ordered by date in chronological order (oldest to newest or newest to oldest consistently).

**Validates: Requirements 11.8**

### Property 26: Health record access requires consent

*For any* doctor attempting to access a patient's digital health record, access should be granted only if patient consent exists; unauthorized access attempts should be blocked.

**Validates: Requirements 11.10**

### Property 27: Health record access logged

*For any* access to a patient's digital health record, an audit log entry should be created recording the accessing user, timestamp, and action performed.

**Validates: Requirements 11.13, 35.6**

### Clinical Documentation Properties

### Property 28: SOAP notes saved to health record

*For any* SOAP note created during a consultation, the note should be saved to the patient's digital health record.

**Validates: Requirements 12.6**

### Property 29: Clinical documentation timestamped

*For any* clinical document (SOAP notes, intake notes, prescriptions), the document should have a timestamp recording when it was created.

**Validates: Requirements 12.10**

### Property 30: Finalized notes immutable

*For any* clinical note marked as finalized, attempts to modify the note should be blocked; the note should be read-only.

**Validates: Requirements 12.11**

### Property 31: Document version history maintained

*For any* modification to a clinical document before finalization, the system should maintain version history showing what changed, when, and by whom.

**Validates: Requirements 12.12**

### Error Handling Properties

### Property 32: User-friendly error messages

*For any* error condition, the error message displayed to users should be written in plain language without technical jargon, providing clear guidance on what went wrong and how to proceed.

**Validates: Requirements 20.1**

### Property 33: Technical errors logged

*For any* error that occurs in the system, technical details including stack traces, error codes, and context should be logged to the server for developer debugging.

**Validates: Requirements 20.8**

### Property 34: Form validation before submission

*For any* form submission with invalid data (missing required fields, incorrect format, out-of-range values), the submission should be rejected with specific field-level error messages before reaching the server.

**Validates: Requirements 20.12**

### Appointment and Notification Properties

### Property 35: Appointment booking sends confirmations

*For any* appointment successfully booked by a patient, a confirmation notification should be sent to the patient and a notification should be sent to the doctor.

**Validates: Requirements 28.5, 28.6**

### Property 36: Appointment decline notifies patient with reason

*For any* appointment declined by a doctor, a notification should be sent to the patient including the reason for decline.

**Validates: Requirements 28.8**

### Property 37: Appointment reminders sent at scheduled times

*For any* confirmed appointment, reminder notifications should be sent to the patient at 24 hours before and 1 hour before the scheduled appointment time.

**Validates: Requirements 28.11**

### Payment and Transaction Properties

### Property 38: Payment generates receipt

*For any* successful payment transaction (consultation, prescription, lab test, subscription), a digital receipt should be generated and made available to the user.

**Validates: Requirements 30.8**

### Security and Access Control Properties

### Property 39: Role-based access control enforced

*For any* data access request, the system should verify that the requesting user's role has permission to access that data; requests without proper permissions should be rejected.

**Validates: Requirements 35.3**

### Property 40: API authentication required

*For any* API endpoint request (except public endpoints like login/register), the request should include valid authentication credentials; unauthenticated requests should be rejected with 401 status.

**Validates: Requirements 35.4**

### Property 41: External sharing requires consent

*For any* attempt to share patient health data with external parties, the system should verify that explicit patient consent exists; sharing without consent should be blocked.

**Validates: Requirements 35.9**

### Property 42: Account deletion anonymizes data

*For any* patient account deletion request, the system should anonymize the patient's personal information in health records while preserving clinical data integrity for medical and legal purposes.

**Validates: Requirements 35.12**

### Property 43: Password complexity enforced

*For any* password creation or change attempt, the password should meet complexity requirements (minimum length, character variety); weak passwords should be rejected.

**Validates: Requirements 35.13**

### Property 44: Account lockout after failed attempts

*For any* user account with 5 consecutive failed login attempts, the account should be temporarily locked and require additional verification to unlock.

**Validates: Requirements 35.14**

### Example-Based Test Cases

The following are specific examples that should be tested as unit tests rather than properties:

**Example 1: Network error message**
WHEN a network error occurs (connection timeout, no internet), THEN the system should display "Unable to connect. Please check your internet connection."
**Validates: Requirements 20.3**

**Example 2: Server error message**
WHEN a server error occurs (500 status code), THEN the system should display "Something went wrong. Please try again."
**Validates: Requirements 20.4**

**Example 3: Data loading error message**
WHEN data cannot be loaded (API returns error), THEN the system should display "Unable to load data right now. Please try again."
**Validates: Requirements 20.5**

## Error Handling

### Error Handling Strategy

The platform implements comprehensive error handling across all layers to ensure users receive clear, actionable feedback while technical details are logged for debugging.

**Frontend Error Categories:**
1. Network errors (timeout, no connection)
2. API errors (4xx, 5xx status codes)
3. Validation errors (form input validation)
4. Business logic errors (slot unavailable, insufficient permissions)

**Backend Error Categories:**
1. Validation errors (400)
2. Authentication errors (401)
3. Authorization errors (403)
4. Not found errors (404)
5. Conflict errors (409)
6. Server errors (500)

**Error Response Format:**
All API errors follow a consistent JSON structure with user-friendly messages and optional technical details (development only).

**Error Logging:**
- Frontend: Log to console (dev) and error tracking service (production)
- Backend: Use Winston logger with file and console transports
- Never log sensitive data (passwords, tokens, health information)
- Include request ID for tracing across services

## Testing Strategy

### Dual Testing Approach

The platform requires both unit tests and property-based tests for comprehensive coverage:

**Unit Tests:**
- Test specific examples and edge cases
- Test integration points between components
- Test error conditions
- Fast execution for rapid feedback
- Target: 80% code coverage

**Property-Based Tests:**
- Test universal properties across all inputs
- Generate random test data for comprehensive coverage
- Verify all 44 correctness properties from design document
- Minimum 100 iterations per property test
- Each test tagged with: `Feature: icare-virtual-hospital-complete-redesign, Property {number}: {property_text}`

### Testing Tools

**Flutter/Dart:**
- `flutter_test`: Unit and widget testing
- `mockito`: Mocking dependencies
- `integration_test`: End-to-end testing
- `faker`: Generate test data
- Custom property testing with random data generation

**Node.js:**
- `jest`: Test framework
- `supertest`: HTTP assertion library
- `mongodb-memory-server`: In-memory MongoDB
- `faker`: Generate test data
- `fast-check`: Property-based testing library

### Test Organization

**Frontend:**
```
test/
├── unit/          # Unit tests for models, services, utils
├── widget/        # Widget tests for UI components
├── integration/   # Integration tests for complete flows
└── property/      # Property-based tests for correctness properties
```

**Backend:**
```
tests/
├── unit/          # Unit tests for models, controllers, services
├── integration/   # API integration tests
└── property/      # Property-based tests for correctness properties
```

### Property Test Implementation

Each correctness property must be implemented as a property-based test:

**Example Property Test Structure:**

```dart
// Feature: icare-virtual-hospital-complete-redesign
// Property 2: For any error condition, error messages should not contain technical details
test('Property 2: Error messages never expose technical details', () async {
  // Run 100 iterations with random inputs
  for (int i = 0; i < 100; i++) {
    // Generate random test data
    // Execute operation that may fail
    // Verify property holds
  }
});
```

### Test Coverage Goals

- Unit tests: 80% code coverage minimum
- Integration tests: All critical user flows
- Property tests: All 44 correctness properties
- E2E tests: Complete user journeys for each role

### Continuous Integration

**CI Pipeline:**
1. Lint and format checks
2. Unit tests
3. Property-based tests (100 iterations each)
4. Integration tests
5. Coverage report generation
6. E2E tests (staging environment)
7. Build and deploy (if all pass)

**Test Execution Schedule:**
- Unit tests: Every commit
- Integration tests: Every pull request
- Property tests: Every pull request
- E2E tests: Before deployment

## Implementation Priorities

### Phase 1: Foundation (Weeks 1-4)
1. Enhanced authentication with email verification
2. Role-based access control implementation
3. User management for controlled roles
4. Basic dashboards for all roles
5. API authentication and authorization middleware

### Phase 2: Core Healthcare Workflows (Weeks 5-10)
1. Appointment booking and management
2. Video consultation integration
3. SOAP notes and clinical documentation
4. Prescription creation and management
5. Lab request workflow
6. Pharmacy order workflow
7. Digital health records

### Phase 3: Integration and Automation (Weeks 11-14)
1. Integrated workflow automation
2. Notification system (push, email, SMS)
3. Real-time chat with Pusher
4. Referral system
5. Health program assignment
6. Payment gateway integration

### Phase 4: Advanced Features (Weeks 15-18)
1. Analytics and reporting for all roles
2. Subscription management
3. Health tracker and gamification
4. Prescription templates
5. Chronic care programs
6. Preventive health packages

### Phase 5: Quality and Optimization (Weeks 19-22)
1. Clinical audit and QA monitoring
2. Admin and Super Admin panels
3. Security enhancements (2FA, biometric)
4. Performance optimization
5. Comprehensive testing
6. Documentation

### Phase 6: Testing and Deployment (Weeks 23-24)
1. Property-based test implementation
2. Integration testing
3. End-to-end testing
4. User acceptance testing
5. Production deployment
6. Monitoring and support setup

## Design Summary

This design document provides comprehensive technical specifications for implementing the iCare Virtual Hospital Platform redesign. The design addresses all 45 requirements through:

**Architecture:**
- Three-tier architecture (Presentation, Application, Data)
- Role-based access control for 7 user roles
- RESTful API design with JWT authentication
- Real-time communication via Pusher
- Video consultation via Agora SDK

**Data Models:**
- 20+ comprehensive MongoDB schemas
- Referential integrity through relationships
- Audit logging for security and compliance
- Version history for clinical documents

**API Design:**
- 100+ RESTful endpoints
- Consistent request/response formats
- Comprehensive error handling
- Role-based authorization

**Correctness Properties:**
- 44 testable properties covering all critical behaviors
- Property-based testing strategy with 100+ iterations
- Clear traceability to requirements
- Example-based tests for specific scenarios

**Error Handling:**
- User-friendly error messages
- Technical detail hiding from users
- Comprehensive logging for debugging
- Consistent error response formats

**Testing Strategy:**
- Dual approach: unit tests + property tests
- 80% code coverage target
- All correctness properties tested
- CI/CD pipeline integration

The design ensures the platform functions as an integrated healthcare ecosystem with seamless coordination between consultations, prescriptions, lab tests, pharmacy fulfillment, and patient education. All components are designed for scalability, security, and maintainability while providing excellent user experience across all roles.

