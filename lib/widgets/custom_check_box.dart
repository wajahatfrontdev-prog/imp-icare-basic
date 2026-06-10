import 'package:flutter/material.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/widgets/custom_text.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    this.text = '',
    this.height,
    this.width,
    this.margin,
    this.isChecked = false,
    this.onChanged,
  });
  final String text;
  final double? width;
  final double? height;
  final bool isChecked;
  final EdgeInsets? margin;
  final Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: text,
            fontFamily: "Gilroy-SemiBold",
            fontSize: 14,
            color: AppColors.tertiaryColor,
          ),
          Checkbox(
            checkColor: AppColors.white,
            overlayColor: WidgetStateProperty.all(
              AppColors.primaryColor.withAlpha(20),
            ),

            // fillColor:WidgetStateProperty.all(
            //   AppColors.primaryColor,
            // ),
            activeColor: AppColors.primaryColor,
            value: isChecked,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
