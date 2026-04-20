import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupScreen extends StatelessWidget {
  final String title;
  final String description;
  final String positiveButtonText;
  final String negativeButtonText;
  final VoidCallback? onTap;

  const PopupScreen({
    super.key,
    required this.title,
    required this.description,
    required this.positiveButtonText,
    required this.negativeButtonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: AppColors.surfaceLight,
      elevation: 4.sp,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.r),
      ),
      shadowColor: AppColors.greyShimmerShade100,
      backgroundColor: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomElevatedButton(
                  onPressed: (){
                    if (onTap != null) {
                      Navigator.pop(context);
                      onTap!();
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  text: positiveButtonText,
                  height: 35.h,
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  highlightColor: AppColors.greyShimmerShade300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Text(
                      negativeButtonText,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}