import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_event_model.dart' as events;
import 'package:cosmospedia/src/data/model/space_news_models/space_launches_model.dart' as launches;
import 'package:cosmospedia/src/data/model/space_news_models/space_news_missions_model.dart' as news_missions;
import 'package:cosmospedia/src/data/repository/space_dev_repo/space_news_repo/space_news_repository.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SpaceContentDetailScreen extends StatelessWidget {
  final SpaceContent content;

  const SpaceContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: customBackgroundWidget(
        child: CustomScrollView(
          slivers: [
            // 1. Header with Image & Back Button
            SliverAppBar(
              expandedHeight: 350.h,
              pinned: true,
              backgroundColor: AppColors.primaryDark,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: content.idValue,
                  child: CachedNetworkImage(
                    imageUrl: content.imageUrlValue,
                    fit: BoxFit.cover,
                    // Shimmer ya loader jab tak image load ho rahi ho
                    placeholder: (context, url) => _buildImagePlaceholder(),
                    // Error handling (Wahi jo aapne pehle rakha tha)
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.greyShimmer,
                      child: const Icon(
                          Icons.broken_image,
                          color: AppColors.greyShimmer,
                      ),
                    ),
                  )
                ),
              ),
            ),

            // 2. Content Body
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge & Source
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBadge(context),

                      ],
                    ),
                    SizedBox(height: 15.h),

                    // Title
                    Center(child: Text(content.titleValue, style: AppTextStyles.headingMediumStyle(context),textAlign: TextAlign.center,)),
                    SizedBox(height: 10.h),

                    Text("Source: ${content.newsSiteValue}", style: AppTextStyles.descriptionLargeTextStyle(context).copyWith(color: AppColors.greyShimmerShade300),),

                    SizedBox(height: 10.h),
                    // Date
                    Text("Published: ${content.formattedDate}",
                        style: AppTextStyles.descriptionLargeTextStyle(context).copyWith(color: AppColors.greyShimmerShade300),),

                    const Divider(height: 40,thickness: 2,),

                    // --- EXTRA DETAILS (Type Specific) ---
                    _buildExtraSection(context),

                    // Summary / Description
                    Text("Overview", style: AppTextStyles.subHeadingLargeStyle(context)),
                    SizedBox(height: 10.h),
                    Text(
                      content.summaryValue,
                      style: AppTextStyles.bodyTextStyle(context).copyWith(height: 1.5),
                      softWrap: true,
                    ),

                    SizedBox(height: 100.h), // Bottom Spacing
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button for News Link
      floatingActionButton: content.typeValue == 'news'
          ? FloatingActionButton.extended(
        onPressed: () => _openUrl(context),
        label: Text("Read More",style: AppTextStyles.bodyTextStyle(context).copyWith(fontWeight: FontWeight.bold),),
        icon: const Icon(Icons.open_in_new,color: AppColors.surfaceLight,),
        backgroundColor: AppColors.primaryDark,
      )
          : null,
    );
  }

  Widget _buildExtraSection(BuildContext context) {
    // 1. Case for Launches
    if (content is launches.Result) {
      final data = content as launches.Result;
      return Column(
        children: [
          // _extraInfoTile(
          //     context, icon:Icons.info_outline, title:"Launch Status",
          //     subtitle: "${data.status?.name?.name ?? 'N/A'}\n${data.status?.abbrev ?? 'N/A'}"
          // ),

          if (data.failreason != null && data.failreason!.isNotEmpty)
            _extraInfoTile(
                context, icon:Icons.error_outline, title: "Failure Reason", subtitle:data.failreason!, isError: true,
            ),

          _extraInfoTile(
              context, icon:Icons.rocket_launch, title: "Mission Info",
              subtitle: "Type: ${data.mission?.name ?? 'N/A'}"),

          // _extraInfoTile(context, icon:Icons.place, title: "Launch Site",
          //     subtitle: "Pad: ${data.pad?.name?.name ?? 'N/A'}\nCountry: ${data.pad?.location?.name?.name ?? 'Unknown'}"),

    // _extraInfoTile(
    // context,
    // icon: Icons.rocket_launch,
    // title: "Rocket & Status",
    // subtitle: "Status: ${data.status?.name?.name ?? 'Unknown'}\nPad: ${data.pad?.name?.name ?? 'N/A'}",
    // ),
        ],
      );

    }

    // 2. Case for Events
    if (content is events.Result) {
      final data = content as events.Result;
      return _extraInfoTile(
        context,
        icon: Icons.location_on,
        title: "Event Location",
        subtitle: data.location?.name ?? "Global / Remote",
      );
    }

    if (content is MissionWrapper) {
      final originalData = (content as MissionWrapper).original;
      return _extraInfoTile(
        context,
        icon: Icons.rocket_outlined,
        title: "Mission Category",
        subtitle: "Source: ${originalData.newsSite ?? 'Space Agency'}",
      );
    }

    return const SizedBox.shrink();
  }

  Widget _extraInfoTile(BuildContext context, {required IconData icon, required String title, required String subtitle, bool isError = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 25.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: isError ? Colors.red.withOpacity(0.1) : AppColors.surfaceLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceLight)
      ),
      child: Row(
        children: [
          Icon(icon, color: isError ? AppColors.error :AppColors.primaryDark, size: 30.h),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.descriptionLargeTextStyle(context).copyWith(fontWeight: FontWeight.bold,color: AppColors.black),),
                SizedBox(height: 5.h),
                Text(subtitle, style:  AppTextStyles.descriptionSmallTextStyle(context).copyWith(fontWeight: FontWeight.bold,color: AppColors.greyShimmerShade800),),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getCategoryColor(content.typeValue),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(content.typeValue.toUpperCase(), style: AppTextStyles.smallTextStyle(context),),
    );
  }

  Future<void> _openUrl(BuildContext context) async {
    // Note: Humein News model se URL nikalna hoga casting karke
    if (content is news_missions.Result) {
      final url = (content as news_missions.Result).url;
      if (url != null && url.isNotEmpty) {
        final Uri uri = Uri.parse(url);
        try {
          // canLaunchUrl check karna zaroori hai
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication, // Ye Android 11+ ke liye best hai
            );
          } else {
            showCustomSnackBar(context: context, message: "Could not launch article");
          }
        } catch (e) {
          showCustomSnackBar(context: context, message: "Error: $e");
        }
      }
    }
  }

  Widget _buildImagePlaceholder() {
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
}