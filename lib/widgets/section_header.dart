import 'package:flutter/material.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/widgets/custom_text.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionText = 'View All',
    this.showAction = true,
    this.onActionTap,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.bgColor,
  });

  final String title;
  final String actionText;
  final bool showAction;
  final VoidCallback? onActionTap;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      color: bgColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Title
          CustomText(
            text: title,
            fontFamily: "Gilroy-Bold",
            fontSize: 16.78,
            color: AppColors.primary500,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.31,
            lineHeight: 1.0,
          ),
          if (showAction)
            CustomText(
              text: actionText,
              fontFamily: "Gilroy-SemiBold",
              fontSize: 14,
              color: AppColors.primaryColor,
              letterSpacing: -0.31,
              lineHeight: 1.0,
              underline: true,
              onTap: onActionTap,
            ),
        ],
      ),
    );
  }
}
