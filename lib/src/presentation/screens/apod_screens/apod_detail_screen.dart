import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ApodDetailScreen extends StatelessWidget {
  final ApodModel item; //Isme us specific photo ki saari details hain (Title, Explanation, HD URL).
  final String heroTag;

  const ApodDetailScreen({super.key, required this.item,required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hamara wahi space background use karenge consistency ke liye
      body: customBackgroundWidget(
        child: CustomScrollView( //Humne normal Column ki jagah CustomScrollView use kiya hai taaki hume Sliver effects mil sakein (jaise scrolling ke waqt image ka hide hona).
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Interactive App Bar with Image
            SliverAppBar(
              expandedHeight: 400.h, //Humne normal Column ki jagah CustomScrollView use kiya hai taaki hume Sliver effects mil sakein (jaise scrolling ke waqt image ka hide hona).
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(//eh batata hai ki jab hum scroll karenge, toh image kaise behave karegi.
                background: Hero(
                  tag: heroTag, // Same tag as Grid/Carousel/feature card
                  // child: Image.network(
                  //   item.hdurl??item.url??"",
                  //   fit: BoxFit.cover,
                  //   loadingBuilder: (context, child, loadingProgress) {
                  //     if (loadingProgress == null) return child;
                  //     //return const Center(child: CircularProgressIndicator());
                  //     // Jab tak HD load ho rahi hai, low-quality (already loaded) image dikhao
                  //     return Image.network(
                  //       item.url ?? '',
                  //       fit: BoxFit.cover,
                  //     );
                  //   },
                  //   errorBuilder: (context, error, stackTrace) => Icon(
                  //     Icons.broken_image,
                  //     size: 50.h,
                  //     color: AppColors.surfaceLight,
                  //   ),
                  // ),
                  child:CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:item.hdurl ?? item.url ?? 'https://www.shutterstock.com/image-vector/page-404-error-spaceman-flag-260nw-1484690978.jpg',
                    width: double.infinity,
                    memCacheHeight: 400,
                    memCacheWidth: 800,
                    placeholder: (context, url) =>
                        CachedNetworkImage(
                          imageUrl: item.url ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          memCacheHeight: 400,
                          memCacheWidth: 800,
                        ),
                  //       Image.network(
                  // item.url ?? '',
                  //   fit: BoxFit.cover,
                  // ),
                    errorWidget: (context, url, error) =>
                    //     Container(
                    //   color: AppColors.textPrimaryDark.withOpacity(0.3),
                    //   child:
                    //   Center(
                    //     child: Icon(
                    //       Icons.broken_image,
                    //       color: AppColors.surfaceLight,
                    //       size: 50.r,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      color: AppColors.textPrimaryDark,
                      // child: Center(
                      //   child: Icon(
                      //     Icons.broken_image,
                      //     color: AppColors.surfaceLight,
                      //     size: 40.r,
                      //   ),
                      // ),
                      child:CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:'https://media.istockphoto.com/id/692243858/photo/exoplanet-in-deep-space.jpg?s=612x612&w=0&k=20&c=KQ7B3RI8_D3qeD06RtE7IuEyiDHnLGDg-Hqp8Fe8PXU=',
                        width: double.infinity,
                        memCacheHeight: 400,
                        memCacheWidth: 800,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Content Section
            SliverToBoxAdapter( //Kyunki hum Slivers use kar rahe hain, isliye normal widgets ko SliverToBoxAdapter ke andar daalna padta hai.
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  // Niche wala section thoda dark aur glass effect wala
                  color: AppColors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    // topLeft: Radius.circular(30.r),
                    // topRight: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item.title ?? 'Celestial Wonder',
                      style: AppTextStyles.headingLargeStyle(context).copyWith(
                        color: AppColors.surfaceLight,
                        fontSize: 24.sp,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Date & Copyright (if available)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.date != null
                              ? DateFormat('dd-MM-yyyy').format(item.date!)
                              : '',
                          style: AppTextStyles.subHeadingSmallStyle(context).copyWith(
                            color: AppColors.surfaceLight.withOpacity(0.7),
                          ),
                        ),
                        if (item.copyright != null)
                          Flexible( //Flexible (Copyright): Agar kisi ka naam bahut bada hai, toh app crash nahi hogi, text agali line par aa jayega ya "..." dikhayega.
                            child: Text(
                              "© ${item.copyright!.trim()}",
                              style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                                color: AppColors.surfaceLight.withOpacity(0.5),
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Divider
                    Divider(color: AppColors.surfaceLight.withOpacity(0.2)),

                    SizedBox(height: 20.h),

                    // Explanation Header
                    Text(
                      "Explanation",
                      style: AppTextStyles.headingSmallStyle(context).copyWith(
                        color: AppColors.surfaceLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Actual Explanation Text
                    Text(
                      item.explanation ?? 'No description available for this cosmic event.',
                      textAlign: TextAlign.justify,
                      style: AppTextStyles.descriptionLargeTextStyle(context).copyWith(
                        color: AppColors.surfaceLight.withOpacity(0.9),
                        height: 1.6, // Reading ease ke liye line height. Line spacing badhayi gayi hai taaki badi explanation padhne mein aankhon par zor na pade.
                        fontSize: 15.sp,
                      ),
                    ),

                    SizedBox(height: 50.h), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}