import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/svg_wrapper.dart';

class AvailableBadge extends StatelessWidget {
  const AvailableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: ScallingConfig.scale(65),
          bottom: ScallingConfig.scale(8),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            child: Center(child: SvgWrapper(assetPath: ImagePaths.pencil)),
          ),
        ),
        Container(
          width: Utils.windowWidth(context) * 0.22,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
          decoration: BoxDecoration(
            color: AppColors.darkGreyColor.withAlpha(55),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: ScallingConfig.scale(5),
            children: [
              Icon(
                Icons.circle,
                size: ScallingConfig.scale(10),
                color: Colors.green,
              ),
              CustomText(
                text: "Available",
                color: AppColors.primary500,
                fontSize: 12,
                fontFamily: "Gilroy-SemiBold",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
