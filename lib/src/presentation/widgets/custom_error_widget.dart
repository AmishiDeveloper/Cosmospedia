import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/const/image/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_elevated_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry; // API dobara hit karne ke liye function

  const CustomErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Astronaut Image/Animation
            // Aap Image.asset ya Lottie.asset use kar sakti hain
            // Icon(
            //   Icons.rocket_outlined, // Placeholder, yahan astronaut image lagayein
            //   size: 100.sp,
            //   color: AppColors.surfaceLight.withOpacity(0.5),
            // ),

            // Container(
            //   height: 240.h,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     boxShadow: [
            //       BoxShadow(
            //         color: AppColors.textPrimaryDark.withOpacity(0.3), // Glow ka color
            //         blurRadius: 70, // Jitna zyada, utna faila hua glow
            //         spreadRadius: 1, // Shadow ka gherao
            //       ),
            //     ],
            //   ),
            //   child: Image.asset(
            //     AppImages.floatingAstronaut,
            //     fit: BoxFit.contain,
            //   ),
            // ),

            Image.asset(
              AppImages.floatingAstronaut,
              //fit: BoxFit.contain,
              height: 240.h,
            ),

            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // Blur intensity
            //   child: Image.asset(
            //     AppImages.floatingAstronaut,
            //     height: 240.h,
            //   ),
            // ),
            
            Text(
              'Whoops...',
              textAlign: TextAlign.center,
              style: AppTextStyles.headingLargeStyle(context).copyWith(
                fontSize:22.sp,
                color: AppColors.surfaceLight,
              ),
            ),
            Text(
              'It looks like you are lost in space!',
              textAlign: TextAlign.center,
              style: AppTextStyles.headingSmallStyle(context).copyWith(
                fontSize: 13.sp,
                color: AppColors.surfaceLight,
              ),
            ),
            
             SizedBox(height: 15.h,),

            //  2. Dynamic Error Message
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.subHeadingSmallStyle(context).copyWith(
                color: AppColors.greyShimmerShade50,
                fontSize: 20.sp,
              ),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 15.h),
            
            // 3. Retry Button
            CustomElevatedButton(
              onPressed: onRetry,
              text: 'Try Again',
              textStyle:  AppTextStyles.descriptionLargeTextStyle(
                context,
              ).copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              height: 45.h,
            ),

          ],
        ),
      ),
    );
  }
}