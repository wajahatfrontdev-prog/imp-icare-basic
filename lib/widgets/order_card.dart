import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/models/app_enums.dart';
import 'package:icare/screens/manage_orders.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/widgets/custom_circle_icon_button.dart';
import 'package:icare/widgets/custom_text.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.type = OrderType.delivered,
  });
  final Map<String, dynamic> order;
  final OrderType type;

  @override
  Widget build(BuildContext context) {
    final patient = order["patient"];
    final info = order["orderInfo"];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: order["labName"],
                fontSize: 18,
                fontFamily: "Gilroy-SemiBold",
                color: AppColors.themeDarkGrey,
                fontWeight: FontWeight.w600,
              ),
              type == OrderType.delivered
                  ? CustomCircleIconButton(iconPath: ImagePaths.success)
                  : type == OrderType.cancelled
                  ? CustomCircleIconButton(
                      iconPath: ImagePaths.failed,
                      size: 36,
                    )
                  : const SizedBox(),
            ],
          ),

          const SizedBox(height: 10),

          CustomText(
            text: "Products",
            fontSize: 12,
            fontFamily: "Gilroy-Medium",
            color: AppColors.themeDarkGrey,
            fontWeight: FontWeight.w400,
          ),

          const SizedBox(height: 6),

          Row(
            children: List.generate(
              order["products"].length,
              (index) => Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.lightGrey200),
                ),
                child: Image.asset(
                  order["products"][index]["image"],
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Info Rows
          _infoRow("Name", patient["name"]),
          _infoRow("", "Shahrah - e faisal near KFC Street 1"),
          _infoRow("Age", patient["age"].toString()),
          _infoRow("Date", info["date"]),
          _infoRow("Time", info["time"]),
          _infoRow("Phone Number", patient["phone"]),
          _infoRow("Amount", info["amount"].toString()),

          const SizedBox(height: 6),

          /// Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Status",
                fontSize: 12,
                fontFamily: "Gilroy-Medium",
                color: AppColors.themeDarkGrey,
                fontWeight: FontWeight.w400,
              ),
              CustomText(
                text: type == OrderType.delivered
                    ? "Delivered"
                    : type == OrderType.cancelled
                    ? "Cancelled"
                    : "N/A",
                fontSize: 13,
                fontFamily: "Gilroy-SemiBold",
                color: type == OrderType.delivered
                    ? AppColors.themeGreen
                    : type == OrderType.cancelled
                    ? AppColors.themeRed
                    : AppColors.themeDarkGrey,

                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          if (type == OrderType.cancelled)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  text: "Cancelled from our side",
                  fontSize: 13,
                  color: AppColors.themeRed,
                  fontFamily: "Gilroy-Medium",
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          if (type == OrderType.recent) ...[
            SizedBox(height: ScallingConfig.scale(20)),
            CustomText(
              text: "Manage Order",
              fontSize: 13,
              width: double.infinity,
              textAlign: TextAlign.center,
              color: AppColors.themeRed,

              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (ctx) => ManageOrders()));
              },
              fontFamily: "Gilroy-Medium",
              fontWeight: FontWeight.w400,
            ),
          ],
        ],
      ),
    );
  }
}

Widget _infoRow(String title, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: ScallingConfig.scale(5)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: 12,
          fontFamily: "Gilroy-Medium",
          color: AppColors.themeDarkGrey,
          fontWeight: FontWeight.w400,
        ),
        Expanded(
          child: CustomText(
            text: value,
            maxLines: 3,
            textAlign: TextAlign.right,
            fontSize: 12,

            fontFamily: "Gilroy-SemiBold ",
            color: AppColors.themeDarkGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
