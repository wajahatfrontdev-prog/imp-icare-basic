import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/svg_wrapper.dart';

class ChooseLocationButton extends StatelessWidget {
  const ChooseLocationButton({super.key, this.label = "Choose"});
  final String? label;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          isBold: true,
          fontSize: ScallingConfig.moderateScale(14.78),
          color: AppColors.primary500,
          fontWeight: FontWeight.w400,
          fontFamily: "GIlroy-SemiBold",
        ),
        CustomButton(
          label: "Select Location",
          labelColor: AppColors.lightGrey100,
          labelWidth: Utils.windowWidth(context) * 0.7,
          bgColor: AppColors.white,
          width: Utils.windowWidth(context) * 0.9,
          height: ScallingConfig.scale(50),
          // padding: EdgeInsets.symmetric(vertical: 20),
          outlined: true,
          borderColor: AppColors.lightGrey100,
          trailingIcon: SvgWrapper(assetPath: ImagePaths.marker3),
          borderRadius: 30,
        ),
      ],
    );
  }
}
