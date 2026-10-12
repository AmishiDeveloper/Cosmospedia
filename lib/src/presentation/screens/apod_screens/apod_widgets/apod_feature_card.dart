import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_detail_screen.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_widgets/apod_image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    imageUrl: item.displayImageUrl,//item.url ?? 'https://media.istockphoto.com/id/825593630/photo/backgrounds-photos.jpg?s=612x612&w=0&k=20&c=COZcQQQGewCtAn_D_AcAxBd0TC9TeYRZ3mhdmqQzqYQ=',
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
                        //item.explanation ?? 'Discovery details not available.',
                        item.cleanExplanation,
                        style: AppTextStyles.subHeadingSmallStyle(context).copyWith(color: AppColors.greyShimmerShade700),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      HtmlWidget(
                        (item.explanation ?? 'No description available for this cosmic event.'),
                        onTapUrl: (url) async {
                          final uri = Uri.tryParse(url);
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                            return true;
                          }
                          return false;
                        },
                        textStyle: AppTextStyles.descriptionLargeTextStyle(context).copyWith(
                          color: AppColors.surfaceLight.withOpacity(0.9),
                          height: 1.6,
                          fontSize: 15.sp,
                        ),
                        customStylesBuilder: (element) {
                          // Links ko cyan/blue underline look dein
                          if (element.localName == 'a') {
                            return {
                              'color': '#80D8FF',
                              'text-decoration': 'underline',
                              'font-weight': '600',
                            };
                          }
                          // Bold tags (jaise <strong>Explanation:</strong>) ko bright white look dein
                          if (element.localName == 'strong') {
                            return {'color': '#FFFFFF'};
                          }
                          return null;
                        },
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
