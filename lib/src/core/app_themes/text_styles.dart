import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles{

  // static TextStyle headingLargeStyle(BuildContext context) => GoogleFonts.lora(//.merriweather(//lora(//robotoSlab(
  //   fontSize: 26.sp,
  //   fontWeight: FontWeight.bold,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle headingMediumStyle(BuildContext context) => GoogleFonts.lora(
  //   fontSize: 20.sp,
  //   fontWeight: FontWeight.bold,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle headingSmallStyle(BuildContext context) => GoogleFonts.lora(
  //   fontSize: 18.sp,
  //   fontWeight: FontWeight.bold,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle subHeadingLargeStyle(BuildContext context) => GoogleFonts.lora(
  //   fontSize: 20.sp,
  //   fontWeight: FontWeight.w600,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle subHeadingMediumStyle(BuildContext context) => GoogleFonts.lora(
  //   fontSize: 18.sp,
  //   fontWeight: FontWeight.w600,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle subHeadingSmallStyle(BuildContext context) => GoogleFonts.lora(
  //   fontSize: 16.sp,
  //   fontWeight: FontWeight.w600,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle descriptionLargeTextStyle(BuildContext context) => GoogleFonts.robotoSlab(
  //   fontSize: 18.sp,
  //   fontWeight: FontWeight.w500,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle descriptionMediumTextStyle(BuildContext context) => GoogleFonts.robotoSlab(
  //   fontSize: 16.sp,
  //   fontWeight: FontWeight.w500,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle descriptionSmallTextStyle(BuildContext context) => GoogleFonts.robotoSlab(
  //   fontSize: 14.sp,
  //   fontWeight: FontWeight.w500,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  //
  // static TextStyle bodyTextStyle(BuildContext context) => GoogleFonts.merriweather(
  //   fontSize: 14.sp,
  //   fontWeight: FontWeight.w400,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );
  //
  // static TextStyle smallTextStyle(BuildContext context) => GoogleFonts.merriweather(
  //   fontSize: 12.sp,
  //   fontWeight: FontWeight.w400,
  //   color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  // );


  static TextStyle headingLargeStyle(BuildContext context) => TextStyle(//.merriweather(//lora(//robotoSlab(
    fontFamily:'Lora',
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle headingMediumStyle(BuildContext context) => TextStyle(
    fontFamily: 'Lora',
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle headingSmallStyle(BuildContext context) => TextStyle(
    fontFamily: 'Lora',
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle subHeadingLargeStyle(BuildContext context) => TextStyle(
    fontFamily: 'Lora',
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle subHeadingMediumStyle(BuildContext context) => TextStyle(
    fontFamily: 'Lora',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle subHeadingSmallStyle(BuildContext context) => TextStyle(
    fontFamily: 'Lora',
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle descriptionLargeTextStyle(BuildContext context) => TextStyle(
    fontFamily: 'RobotoSlab',
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle descriptionMediumTextStyle(BuildContext context) => TextStyle(
    fontFamily: 'RobotoSlab',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle descriptionSmallTextStyle(BuildContext context) => TextStyle(
    fontFamily: 'RobotoSlab',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );


  static TextStyle bodyTextStyle(BuildContext context) => GoogleFonts.merriweather(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle smallTextStyle(BuildContext context) => TextStyle(
    fontFamily: 'Merriweather',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.surfaceLight,//Theme.of(context).colorScheme.onSurface,
  );
}