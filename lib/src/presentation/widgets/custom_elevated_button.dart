import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final double? height;
  final double? elevation;
  final double? width;
  final Color? backgroundColor;
  final bool enabled;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final Icon? leadingIcon;
  final Widget? leadingIconWidget;
  final Icon? suffixIcon;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.textStyle,
    required this.onPressed,
    this.height,
    this.width,
    this.elevation,
    this.backgroundColor,
    //this.disabledBackgroundColor,
    this.textColor,
    this.enabled = true,
    this.borderRadius,
    this.fontSize,
    this.padding,
    this.suffixIcon,
    this.leadingIcon,
    this.leadingIconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            elevation: elevation ?? 2,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 5.w),
            backgroundColor: backgroundColor ?? AppColors.surfaceLight,
            //Theme.of(context).colorScheme.surface,
            //disabledBackgroundColor??
            minimumSize: Size(width ?? constraints.minWidth, height ?? 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
              side: BorderSide(
                color: AppColors
                    .surfaceLight, //Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20.h, // Spinner ka size chota rakhein
                  width: 20.w,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor ?? AppColors.black,
                    ),
                  ),
                )
              : FittedBox(
                  child: Row(
                    children: [
                      if (leadingIcon != null) leadingIcon!,
                      if (leadingIconWidget != null) leadingIconWidget!,
                      if (leadingIcon != null || leadingIconWidget != null)
                        SizedBox(width: 15.w),
                      Text(
                        text,
                        style:
                            textStyle ??
                            AppTextStyles.descriptionLargeTextStyle(
                              context,
                            ).copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                      ),
                      if (suffixIcon != null) SizedBox(width: 5.w),
                      if (suffixIcon != null) suffixIcon!,
                    ],
                  ),
                ),
        );
      },
    );
  }
}
