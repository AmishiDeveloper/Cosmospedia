import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h,),
      margin: EdgeInsets.only(bottom: 13.h,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(width: 1,color: AppColors.textPrimaryDark,),
        color: AppColors.surfaceLight.withOpacity(0.3),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: AppTextStyles.headingMediumStyle(context),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}