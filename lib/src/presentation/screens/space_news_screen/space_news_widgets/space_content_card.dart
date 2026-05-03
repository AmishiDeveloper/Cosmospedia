import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:cosmospedia/src/presentation/screens/space_news_screen/space_content_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SpaceContentCard extends StatelessWidget {
  final SpaceContent content;

  const SpaceContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          AppRoute.slide(
            SpaceContentDetailScreen(content: content,),
          ),
        );
      },
      child: Card(
        color: AppColors.greyShimmerShade300,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: BorderSide(color: AppColors.surfaceLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            if (content.imageUrlValue.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                child: CachedNetworkImage(
                  imageUrl:content.imageUrlValue,
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Memory Optimization: Smooth scrolling ke liye
                  memCacheHeight: 400,
                  memCacheWidth: 800,
                  placeholder:(context, url) => SizedBox(
                    height: 200.h,
                    width: double.infinity,
                    child: buildImagePlaceholder(), // Niche wala shimmer widget
                  ),
                  errorWidget: (context, url, error) =>
                      const SizedBox.shrink(),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source & Type Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          content.newsSiteValue,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(content.typeValue),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          content.typeValue.toUpperCase(),
                          style: AppTextStyles.smallTextStyle(
                            context,
                          ).copyWith(color: AppColors.greyShimmerShade300),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    content.titleValue,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Summary
                  Text(
                    content.summaryValue,
                    style: AppTextStyles.bodyTextStyle(
                      context,
                    ).copyWith(color: AppColors.greyShimmerShade700),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8.h),

                  // Published Date
                  Text(
                    content.formattedDate,
                    style: AppTextStyles.bodyTextStyle(
                      context,
                    ).copyWith(color: AppColors.info),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'news':
        return AppColors.info;
      case 'events':
        return AppColors.orange;
      case 'launches':
        return AppColors.success;
      case 'missions':
        return AppColors.textDeepPurple;
      default:
        return AppColors.textSecondaryDark;
    }
  }

  Widget buildImagePlaceholder() {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.greyShimmerShade400,
        highlightColor: AppColors.surfaceLight.withOpacity(0.5),//greyShimmerShade100,
        duration: const Duration(milliseconds: 1000),
      ),
      // child: Container(
      //   width: double.infinity,
      //   height: 200.h, // Image ki height se match karna zaroori hai
      //   decoration: BoxDecoration(
      //     color: AppColors.greyShimmerShade400,
      //     borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      //   ),
      // ),
      child:Bone( // <--- Container ki jagah Bone use karo
        width: double.infinity,
        height: 200.h,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
    );
  }
}
