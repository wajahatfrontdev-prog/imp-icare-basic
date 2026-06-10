import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/section_header.dart';
import 'svg_wrapper.dart';

class PharmcyCategories extends StatelessWidget {
  const PharmcyCategories({
    super.key,
    this.categories,
    this.selectedCategory = "",
    required this.onCategorySelect,
  });
  final List? categories;

  final String selectedCategory;
  final Function(String) onCategorySelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Categories",
          showAction: false,
          padding: EdgeInsets.symmetric(horizontal: ScallingConfig.scale(10)),
        ),
        SizedBox(height: ScallingConfig.scale(10)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScallingConfig.scale(10)),
          child: Row(
            spacing: ScallingConfig.scale(20),
            children: [
              for (var category in categories!)
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        onCategorySelect(category["name"]);
                      },
                      child: CircleAvatar(
                        radius: ScallingConfig.scale(25),
                        backgroundColor: selectedCategory == category["name"]
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor.withAlpha(10),
                        child: SvgWrapper(
                          assetPath: category['icon'],
                          color: selectedCategory == category["name"]
                              ? AppColors.white
                              : AppColors.primaryColor,
                        ),
                      ),
                    ),
                    CustomText(
                      text: category["name"],
                      fontFamily: "Gilroy-SemiBold",
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: AppColors.darkGray600,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
