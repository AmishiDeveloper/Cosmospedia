import 'package:cached_network_image/cached_network_image.dart';
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
    // return GestureDetector(
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       AppRoute.scale(
    //         ApodDetailScreen(item: item, heroTag: item.date.toString()),
    //       ),
    //     );
    //   },
    //   child: Container(
    //     width: double.infinity,
    //     constraints: BoxConstraints(minHeight: 280.h),
    //     margin: EdgeInsets.symmetric(vertical: 10.h),
    //     decoration: BoxDecoration(
    //       color: AppColors.surfaceLight.withOpacity(0.1),
    //       borderRadius: BorderRadius.circular(20.r),
    //       //border: Border.all(color: AppColors.surfaceLight),
    //     ),
    //     clipBehavior: Clip.antiAlias,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         SizedBox(
    //           height: 200.h,
    //           width: double.infinity,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
    //             child: Hero(
    //               tag: item.date.toString(), // Unique tag for each image,
    // //child: Image.network(
    //   //item.url ??
    //     //  'https://www.shutterstock.com/image-vector/page-404-error-spaceman-flag-260nw-1484690978.jpg',
    //   // Replace with your model field
    //   //height: 200.h,
    //   //width: double.infinity,
    //   //fit: BoxFit.cover,
    //   //loadingBuilder: (context, child, loadingProgress) {
    //     //if (loadingProgress == null) return child;
    //     // //return const Center(child: CircularProgressIndicator());
    //     //return buildImagePlaceholder();
    //   //},
    //   //errorBuilder: (context, error, stackTrace) => Icon(
    //     //Icons.broken_image,
    //     //size: 50.h,
    //     //color: AppColors.surfaceLight,
    //   //),
    // //),
    //               child:CachedNetworkImage(
    //                 fit: BoxFit.cover,
    //                 imageUrl: item.url ?? 'https://media.istockphoto.com/id/2160750393/photo/a-stunning-view-of-a-spiral-galaxy-in-the-vastness-of-space.webp?b=1&s=612x612&w=0&k=20&c=j_0cYJaIWlzY3mfcUJEdZa7tFY9CQZwlAZ34kip7cbM=',
    //                 width: double.infinity,
    //                   height:200.h,
    //                 memCacheHeight: 400,
    //                 memCacheWidth: 800,
    //                 placeholder: (context, url) =>
    //                 buildImagePlaceholder(),
    //                 errorWidget: (context, url, error) =>
    //                 //     Container(
    //                 //   color: AppColors.textPrimaryDark.withOpacity(0.3),
    //                 //   child:
    //                 //   Center(
    //                 //     child: Icon(
    //                 //       Icons.broken_image,
    //                 //       color: AppColors.surfaceLight,
    //                 //       size: 50.r,
    //                 //     ),
    //                 //   ),
    //                 // ),
    //                 Container(
    //                   color: AppColors.textPrimaryDark,
    //                   child:CachedNetworkImage(
    //                     fit: BoxFit.cover,
    //                     imageUrl:'https://media.istockphoto.com/id/825593630/photo/backgrounds-photos.jpg?s=612x612&w=0&k=20&c=COZcQQQGewCtAn_D_AcAxBd0TC9TeYRZ3mhdmqQzqYQ=',
    //                     width: double.infinity,
    //                     memCacheHeight: 400,
    //                     memCacheWidth: 800,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             ),
    //           ),
    //
    //         Container(
    //           width: double.infinity,
    //           padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 6.w),
    //           decoration: BoxDecoration(
    //             color: AppColors.greyShimmerShade300,//surfaceLight,//cardDark,
    //             borderRadius: BorderRadius.only(
    //               bottomLeft: Radius.circular(20.r),
    //               bottomRight: Radius.circular(20.r),
    //             ),
    //             border: Border.all(color: AppColors.black),
    //           ),
    //           child: Column(
    //             children: [
    //               Text(
    //                 item.title ?? 'Universal Galaxy',
    //                 style: AppTextStyles.headingSmallStyle(context).copyWith(color: AppColors.black),
    //                 textAlign: TextAlign.center,
    //                 maxLines: 1,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //               Text(
    //                 item.explanation ??
    //                     'this is a dante world where each star shines the brightest and to get the view of it only catch it through the application',
    //                 style: AppTextStyles.subHeadingSmallStyle(
    //                   context,
    //                 ).copyWith(color: AppColors.greyShimmerShade700),//textSecondaryLight),
    //                 textAlign: TextAlign.center,
    //                 maxLines: 2,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //               Text(
    //                 item.date != null
    //                     ? DateFormat('yyyy-MM-dd').format(item.date!)
    //                     : '',
    //                 style: AppTextStyles.subHeadingSmallStyle(
    //                   context,
    //                 ).copyWith(color: AppColors.cardDark),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

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
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.surfaceLight.withOpacity(0.1), // Base color
        ),
        //  Clip Behavior taaki Stack ke andar ka content corners se bahar na jhaanke
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // LAYER 1: ASLI CONTENT (Image + Text)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //  IMAGE PART
                Hero(
                  tag: item.date.toString(),
                  child: CachedNetworkImage(
                    imageUrl: item.url ?? 'https://media.istockphoto.com/id/825593630/photo/backgrounds-photos.jpg?s=612x612&w=0&k=20&c=COZcQQQGewCtAn_D_AcAxBd0TC9TeYRZ3mhdmqQzqYQ=',
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => buildImagePlaceholder(),
                    errorWidget: (context, url, error) =>
                    //     Container(
                    //   height: 200.h,
                    //   color: AppColors.textPrimaryDark,
                    //   child: const Center(child: Icon(Icons.broken_image, color: Colors.white)),
                    // ),
                    Container(
                      height: 200.h,
                                        color: AppColors.textPrimaryDark,
                                        child:CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:'https://media.istockphoto.com/id/825593630/photo/backgrounds-photos.jpg?s=612x612&w=0&k=20&c=COZcQQQGewCtAn_D_AcAxBd0TC9TeYRZ3mhdmqQzqYQ=',
                                          width: double.infinity,
                                          memCacheHeight: 400,
                                          memCacheWidth: 800,
                                        ),
                                      ),
                  ),
                ),

                //  TEXT PART
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.greyShimmerShade300,
                    // Border yahan se hata diya hai taaki overlay border handle kare
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
                      SizedBox(height: 2.h),
                      Text(
                        item.explanation ?? 'Discovery details not available.',
                        style: AppTextStyles.subHeadingSmallStyle(context).copyWith(color: AppColors.greyShimmerShade700),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.date != null ? DateFormat('yyyy-MM-dd').format(item.date!) : '',
                        style: AppTextStyles.subHeadingSmallStyle(context).copyWith(color: AppColors.cardDark, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // LAYER 2: THE PERFECT BORDER OVERLAY
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.surfaceLight.withOpacity(0.5), // Subtle border
                      width: 1.5.r,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }
}
