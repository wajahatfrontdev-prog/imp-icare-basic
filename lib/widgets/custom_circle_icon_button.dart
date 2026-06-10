import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/widgets/svg_wrapper.dart';

class CustomCircleIconButton extends StatelessWidget {
  const CustomCircleIconButton({
    super.key,
    this.size,
    this.bgColor,
    this.iconPath,
    this.iconColor,
    this.iconSize,
    this.iconData,
    this.onTap,
  });

  final double? size;
  final Color? bgColor;
  final String? iconPath;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double base = size ?? 40.0;
    final double s = ScallingConfig.scale(base);
    final double iSize = ScallingConfig.scale(iconSize ?? (s * 0.5));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: s,
        height: s,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Center(
          child: iconData != null
              ? Icon(iconData, color: iconColor, size: iSize)
              : SvgWrapper(
                  assetPath: iconPath ?? "",
                  color: iconColor,
                  width: iSize,
                  height: iSize,
                ),
        ),
      ),
    );
  }
}
