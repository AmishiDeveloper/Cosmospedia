import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FaqShimmerWidget extends StatelessWidget {
  const FaqShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildFaqList(context);
  }

  Widget _buildFaqList(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      // Padding zaroori hai taaki edges se chipke na
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Skeletonizer(
        ignoreContainers: false,
        enabled: true,
        effect: const ShimmerEffect(
          baseColor: AppColors.whiteShimmer,
          highlightColor: Colors.white70,
          duration: Duration(milliseconds: 1000),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ListView.builder(
              padding: EdgeInsets.only(bottom: 16.h),
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),// because parent is scrollable
              itemBuilder: (context, index) {
                return _buildFaqCategory();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqCategory() {

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      elevation: 4.r,
      // Reduced elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color:  AppColors.greyShimmerShade600,
      // Transparent base
      child:
        Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  Bone.circle(size: 50.r),

                  SizedBox(width: 16.w),

                  Bone.text(words: 3),

                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: AppColors.greyShimmerShade400,
                  height: 1.h,
                ),
              ),

              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.greyShimmerShade400,
                  height: 1.h,
                ),
                itemBuilder: (context, itemIndex) {
                  return _buildFaqItem();
                },
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildFaqItem() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Bone.text(words:3),
          trailing: Bone.circle(size: 32.r),
        ),

      ],
    );
  }
}
