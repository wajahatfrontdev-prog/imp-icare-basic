import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.margin, this.color});
  final EdgeInsets? margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: margin ?? EdgeInsets.only(left: 21),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: color ?? Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}
