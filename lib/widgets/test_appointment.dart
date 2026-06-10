import 'package:flutter/material.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:icare/models/app_enums.dart';
import 'package:icare/screens/home.dart';
import 'package:icare/utils/imagePaths.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/custom_button.dart';
import 'package:icare/widgets/custom_text.dart';

// enum Status { upcoming, cancelled, completed }
class TestAppointment extends StatelessWidget {
  const TestAppointment({super.key, this.status, this.showActions = true});
  final BookingStatus? status;
  final bool showActions;
  @override
  Widget build(BuildContext context) {
    Widget action = status == BookingStatus.upcoming
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                width: Utils.windowWidth(context) * 0.36,
                height: Utils.windowHeight(context) * 0.055,
                borderRadius: 30,
                labelSize: 15,
                label: "View",
                onPressed: () {
                  // TODO: Navigate to appointment detail with actual appointment data
                  // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ProfileOrAppointmentViewScreen(appointment: appointment)));
                },
              ),
              SizedBox(width: ScallingConfig.scale(10)),
              CustomButton(
                borderRadius: 30,
                labelSize: 15,
                labelColor: AppColors.primaryColor,
                width: Utils.windowWidth(context) * 0.36,
                height: Utils.windowHeight(context) * 0.055,
                label: "Cancel",
                outlined: true,
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => DeclineAppointments()));
                },
              ),
            ],
          )
        : status == BookingStatus.cancelled
        ? CustomButton(
            label: "View Appointment",
            height: Utils.windowHeight(context) * 0.055,
            borderRadius: 30,
            labelSize: 15,
            onPressed: () {
              // TODO: Navigate to appointment detail with actual appointment data
              // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ProfileOrAppointmentViewScreen(appointment: appointment)));
            },
          )
        : CustomButton(
            label: "View Chat",
            height: Utils.windowHeight(context) * 0.055,
            borderRadius: 30,
            labelSize: 15,
          );
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScallingConfig.scale(10),
        vertical: ScallingConfig.verticalScale(10),
      ),
      width: Utils.windowWidth(context) * 0.85,

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              ImagePaths.user13,
              fit: BoxFit.cover,
              width: ScallingConfig.scale(80),
              height: ScallingConfig.scale(80),
            ),
          ),
          SizedBox(width: ScallingConfig.scale(20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Alyana",
                fontFamily: "Gilroy-Bold",
                fontSize: 14,
                color: AppColors.themeDarkGrey,
              ),
              SizedBox(height: ScallingConfig.scale(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TimeStampWidget(title: "Date", data: "01-AUG-2025"),
                  SizedBox(width: ScallingConfig.scale(10)),
                  TimeStampWidget(title: "Time", data: "07 PM - 08 PM"),
                ],
              ),
              if (showActions) action,
            ],
          ),
        ],
      ),
    );
  }
}
