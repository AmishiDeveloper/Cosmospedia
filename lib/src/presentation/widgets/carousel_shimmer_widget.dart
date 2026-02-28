import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CarouselShimmerWidget extends StatelessWidget {
  const CarouselShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: AppColors.whiteShimmer, //Colors.white38,
        highlightColor: Colors.white70,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                    color: AppColors.greyShimmerShade900,
                  ),
                child: const Bone(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade700,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
                border: Border.all(color: AppColors.surfaceLight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Title Universal Galaxy',
                    style: AppTextStyles.headingSmallStyle(
                      context,
                    ).copyWith(color: AppColors.greyShimmerShade400),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 1, // Overflow check
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '2026-02-12',
                    style: AppTextStyles.subHeadingSmallStyle(
                      context,
                    ).copyWith(color: AppColors.greyShimmerShade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
