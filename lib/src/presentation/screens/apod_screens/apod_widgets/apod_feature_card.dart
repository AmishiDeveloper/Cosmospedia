import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_detail_screen.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_widgets/apod_image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ApodFeatureCard extends StatelessWidget {
  final ApodModel item; // Aapka model yahan aayega
  const ApodFeatureCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          AppRoute.scale(
            ApodDetailScreen(item: item, heroTag: item.date.toString()),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 280.h),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          //border: Border.all(color: AppColors.surfaceLight),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
                child: Hero(
                  tag: item.date.toString(), // Unique tag for each image,
                  child: Image.network(
                    item.url ??
                        'https://www.shutterstock.com/image-vector/page-404-error-spaceman-flag-260nw-1484690978.jpg',
                    // Replace with your model field
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      //return const Center(child: CircularProgressIndicator());
                      return buildImagePlaceholder();
                    },
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 50.h,
                      color: AppColors.surfaceLight,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade300,//surfaceLight,//cardDark,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
                border: Border.all(color: AppColors.black),
              ),
              child: Column(
                children: [
                  Text(
                    item.title ?? 'Universal Galaxy',
                    style: AppTextStyles.headingSmallStyle(context).copyWith(color: AppColors.black),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.explanation ??
                        'this is a dante world where each star shines the brightest and to get the view of it only catch it through the application',
                    style: AppTextStyles.subHeadingSmallStyle(
                      context,
                    ).copyWith(color: AppColors.greyShimmerShade700),//textSecondaryLight),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.date != null
                        ? DateFormat('yyyy-MM-dd').format(item.date!)
                        : '',
                    style: AppTextStyles.subHeadingSmallStyle(
                      context,
                    ).copyWith(color: AppColors.cardDark),
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
