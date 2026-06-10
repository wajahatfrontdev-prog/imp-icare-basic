import 'package:icare/models/user.dart';

class CommonData {
  final User? userData;
  final List<Map<dynamic, dynamic>>? cartData;
  final bool profileCreated;
  final String? selectedReason;

  const CommonData({
    this.userData,
    this.cartData,
    this.profileCreated = false,
    this.selectedReason,
  });

  CommonData copyWith({
    User? userData,
    List<Map<dynamic, dynamic>>? cartData,
    bool? profileCreated,
    String? selectedReason,
  }) {
    return CommonData(
      userData: userData ?? this.userData,
      cartData: cartData ?? this.cartData,
      profileCreated: profileCreated ?? this.profileCreated,
      selectedReason: selectedReason ?? this.selectedReason,
    );
  }
}
