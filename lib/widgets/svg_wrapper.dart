import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWrapper extends StatelessWidget {
  final String assetPath;
  final Function()? onPress;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;
  final String? semanticsLabel;
  final bool isNetworkImage;
  final Widget? placeholder;
  final Widget? errorWidget;

  const SvgWrapper({
    super.key,
    required this.assetPath,
    this.onPress,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticsLabel,
    this.isNetworkImage = false,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final Widget svgWidget = isNetworkImage
        ? GestureDetector(
            onTap: onPress,
            child: SvgPicture.network(
              assetPath,
              width: width,
              height: height,
              colorFilter: color != null
                  ? ColorFilter.mode(color!, BlendMode.srcIn)
                  : null,
              fit: fit,
              alignment: alignment,

              semanticsLabel: semanticsLabel,
              placeholderBuilder: (context) =>
                  placeholder ??
                  Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
            ),
          )
        : GestureDetector(
            onTap: onPress,
            child: SvgPicture.asset(
              assetPath,
              width: width,
              height: height,
              colorFilter: color != null
                  ? ColorFilter.mode(color!, BlendMode.srcIn)
                  : null,
              fit: fit,
              alignment: alignment,
              semanticsLabel: semanticsLabel,
            ),
          );

    return svgWidget;
  }
}
