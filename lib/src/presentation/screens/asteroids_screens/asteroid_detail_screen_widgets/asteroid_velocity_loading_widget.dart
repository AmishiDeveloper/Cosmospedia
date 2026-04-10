import 'package:flutter/material.dart';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget asteroidVelocityLoadingWidget() {
  return Skeletonizer(
    ignoreContainers: false,
    enabled: true,
    effect: const ShimmerEffect(
      baseColor: AppColors.whiteShimmer,
      highlightColor: AppColors.greyShimmerShade200,
      duration: Duration(milliseconds: 1000),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      height: 490.h,
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade600,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // Isse alignment sahi rahegi
        children: [

          // header
          Row(
            children: [
              Bone.circle(size: 40.w),
              Spacer(),
              Bone.text(words: 4),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(color: AppColors.surfaceLight, height: 2.h),

          SizedBox(height: 20.h),

          // graph
          Container(
            height: 280.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade800.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Bone(borderRadius:BorderRadius.circular(10.r),height: 200.h,),
          ),

          SizedBox(height: 20.h),

          // max velocity
          Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade600,
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Bone(
              borderRadius:BorderRadius.circular(25.r),
              width: double.infinity,
              //height: 40.h,
            ),
          ),

          //SizedBox(height: 10.h),
        ],
      ),
    ),
  );
}
