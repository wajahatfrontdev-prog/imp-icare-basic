import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/custom_text_input.dart';
import 'package:icare/widgets/svg_wrapper.dart';

class UploadCourseScreen extends StatelessWidget {
  const UploadCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        title: CustomText(
          text: "Upload Course",
          fontFamily: "Gilroy-Bold",
          fontSize: 16.78,
          letterSpacing: -0.31,
          lineHeight: 1.0,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGray500,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CustomText(
                text: "Upload Your Course Video Here",
                width: Utils.windowWidth(context) * 0.8,
                fontSize: 18.78,
                color: AppColors.primary500,
                fontFamily: "Gilroy-Bold",

                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text:
                    "Upload your courses videos, and help others to grow in this field.",
                width: Utils.windowWidth(context) * 0.8,
                fontSize: 12,
                maxLines: 2,
                textAlign: TextAlign.left,
                color: AppColors.themeDarkGrey,
                fontFamily: "Gilroy-Regular",
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: ScallingConfig.scale(20)),
              UploadFile(),
              SizedBox(height: ScallingConfig.scale(20)),
              CustomInputField(
                title: "Video Title",
                margin: EdgeInsets.symmetric(
                  horizontal: ScallingConfig.scale(10),
                ),
                width: Utils.windowWidth(context) * 0.85,
                hintText: "Enter your video title",
              ),
              SizedBox(height: ScallingConfig.scale(20)),
              CustomInputField(
                margin: EdgeInsets.symmetric(
                  horizontal: ScallingConfig.scale(10),
                ),
                title: "Video Caption",
                width: Utils.windowWidth(context) * 0.85,
                hintText: "Enter your video Caption",
              ),

              SizedBox(height: ScallingConfig.scale(20)),
              CustomButton(
                label: "Upload",
                borderRadius: 40,
                width: Utils.windowWidth(context) * 0.9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadFile extends StatelessWidget {
  const UploadFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScallingConfig.verticalScale(20)),
      width: Utils.windowWidth(context) * 0.9,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryColor,
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          CustomText(
            text: "Upload Your File",
            fontFamily: "Gilroy-Bold",
            fontSize: 20.78,
            color: AppColors.primary500,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: ScallingConfig.scale(20)),
          SvgWrapper(assetPath: ImagePaths.cloud_upload),
          SizedBox(height: ScallingConfig.scale(20)),
          CustomText(
            text: "Upload your courses videos.",
            fontFamily: "Gilroy-Regular",
            fontSize: 12,
            color: AppColors.themeDarkGrey,
          ),
          SizedBox(height: ScallingConfig.scale(20)),
          CustomButton(
            label: "Select File",
            borderRadius: 50,
            height: ScallingConfig.scale(40),
            width: Utils.windowWidth(context) * 0.4,
            trailingIcon: SvgWrapper(assetPath: ImagePaths.upload),
          ),
        ],
      ),
    );
  }
}
