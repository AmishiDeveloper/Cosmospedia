import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AsteroidEmptyListWidget extends StatelessWidget {
  const AsteroidEmptyListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 60.h,
            color: AppColors.surfaceLight.withOpacity(
                0.5),
          ),
          SizedBox(height: 15.h),
          Text(
            "Space is quiet today...",
            style: AppTextStyles.subHeadingLargeStyle(
                context),
          ),
          SizedBox(height: 5.h),
          Text(
            "No asteroids reported for this date.",
            style: AppTextStyles
                .descriptionMediumTextStyle(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}