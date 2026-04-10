import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget orbitLoadingWidget() {
  return Skeletonizer(
    ignoreContainers: false,
    enabled: true,
    effect: const ShimmerEffect(
      baseColor: AppColors.whiteShimmer,
      highlightColor: AppColors.greyShimmerShade200,
      duration: Duration(milliseconds: 1000),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
      height: 500.h,
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade600,
        borderRadius:BorderRadius.circular(15.r),
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
              SizedBox(width: 20.w,),
              Bone.text(words: 3),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(color: AppColors.surfaceLight, height: 2.h),

          SizedBox(height: 20.h),

          // orbit
          Container(
            height: 230.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade700.withOpacity(0.5),
              shape: BoxShape.circle
              //borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Bone.circle(),
          ),

          SizedBox(height: 10.h),

          Container(
            height: 55.h,
            //padding: EdgeInsets.symmetric(horizontal: 35.w,vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade600,
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Bone.square(size: 13.h,),
                SizedBox(width: 10.w),
                Bone.text(words: 2,),

                SizedBox(width: 20.w,),

                Bone.square(size: 13.h,),
                SizedBox(width: 10.w),
                Bone.text(words: 1,),

              ],
            ),
          ),

          SizedBox(height: 10.h),

          Container(
            height: 80.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade600,
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
              border: Border.all(color: AppColors.greyShimmerShade400),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Bone.circle(size: 30.h),
                SizedBox(width: 15.w),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone.text(words: 2),
                          SizedBox(height: 10.h,),
                          Flexible(
                              child: Bone.text(words: 10),
                          ),
                        ],
                    ),
                ),
              ],
            ),
          ),

        ],
      ),
    ),
  );
}
