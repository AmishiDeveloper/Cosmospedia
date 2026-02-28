import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  bool success = true, // it is optional to provide meaning if user provide something success value changes if user not provide anything then by default takes false
  bool canDismiss = true,
  double? elevation, // it is optional to provide meaning if user provide something elevation value is taken, if user not provide anything then by default takes null because no default value exists other than null
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  EdgeInsets? padding ,
  EdgeInsets? margin ,
  String? actionLabel,
  VoidCallback? onActionPressed,
  Color? backgroundColor,
  //double elevation,// if this written then throws error because it is optional as well as due to no ? null safety and  = default value means some value has to be provided so it is confusing
  //solution-
  //1. use required keyword, eg- {required double elevation}
  // 2. provide default value- eg-{double elevation=2.0},
  //3. use null safety -eg- {double? elevation}
}) {

  //if the page from which api is hit is changed the the code should be returned
  if(!context.mounted) {
    return;
  }

  //clear all previous snackbars
  ScaffoldMessenger.of(context).clearSnackBars();

  //create snackbar
  final SnackBar snackbar= SnackBar(
    backgroundColor: backgroundColor ?? (success
        ?AppColors.success
        :AppColors.error),
    behavior: behavior,
    padding:  padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    margin: margin ?? EdgeInsets.all(15.w),
    elevation: elevation ?? 1.sp,
    content:Text(
      message,
      style:AppTextStyles.descriptionSmallTextStyle(context),
    ),
    duration: const Duration(seconds: 3),
    dismissDirection: canDismiss
        ?DismissDirection.down
        :DismissDirection.none,
    action: actionLabel != null
        ? SnackBarAction(
      label: actionLabel,
      textColor: AppColors.surfaceLight,
      onPressed: onActionPressed!,
    )
        : null,
  );

  //show snackbar on screen
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
