import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/screens/labb_details.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/svg_wrapper.dart';

class Laboratory extends StatelessWidget {
  const Laboratory({super.key, this.margin, this.labData});
  final EdgeInsets? margin;
  final Map<String, dynamic>? labData;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb && MediaQuery.of(context).size.width > 900;

    final String name = labData?['name'] ?? "Quantum Spar Lab";
    final String location =
        labData?['address'] ??
        labData?['location'] ??
        "4915 Muller Radial, 84904, USA";
    final String open = labData?['open'] ?? "Open at 9:00am";
    final String homeSample = labData?['homeSample'] ?? "Home Sample Available";
    final String image = labData?['image'] ?? ImagePaths.lab3;

    return Container(
      width: isWeb ? 380 : Utils.windowWidth(context) * 0.85,
      height: isWeb ? 240 : Utils.windowHeight(context) * 0.25,
      margin: margin ?? EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
      ),
      child: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          Container(
            height: isWeb ? 110 : Utils.windowHeight(context) * 0.1,
            padding: EdgeInsets.symmetric(horizontal: ScallingConfig.scale(10)),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18),
                topLeft: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        fontSize: isWeb ? 13 : 14,
                        fontFamily: "Gilroy-Bold",
                        fontWeight: FontWeight.bold,
                        color: AppColors.themeDarkGrey,
                      ),
                      SizedBox(height: ScallingConfig.scale(3)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgWrapper(
                            assetPath: ImagePaths.marker2,
                            width: ScallingConfig.scale(12),
                            height: ScallingConfig.scale(12),
                          ),
                          SizedBox(width: ScallingConfig.scale(4)),
                          Flexible(
                            child: CustomText(
                              text: location,
                              fontFamily: "Gilroy-Medium",
                              fontSize: isWeb ? 9 : 10,
                              color: AppColors.grayColor,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScallingConfig.scale(3)),
                      Row(
                        children: [
                          SvgWrapper(
                            assetPath: ImagePaths.home_edit,
                            width: ScallingConfig.scale(12),
                            height: ScallingConfig.scale(12),
                          ),
                          SizedBox(width: ScallingConfig.scale(4)),
                          Flexible(
                            child: CustomText(
                              text: homeSample,
                              fontFamily: "Gilroy-Medium",
                              fontSize: isWeb ? 9 : 10,
                              color: AppColors.grayColor,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: ScallingConfig.scale(8)),

                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgWrapper(
                            assetPath: ImagePaths.clock,
                            width: ScallingConfig.scale(12),
                            height: ScallingConfig.scale(12),
                          ),
                          SizedBox(width: ScallingConfig.scale(4)),
                          Flexible(
                            child: CustomText(
                              text: open,
                              fontFamily: "Gilroy-Regular",
                              fontSize: isWeb ? 9 : 10,
                              color: AppColors.themeDarkGrey,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScallingConfig.scale(6)),
                      CustomButton(
                        label: "Visit",
                        width: isWeb ? 80 : Utils.windowWidth(context) * 0.2,
                        height: isWeb ? 28 : ScallingConfig.scale(28),
                        borderRadius: 20,
                        labelSize: isWeb ? 11 : 12,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => LabDetails(labData: labData),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
