import '../models/user.dart';

class Auth {
  final String? token;
  final String? fcmToken;
  final bool userWalkthrough;
  final bool isLoggedIn;
  final String userRole;
  final User? user;

  Auth({
    this.token,
    this.fcmToken,
    this.userWalkthrough = false,
    this.isLoggedIn = false,
    this.userRole = "",
    this.user,
  });

  Auth copyWith({
    String? token,
    String? fcmToken,
    bool? userWalkthrough,
    bool? isLoggedIn,
    String? userRole,
    User? user,
  }) {
    return Auth(
      token: token ?? this.token,
      fcmToken: fcmToken ?? this.fcmToken,
      userWalkthrough: userWalkthrough ?? this.userWalkthrough,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userRole: userRole ?? this.userRole,
      user: user ?? this.user,
    );
  }
}
