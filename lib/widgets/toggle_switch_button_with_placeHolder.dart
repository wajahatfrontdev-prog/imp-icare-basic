import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/custom_text.dart';

class ToggleSwitchButtonWithPlaceholder extends StatelessWidget {
  const ToggleSwitchButtonWithPlaceholder({
    super.key,
    this.title,
    this.width,
    this.value = false,
    this.onToggle,
  });

  final Function(bool)? onToggle;
  final bool value;
  final String? title;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title ?? "Choose",
          isBold: true,
          fontSize: ScallingConfig.moderateScale(14.78),
          color: AppColors.primary500,
          fontWeight: FontWeight.w400,
          fontFamily: "GIlroy-SemiBold",
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: ScallingConfig.verticalScale(3),
            horizontal: ScallingConfig.scale(8),
          ),
          width: width ?? Utils.windowWidth(context) * 0.9,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(width: 1.2, color: AppColors.lightGrey100),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: value ? "On" : "Off",
                isBold: true,
                fontSize: ScallingConfig.moderateScale(14.78),
                color: AppColors.primary500,
                fontWeight: FontWeight.w400,
                fontFamily: "GIlroy-SemiBold",
              ),

              Switch(
                value: value,
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.black,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                onChanged: onToggle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
