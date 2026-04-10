import 'package:flutter/material.dart';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget closeApproachLoadingWidget() {
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
      height: 695.h,
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade600,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // Isse alignment sahi rahegi
        children: [

          //header
          Row(
            children: [
              Bone.circle(size: 40.w),
              SizedBox(width: 10.w),
              Bone.text(words: 3),
              Spacer(),
              Bone(
                borderRadius: BorderRadius.circular(8.r),
                width: 35.w,
                height: 25.h,
                shape: BoxShape.rectangle,
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(color: AppColors.surfaceLight, height: 2.h),

          SizedBox(height: 20.h),

          // table
          Container(
            height: 450.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade850.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child:
                    Bone(
                      height: 600.h,
                      borderRadius: BorderRadius.circular(6.r),
                      width: 40.w,
                    ),
          ),

          SizedBox(height: 20.h),

          // closest approach
          Container(
            height: 100.h,
            padding: EdgeInsets.symmetric( vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade600,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            child: Bone(
              borderRadius:BorderRadius.circular(10.r),
              width: double.infinity,
            ),
          ),

        ],
      ),
    ),
  );
}
