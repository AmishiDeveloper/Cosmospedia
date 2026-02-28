import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ApodShimmerWidget extends StatelessWidget {
  const ApodShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        // Padding zaroori hai taaki edges se chipke na
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Skeletonizer(
          enabled: true,
          effect: const ShimmerEffect(
            baseColor: AppColors.whiteShimmer,
            highlightColor: Colors.white70,
          ),
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Carousel Section

            // carousel img
            Container(
              height: 180.h, // FIX: Expanded ki jagah fixed height di
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade900,
                borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(20.r),
                             topRight: Radius.circular(20.r),

              ),
              ),
              child: const Bone(
                  width: double.infinity,
                  height: double.infinity,
              ),
            ),

            // Carousel Content Placeholder
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade700,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  const Bone.text(words: 2), // Title placeholder
                  SizedBox(height: 5.h),
                  const Bone.text(words: 1), // Date placeholder
                ],
              ),
            ),

            // Carousel Dots Shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) { // Fixed count (e.g., 3) shimmer ke liye
                return Container(
                  width: index == 0 ? 18.w : 7.w, // Pehle dot ko active (lamba) dikhayenge
                  height: 7.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    // Skeletonizer colors ko override kar lega,
                    // lekin structure ke liye color dena zaroori hai
                    color: AppColors.greyShimmerShade400,
                  ),
                );
              }),
            ),

            SizedBox(height: 30.h),

            // 2. Date Picker Row
            Row(
              children: [
                Expanded(child: Bone(height: 50.h, borderRadius: BorderRadius.circular(10.r))),
                SizedBox(width: 20.w),
                Expanded(child: Bone(height: 50.h, borderRadius: BorderRadius.circular(10.r))),
              ],
            ),

            SizedBox(height: 30.h),


            // 4. Feature Card
            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias, // Zaroori hai taaki andar ke corners cut sakein
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade900, // Card ka base color
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Part
                   Bone(
                    height: 185.h,
                    width: double.infinity,
                  ),

                  // Text Part - Fixed with Color and Borders
                  Container(
                    width: double.infinity, // Full width zaroori hai
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: AppColors.greyShimmerShade900, // FIX: Background color add kiya
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Bone.text(words: 3),
                        SizedBox(height: 15.h),
                        const Bone.text(words: 5),
                        SizedBox(height: 10.h),
                        const Bone.text(words: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Extra Space card ke bahar rakhein taaki scrolling sahi ho
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}