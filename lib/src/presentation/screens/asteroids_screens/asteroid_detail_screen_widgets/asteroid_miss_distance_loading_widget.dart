import 'package:flutter/material.dart';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget asteroidMissDistanceLoadingWidget() {
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
      height: 790.h,
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
              Bone.circle(size: 30.w),
              SizedBox(width: 10.w),
              Bone.text(words: 2),
              SizedBox(width: 10.w),
              //Spacer(),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Bone(
                    borderRadius: BorderRadius.circular(8.r),
                    width: 70.w,
                    height: 25.h,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(color: AppColors.surfaceLight, height: 2.h),

          SizedBox(height: 20.h),

          // bar chart
          Container(
            height: 200.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade850.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Bone(
                        height: 120.h,
                        borderRadius: BorderRadius.circular(6.r),
                        width: 40.w,
                      ),
                      Bone.icon(size: 30.w),
                      Bone.text(words: 1),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Bone(
                        height: 120.h,
                        borderRadius: BorderRadius.circular(6.r),
                        width: 40.w,
                      ),
                      Bone.icon(size: 30.w),
                      Bone.text(words: 1),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Bone(
                        height: 120.h,
                        borderRadius: BorderRadius.circular(6.r),
                        width: 40.w,
                      ),
                      Bone.icon(size: 30.w),
                      Bone.text(words: 1),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Bone(
                        height: 120.h,
                        borderRadius: BorderRadius.circular(6.r),
                        width: 40.w,
                      ),
                      Bone.icon(size: 30.w),
                      Bone.text(words: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // context
          Container(
            height: 450.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade400.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 1),
                SizedBox(height: 10.h),
                Bone.multiText(lines: 4),
                SizedBox(height: 10.h),
                Bone.multiText(lines: 4),
                SizedBox(height: 10.h),
                Bone.text(words: 2),
                SizedBox(height: 10.h),
                Bone.multiText(lines: 2),
                SizedBox(height: 10.h),
                Bone.text(words: 6),
                SizedBox(height: 10.h),
                Bone.text(words: 4),
                SizedBox(height: 10.h),
                Bone.text(words: 4),
                SizedBox(height: 10.h),
                Bone.text(words: 4),
                SizedBox(height: 20.h),
                Bone.multiText(lines: 2),
              ],
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    ),
  );
}
