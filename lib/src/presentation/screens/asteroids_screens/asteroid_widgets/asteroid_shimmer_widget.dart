import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AsteroidShimmerWidget extends StatelessWidget {
  const AsteroidShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      // Padding zaroori hai taaki edges se chipke na
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
          crossAxisAlignment: CrossAxisAlignment.start, // Isse alignment sahi rahegi
          children: [
            Container(
              height: 55.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade600,
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Bone.text(words: 2),
                  Spacer(),
                  Bone.circle(size: 50.h),
                  Bone.circle(size: 50.h),
                ],
              ),
            ),

            SizedBox(height: 15.h),

            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              // Isse list apne content ke barabar height legi
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context,index) {
                return Container(
                  //height: 305.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 20.h),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.greyShimmerShade600,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Bone.circle(size:50.h),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Bone.text(words: 4),
                                SizedBox(height: 9.h),
                                Bone.text(words: 1),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Divider(
                        color: AppColors.greyShimmerShade400,
                        height: 20.h,
                      ),

                      _buildInfoRow(
                        context: context,
                        titleWords: 1,
                        valueWords: 2,
                      ),

                      SizedBox(height: 5.h),

                      // _buildInfoRow(
                      //   context: context,
                      //   titleWords: 2,
                      //   valueWords: 1,
                      // ),
                      //
                      // SizedBox(height: 5.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Bone.text(
                            words: 2,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 2.h,
                              horizontal: 6.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.greyShimmerShade400,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Bone.text(words: 1),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greyShimmerShade400,
                          border: Border.all(color: AppColors.surfaceLight),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Bone.text(
                              words: 2,
                            ),

                            SizedBox(height: 10.h),

                            _buildInfoRow(
                              context: context,
                              titleWords: 1,
                              valueWords: 1,
                            ),

                            SizedBox(height: 5.h),

                            _buildInfoRow(
                              context: context,
                              titleWords: 1,
                              valueWords: 2,
                            ),

                            SizedBox(height: 5.h),

                            _buildInfoRow(
                              context: context,
                              titleWords: 2,
                              valueWords: 2,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),
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

  Widget _buildInfoRow({
    required BuildContext context,
    required int titleWords,
    required int valueWords,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Bone.text(words:titleWords,),

        Bone.text(words: valueWords,),

      ],
    );
  }
}
