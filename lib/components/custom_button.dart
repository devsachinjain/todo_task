import 'package:demo/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isActive = false,
      this.loader = false,
      required this.width,
      required this.height,
      required this.radius});
  final String title;
  final Function onPressed;
  final bool isActive;
  final bool loader;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color:
                isActive ? AppColors.darkBlueColor : AppColors.lightBlueColor),
        child: Center(
            child: loader
                ? const CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  )
                : Text(
                    title,
                    style: TextStyle(
                        color: isActive
                            ? AppColors.whiteColor
                            : AppColors.darkBlueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  )),
      ),
    );
  }
}
