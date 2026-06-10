import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/utils/theme.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final double fontSize;
  final bool isBold;
  final bool isSemiBold;
  final bool isMedium;
  final bool isLight;
  final bool isItalic;
  final String fontFamily;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextStyle? style;
  final bool underline;
  final bool disabled;
  final Color? bgColor;
  final double? borderradius;
  final Color? borderColor;
  final double? borderWidth;

  final double? lineHeight;

  const CustomText({
    super.key,
    this.text,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.margin,
    this.decoration,
    this.bgColor,
    this.borderWidth,
    this.borderColor,
    this.borderradius,
    this.fontSize = 14,
    this.isBold = false,
    this.isSemiBold = false,
    this.isMedium = false,
    this.isLight = false,
    this.isItalic = false,
    this.fontFamily = "Gilroy",
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.padding,
    this.decorationColor,
    this.letterSpacing,
    this.wordSpacing,
    this.style,
    this.underline = false,
    this.disabled = false,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    FontWeight resolvedWeight =
        fontWeight ??
        (isBold
            ? FontWeight.w700
            : isSemiBold
            ? FontWeight.w600
            : isMedium
            ? FontWeight.w500
            : isLight
            ? FontWeight.w300
            : FontWeight.w400);

    final textWidget = Text(
      text ?? "",
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style:
          style ??
          TextStyle(
            color: disabled
                ? AppColors.grayColor
                : color ?? AppColors.primary500,
            fontSize: ScallingConfig.moderateScale(fontSize),
            fontWeight: resolvedWeight,
            fontFamily: fontFamily,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            decoration: underline
                ? TextDecoration.underline
                : (decoration ?? TextDecoration.none),
            decorationColor: decorationColor ?? color,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            height: lineHeight,
          ),
    );

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderradius ?? 0),
          border: borderColor != null
              ? Border.all(
                  color: borderColor ?? Colors.transparent,
                  width: borderWidth ?? 0,
                )
              : null,
        ),
        margin: margin ?? EdgeInsets.zero,
        width: width,
        height: height,
        child: Padding(padding: padding ?? EdgeInsets.zero, child: textWidget),
      ),
    );
  }
}
