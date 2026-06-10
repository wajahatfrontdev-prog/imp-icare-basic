enum TwoFactorMethod {
  sms,
  email,
  authenticatorApp,
}

enum SessionStatus {
  active,
  expired,
  revoked,
}

class TwoFactorAuth {
  final String userId;
  final bool isEnabled;
  final TwoFactorMethod method;
  final String? phoneNumber;
  final String? email;
  final String? secret; // For authenticator app
  final List<String> backupCodes;
  final DateTime? enabledAt;

  TwoFactorAuth({
    required this.userId,
    required this.isEnabled,
    required this.method,
    this.phoneNumber,
    this.email,
    this.secret,
    required this.backupCodes,
    this.enabledAt,
  });

  factory TwoFactorAuth.fromJson(Map<String, dynamic> json) {
    return TwoFactorAuth(
      userId: json['userId'] ?? '',
      isEnabled: json['isEnabled'] ?? false,
      method: TwoFactorMethod.values.firstWhere(
        (e) => e.toString().split('.').last == json['method'],
        orElse: () => TwoFactorMethod.sms,
      ),
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      secret: json['secret'],
      backupCodes: List<String>.from(json['backupCodes'] ?? []),
      enabledAt: json['enabledAt'] != null ? DateTime.parse(json['enabledAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isEnabled': isEnabled,
      'method': method.toString().split('.').last,
      'phoneNumber': phoneNumber,
      'email': email,
      'secret': secret,
      'backupCodes': backupCodes,
      'enabledAt': enabledAt?.toIso8601String(),
    };
  }
}

class EmailVerification {
  final String userId;
  final String email;
  final bool isVerified;
  final String? verificationToken;
  final DateTime? tokenExpiresAt;
  final DateTime? verifiedAt;
  final int resendCount;
  final DateTime? lastResendAt;

  EmailVerification({
    required this.userId,
    required this.email,
    required this.isVerified,
    this.verificationToken,
    this.tokenExpiresAt,
    this.verifiedAt,
    required this.resendCount,
    this.lastResendAt,
  });

  factory EmailVerification.fromJson(Map<String, dynamic> json) {
    return EmailVerification(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
      verificationToken: json['verificationToken'],
      tokenExpiresAt: json['tokenExpiresAt'] != null ? DateTime.parse(json['tokenExpiresAt']) : null,
      verifiedAt: json['verifiedAt'] != null ? DateTime.parse(json['verifiedAt']) : null,
      resendCount: json['resendCount'] ?? 0,
      lastResendAt: json['lastResendAt'] != null ? DateTime.parse(json['lastResendAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'isVerified': isVerified,
      'verificationToken': verificationToken,
      'tokenExpiresAt': tokenExpiresAt?.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
      'resendCount': resendCount,
      'lastResendAt': lastResendAt?.toIso8601String(),
    };
  }

  bool get canResend {
    if (lastResendAt == null) return true;
    final timeSinceLastResend = DateTime.now().difference(lastResendAt!);
    return timeSinceLastResend.inMinutes >= 2; // 2 minute cooldown
  }

  bool get isTokenExpired {
    if (tokenExpiresAt == null) return true;
    return DateTime.now().isAfter(tokenExpiresAt!);
  }
}

class PasswordReset {
  final String userId;
  final String email;
  final String resetToken;
  final DateTime tokenExpiresAt;
  final bool isUsed;
  final DateTime? usedAt;
  final DateTime createdAt;

  PasswordReset({
    required this.userId,
    required this.email,
    required this.resetToken,
    required this.tokenExpiresAt,
    required this.isUsed,
    this.usedAt,
    required this.createdAt,
  });

  factory PasswordReset.fromJson(Map<String, dynamic> json) {
    return PasswordReset(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      resetToken: json['resetToken'] ?? '',
      tokenExpiresAt: DateTime.parse(json['tokenExpiresAt']),
      isUsed: json['isUsed'] ?? false,
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'resetToken': resetToken,
      'tokenExpiresAt': tokenExpiresAt.toIso8601String(),
      'isUsed': isUsed,
      'usedAt': usedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isExpired {
    return DateTime.now().isAfter(tokenExpiresAt);
  }

  bool get isValid {
    return !isUsed && !isExpired;
  }
}

class UserSession {
  final String id;
  final String userId;
  final String deviceName;
  final String deviceType; // 'mobile', 'desktop', 'tablet'
  final String ipAddress;
  final String userAgent;
  final SessionStatus status;
  final DateTime createdAt;
  final DateTime lastActivityAt;
  final DateTime? expiresAt;
  final DateTime? revokedAt;

  UserSession({
    required this.id,
    required this.userId,
    required this.deviceName,
    required this.deviceType,
    required this.ipAddress,
    required this.userAgent,
    required this.status,
    required this.createdAt,
    required this.lastActivityAt,
    this.expiresAt,
    this.revokedAt,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      deviceName: json['deviceName'] ?? '',
      deviceType: json['deviceType'] ?? '',
      ipAddress: json['ipAddress'] ?? '',
      userAgent: json['userAgent'] ?? '',
      status: SessionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => SessionStatus.active,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      lastActivityAt: DateTime.parse(json['lastActivityAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      revokedAt: json['revokedAt'] != null ? DateTime.parse(json['revokedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'lastActivityAt': lastActivityAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'revokedAt': revokedAt?.toIso8601String(),
    };
  }

  bool get isCurrentSession {
    // In real implementation, compare with current session ID
    return status == SessionStatus.active;
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

class SecuritySettings {
  final String userId;
  final bool twoFactorEnabled;
  final TwoFactorMethod? twoFactorMethod;
  final bool emailVerified;
  final bool loginNotificationsEnabled;
  final bool suspiciousActivityAlertsEnabled;
  final List<String> trustedDevices;
  final DateTime? lastPasswordChange;
  final int failedLoginAttempts;
  final DateTime? accountLockedUntil;

  SecuritySettings({
    required this.userId,
    required this.twoFactorEnabled,
    this.twoFactorMethod,
    required this.emailVerified,
    required this.loginNotificationsEnabled,
    required this.suspiciousActivityAlertsEnabled,
    required this.trustedDevices,
    this.lastPasswordChange,
    required this.failedLoginAttempts,
    this.accountLockedUntil,
  });

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      userId: json['userId'] ?? '',
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      twoFactorMethod: json['twoFactorMethod'] != null
          ? TwoFactorMethod.values.firstWhere(
              (e) => e.toString().split('.').last == json['twoFactorMethod'],
              orElse: () => TwoFactorMethod.sms,
            )
          : null,
      emailVerified: json['emailVerified'] ?? false,
      loginNotificationsEnabled: json['loginNotificationsEnabled'] ?? true,
      suspiciousActivityAlertsEnabled: json['suspiciousActivityAlertsEnabled'] ?? true,
      trustedDevices: List<String>.from(json['trustedDevices'] ?? []),
      lastPasswordChange: json['lastPasswordChange'] != null ? DateTime.parse(json['lastPasswordChange']) : null,
      failedLoginAttempts: json['failedLoginAttempts'] ?? 0,
      accountLockedUntil: json['accountLockedUntil'] != null ? DateTime.parse(json['accountLockedUntil']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'twoFactorEnabled': twoFactorEnabled,
      'twoFactorMethod': twoFactorMethod?.toString().split('.').last,
      'emailVerified': emailVerified,
      'loginNotificationsEnabled': loginNotificationsEnabled,
      'suspiciousActivityAlertsEnabled': suspiciousActivityAlertsEnabled,
      'trustedDevices': trustedDevices,
      'lastPasswordChange': lastPasswordChange?.toIso8601String(),
      'failedLoginAttempts': failedLoginAttempts,
      'accountLockedUntil': accountLockedUntil?.toIso8601String(),
    };
  }

  bool get isAccountLocked {
    if (accountLockedUntil == null) return false;
    return DateTime.now().isBefore(accountLockedUntil!);
  }

  bool get needsPasswordChange {
    if (lastPasswordChange == null) return false;
    final daysSinceChange = DateTime.now().difference(lastPasswordChange!).inDays;
    return daysSinceChange > 90; // Recommend password change every 90 days
  }
}

class LoginAttempt {
  final String id;
  final String? userId;
  final String email;
  final bool successful;
  final String ipAddress;
  final String deviceType;
  final String userAgent;
  final String? failureReason;
  final DateTime attemptedAt;

  LoginAttempt({
    required this.id,
    this.userId,
    required this.email,
    required this.successful,
    required this.ipAddress,
    required this.deviceType,
    required this.userAgent,
    this.failureReason,
    required this.attemptedAt,
  });

  factory LoginAttempt.fromJson(Map<String, dynamic> json) {
    return LoginAttempt(
      id: json['_id'] ?? '',
      userId: json['userId'],
      email: json['email'] ?? '',
      successful: json['successful'] ?? false,
      ipAddress: json['ipAddress'] ?? '',
      deviceType: json['deviceType'] ?? '',
      userAgent: json['userAgent'] ?? '',
      failureReason: json['failureReason'],
      attemptedAt: DateTime.parse(json['attemptedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'email': email,
      'successful': successful,
      'ipAddress': ipAddress,
      'deviceType': deviceType,
      'userAgent': userAgent,
      'failureReason': failureReason,
      'attemptedAt': attemptedAt.toIso8601String(),
    };
  }
}
