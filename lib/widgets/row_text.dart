import 'package:flutter/material.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/custom_text.dart';

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    this.leadingText,
    this.trailingText,
    this.leadingColor,
    this.leadingFontFamily,
    this.leadingFontSize = 16,
    this.trailingColor,
    this.trailingFontFamily,
    this.trailingFontSize = 16,
  });
  final String? leadingText;
  final String? trailingText;
  final String? leadingFontFamily;
  final String? trailingFontFamily;
  final Color? leadingColor;
  final Color? trailingColor;
  final double leadingFontSize;
  final double trailingFontSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utils.windowWidth(context) * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: leadingText,
            fontFamily: leadingFontFamily ?? "Gilroy-Regular",
            fontSize: leadingFontSize,
            color: leadingColor ?? AppColors.tertiaryColor,
          ),
          CustomText(
            text: trailingText,
            fontFamily: trailingFontFamily ?? "Gilroy-Bold",
            fontSize: trailingFontSize,
            fontWeight: FontWeight.bold,
            color: trailingColor ?? AppColors.primary500,
          ),
        ],
      ),
    );
  }
}
