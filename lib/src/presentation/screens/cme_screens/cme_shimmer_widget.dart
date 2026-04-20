import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CmeShimmerWidget extends StatelessWidget {
  const CmeShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // Loading ke waqt scroll avoid karein
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      child: Skeletonizer(
        enabled: true,
        effect: const ShimmerEffect(
          baseColor: AppColors.whiteShimmer,
          highlightColor: Colors.white70,
          duration: Duration(milliseconds: 1000),
        ),
        child: Column(
          children: [
            // 1. CME SUMMARY CARD SHIMMER
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade600,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.text(words: 2), // "CME Summary"
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(3, (index) => _buildStatBone()),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // 2. CME CLASSIFICATION GUIDE (LEGEND) SHIMMER
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade600,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Bone.circle(size: 30.r),
                      SizedBox(width: 8.w),
                      Bone.text(words: 3),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) => _buildLegendBone()),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // 3. CME EVENT TILES (LIST) SHIMMER
            ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.greyShimmerShade600,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Bone.circle(size: 40.r), // solar icon placeholder
                      SizedBox(width: 15.w),
                      Expanded(child: Bone.text(words: 3)), // Date placeholder
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                            color: AppColors.greyShimmerShade700,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppColors.greyShimmerShade100)
                        ),
                        child:Bone.text(words: 1),
                      ),
                      SizedBox(width: 5.w),
                      const Bone.icon(), // Arrow placeholder
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Summary card ke circles aur text ke liye
  Widget _buildStatBone() {
    return Column(
      children: [
        Bone.circle(size: 50.r),
        SizedBox(height: 10.h),
        Bone.text(words: 1),
        SizedBox(height: 12.h),
        Bone.text(words: 1),
      ],
    );
  }

  // Legend items ke liye
  Widget _buildLegendBone() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
              color: AppColors.greyShimmerShade700,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.greyShimmerShade100)
          ),
          child:Bone.text(words: 1,),
        ),
        // Type S/C/O
        SizedBox(height: 5.h),
        Bone.multiText(lines: 1, width: 60.w), // range
        Bone.multiText(lines: 1, width: 50.w), // km/s
      ],
    );
  }
}