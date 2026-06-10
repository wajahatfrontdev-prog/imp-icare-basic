import 'package:icare/models/app_enums.dart';

extension UserRoleMapper on String {
  UserRole toUserRole() {
    switch (toLowerCase()) {
      case 'patient':
        return UserRole.patient;
      case 'doctor':
        return UserRole.doctor;
      case 'lab_technician':
        return UserRole.labTechnician;
      case 'student':
        return UserRole.student;
      case 'pharmacist':
        return UserRole.pharmacist;
      case 'instructor':
        return UserRole.instructor;
      default:
        return UserRole.unknown;
    }
  }
}
