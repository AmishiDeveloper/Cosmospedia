import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/const/image/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_elevated_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  //Future<void> Function() ya VoidCallback dono chalenge
  final Function onRetry; // API dobara hit karne ke liye function
  final ValueNotifier<bool> _isRetrying = ValueNotifier<bool>(false);

  CustomErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [

              Image.asset(
                AppImages.floatingAstronaut,
                //fit: BoxFit.contain,
                height: 240.h,
              ),

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
                  fontSize: 16.sp,
                ),
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 15.h),

              // 3. Retry Button
              ValueListenableBuilder(
                valueListenable: _isRetrying,
                builder: (context, isLoading, child) {
                  return CustomElevatedButton(
                    isLoading: isLoading,
                    loadingText: 'Trying Again...',
                    onPressed: () async {
                      //Result nikalo function ko call karke
                      final result= onRetry();

                      // 2. Check karo kya result Future hai?
                      if (result is Future) {
                        _isRetrying.value = true;

                        try {
                          await result;
                        } finally {
                          _isRetrying.value = false;
                        }
                      }
                    },//onRetry,
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
                  );
                }
              ),

            ],
          ),
        ),
      ),
    );
  }
}