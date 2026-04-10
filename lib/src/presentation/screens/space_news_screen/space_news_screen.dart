import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/presentation/screens/space_news_screen/space_discoveries_list_screen.dart';
import 'package:cosmospedia/src/presentation/screens/space_news_screen/space_news_widgets/category_chips_bar_widget.dart';
import 'package:cosmospedia/src/presentation/screens/space_news_screen/space_news_widgets/space_content_card.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_error_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cosmospedia/src/logic/cubits/space_news_cubit/space_news_cubit.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';

class SpaceNewsScreen extends StatelessWidget {
  const SpaceNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: customBackgroundWidget(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomAppBar(title: 'Cosmos News'),

              Expanded(
                child: BlocConsumer<SpaceNewsCubit, SpaceNewsState>(
                  listener: (context, state) {
                    if (state is SpaceNewsErrorState) {
                      showCustomSnackBar(
                        context: context,
                        message: state.errorMessage,
                      );
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<SpaceNewsCubit>();
                    return Column(
                      children: [
                        //1. Calendar aur Reset Button Header
                        _buildDateContainer(context, cubit, state),

                        // 2. Chips Section (Category Chips)
                        const CategoryChipsBarWidget(),

                        // 3. Dynamic Content Area
                        Expanded(
                          child: _buildMainContent(context, state, cubit),
                        ),

                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- LOGIC: Loading, Success, ya Empty State decide karega ---
  Widget _buildMainContent(
    BuildContext context,
    SpaceNewsState state,
    SpaceNewsCubit cubit,
  ) {
    if (state is SpaceNewsLoadingState || state is SpaceNewsInitial) {
      return _buildLoadingShimmer();
    }

    if (state is SpaceNewsSuccessState) {
      if (state.combinedFeed.isEmpty) {
        return _buildEmptyState(context, state.activeDate);
      }
      return _buildGroupedList(context, state);
    }

    if (state is SpaceNewsErrorState) {
      return CustomErrorWidget(
        errorMessage: state.errorMessage,
        onRetry: () => cubit.resetToToday(),
      );
    }
    return const SizedBox.shrink();
  }

  // --- UI: Loading Shimmer (Skeletonizer) ---
  Widget _buildLoadingShimmer() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        //padding: EdgeInsets.symmetric(vertical: 10.h),
        physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 10.h),

              // --- UPCOMING SECTION SHIMMER ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Bone.text(words: 2),
                    SizedBox(width: 10.w),
                    Bone.icon(size: 20.h),
                    Spacer(),
                    Bone.text(words: 2),
                  ],
                ),
              ),

              // Horizontal Slider Shimmer (Fixed Height)
              SizedBox(
                height: 420.h,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index2) {
                    return shimmerCard(width: MediaQuery.of(context).size.width * 0.85);
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Bone.text(words: 2),
                    SizedBox(width: 10.w),
                    Bone.icon(size: 20.h),
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              // Vertical List Shimmer (shrinkWrap use karna zaroori hai)
              ListView.builder(
                shrinkWrap: true, // <--- Isse ye Column ke andar fit ho jayega
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            Expanded(child: Divider(height: 2.h)),
                            SizedBox(width: 10.w),
                            Bone.text(words: 2),
                            SizedBox(width: 10.w),
                            Expanded(child: Divider(height: 2.h)),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),

                      shimmerCard(),

                    ],
                  );
                },
              ),
            ],
          ),
      ),
    );
  }

  Widget shimmerCard({double? width}) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Card(
        color: AppColors.greyShimmerShade600,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: BorderSide(color: AppColors.surfaceLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Bone(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.r),
              ),
              height: 200.h,
              width: double.infinity,
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
                      Bone.text(words: 2),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greyShimmerShade400,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Bone.text(words: 1),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Title
                  Bone.text(words: 3),

                  SizedBox(height: 12.h),

                  // Summary
                  Bone.multiText(lines: 3),

                  SizedBox(height: 12.h),

                  // Published Date
                  Bone.text(words: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI: Empty State (No Data Found) ---
  Widget _buildEmptyState(BuildContext context, DateTime date) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80.h,
            color: AppColors.greyShimmer,
          ),
          SizedBox(height: 16.h),
          Text(
            "No data available for this date.",
            style: AppTextStyles.bodyTextStyle(context),
          ),
          TextButton(
            onPressed: () => context.read<SpaceNewsCubit>().resetToToday(),
            child: const Text(
              "Go to Today",
              style: TextStyle(color: AppColors.yellow),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI: Upcoming Slider aur Recent Grouped List ---
  Widget _buildGroupedList(BuildContext context, SpaceNewsSuccessState state) {
    final now = DateTime.now();
    final feed = state.combinedFeed;

    // 1. Total Future Data (Bina 'take' ke, taaki length check kar sakein) // upcoming slider
    final  List<SpaceContent> allUpcomingItems = state.isToday
        ? feed.where((item) => item.publishedAtDate.isAfter(now)).toList()
        : <SpaceContent>[];

    // 2. Slider ke liye sirf top 16
    final List<SpaceContent> sliderItems;
    if (allUpcomingItems.length >= 16){
      sliderItems = allUpcomingItems.take(16).toList();
    }
    else{
      sliderItems = allUpcomingItems.toList();
    }

    final recentItems = state.isToday
        ? feed.where((item) => !item.publishedAtDate.isAfter(now)).toList()
        : feed; // Calendar selected hai toh poora data list mein aayega

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [

        // SECTION: UPCOMING SLIDER
        if (sliderItems.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            "Upcoming Highlights",
            showViewMore: allUpcomingItems.length >= 16,
            onViewMore: () {
              Navigator.push(
                  context,
                  AppRoute.slide(
                  SpaceDiscoveriesListScreen(
                  title: "Upcoming Highlights",
                  items: allUpcomingItems,
                ),
              ),
              );
            },
          ),
          SizedBox(
            height: 420.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              //padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: sliderItems.length,
              itemBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: SpaceContentCard(content: sliderItems[index]),
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],

        // SECTION: RECENT LIST (Date-wise Grouped)
        // 1. Heading Hamesha Dikhao (Agar Upcoming khali nahi hai toh ya agar data hai)
        if (recentItems.isNotEmpty || allUpcomingItems.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            state.isToday
                ? "Recent Highlights"
                : "Discoveries on ${state.activeDate.toString().split(' ')[0]}",
            showViewMore: false,
          ),

          // 2. Ab check karo data hai ya nahi
          if (recentItems.isNotEmpty) ...[
                // Naya grouped list function jo 'View More' handle karega per date
                // Data hai toh list dikhao
                ..._buildRecentVerticalList(context, recentItems),
                SizedBox(height: 50.h), // Bottom padding
          ]
          else ...[
                //_buildNoRecentDataWidget(context),
            // Data nahi hai toh heading ke neeche ye message dikhao
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Center(
                    child: Column(
                      children: [
                        Divider(
                          color: AppColors.greyShimmer,
                          height: 1,
                          thickness: 2,
                        ),
                        SizedBox(height: 20.h),
                        Icon(
                          Icons.rocket_rounded,
                          color: AppColors.greyShimmer,
                          size: 40.h,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "No recent data available for this category.",
                          style: AppTextStyles.descriptionSmallTextStyle(
                            context,
                          ).copyWith(color: AppColors.greyShimmer),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ]
        // 3. Agar poori screen hi khali hai (Upcoming + Recent dono nahi hain)
        else ...[
          _buildEmptyState(context, state.activeDate),
        ],
      ], // listview children
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    required bool showViewMore,
        VoidCallback? onViewMore
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(title, style: AppTextStyles.headingSmallStyle(context)),
              SizedBox(width: 8.w),
              Icon(
                Icons.auto_awesome_rounded,
                size: 18.h,
                color: AppColors.yellow,
              ),
            ],
          ),
          if (showViewMore)
            GestureDetector(
              onTap: onViewMore,
              child: Text(
                "View More",
                style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                  //color: AppColors.info,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- RECENT LIST WITH DATE-WISE VIEW MORE ---
  // Recent items ko group karne wala function
  List<Widget> _buildRecentVerticalList(
    BuildContext context,
    List<SpaceContent> recentItems,
  ) {
    final groupedData = <String, List<SpaceContent>>{};
    for (var item in recentItems) {
      final dateKey = item.formattedDate;
      groupedData.putIfAbsent(dateKey, () => []).add(item);
    }

    final List<Widget> listWidgets = [];
    groupedData.forEach((date, items) {
      // Date Header
      listWidgets.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  height: 2.h,
                  color: AppColors.greyShimmerShade400,
                ),
              ),

              SizedBox(width: 10.w),
              // Expanded(
              //   child:
              Center(
                child: Text(
                  date,
                  style: AppTextStyles.headingSmallStyle(
                    context,
                  ).copyWith(color: AppColors.greyShimmer),
                ),
              ),

              // ),
              SizedBox(width: 10.w),

              Expanded(
                child: Divider(
                  height: 2.h,
                  color: AppColors.greyShimmerShade400,
                ),
              ),
            ],
          ),
        ),
      );

      // LOGIC: Sirf pehle 10 items dikhao
      final displayItems = items.take(10).toList();

      // Cards for that date
      for (var item in displayItems) {  //items
        listWidgets.add(SpaceContentCard(content: item));
      }


        // LOGIC: Agar us date mein 10 se zyada data hai, toh "View More" button
        if (items.length >= 10) {
      listWidgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(context, AppRoute.slide(
                  SpaceDiscoveriesListScreen(
                    title: "Discoveries: $date",
                    items: items, // Poora data list screen pe bhej rahe hain
                  ),
                ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16,color: AppColors.surfaceLight,),
              label: Text("View all $date", style:AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                //color: AppColors.info,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
          ),
        ),
      );
    }
  }
  );
    return listWidgets;
  }

  Widget _buildDateContainer(
    BuildContext context,
    SpaceNewsCubit cubit,
    SpaceNewsState state,
  ) {
    bool isToday = true;
    if (state is SpaceNewsSuccessState) isToday = state.isToday;

    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Space Discoveries',
            style: AppTextStyles.subHeadingLargeStyle(
              context,
            ).copyWith(fontSize: 20.sp),
          ),

          const Spacer(),

          // RESET BUTTON: Sirf tab dikhega jab user Today par na ho
          if (!isToday)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryDark,
              ),
              child: IconButton(
                onPressed: () => cubit.resetToToday(),
                icon: Icon(
                  Icons.history_rounded,
                  color: AppColors.yellow,
                  size: 24.h,
                ),
                tooltip: "Back to Today",
              ),
            ),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryDark,
            ),
            child: IconButton(
              onPressed: () {
                cubit.pickDate(context);
              },
              icon: Icon(
                Icons.calendar_month_rounded,
                size: 24.h,
                color: AppColors.surfaceLight,
              ),
            ),
          ),

          // SizedBox(width: 10.w),
          //
          // Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: AppColors.primaryDark,
          //   ),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.filter_alt_rounded,
          //       size: 24.h,
          //       color: AppColors.surfaceLight,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// old logic
// Widget _buildGroupedList(
//   BuildContext context,
//   List<SpaceContent> feed,
//   String category,
// ) {
//   final now = DateTime.now();
//
//   // 1. Data ko Split karo: Upcoming (Future) vs Recent (Today/Past)
//   final upcomingItems = feed
//       .where((item) => item.publishedAtDate.isAfter(now))
//       .take(16)
//       .toList();
//   final recentItems = feed
//       .where((item) => !item.publishedAtDate.isAfter(now))
//       .toList();
//
//   return ListView(
//     children: [
//       // --- SECTION 1: UPCOMING (Horizontal Slider) ---
//       if (upcomingItems.isNotEmpty) ...[
//         Padding(
//           padding: EdgeInsets.only(left: 20.w, right: 20, bottom: 10.h),
//           child: Row(
//             children: [
//               Text(
//                 "Upcoming Highlights",
//                 style: AppTextStyles.headingSmallStyle(context),
//               ),
//
//               SizedBox(width: 10.w),
//
//               Icon(
//                 Icons.auto_awesome_rounded,
//                 size: 20.h,
//                 color: AppColors.yellow,
//               ),
//             ],
//           ),
//         ),
//
//         // Horizontal List ke liye SizedBox zaroori hai
//         SizedBox(
//           height: 420.h, // Card ki height ke according adjust karein
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: upcomingItems.length,
//             itemBuilder: (context, index) {
//               return SizedBox(
//                 width:
//                     MediaQuery.of(context).size.width *
//                     0.85, // 85% width taaki agla card thoda dikhe
//                 child: SpaceContentCard(content: upcomingItems[index]),
//               );
//             },
//           ),
//         ),
//       ],
//
//       // --- SECTION 2: RECENT HIGHLIGHTS (Vertical List) ---
//       Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//         child: Row(
//           children: [
//             Text(
//               "Recent Highlights",
//               style: AppTextStyles.headingSmallStyle(context),
//             ),
//
//             SizedBox(width: 10.w),
//
//             Icon(
//               Icons.auto_awesome_rounded,
//               size: 20.h,
//               color: AppColors.yellow,
//             ),
//           ],
//         ),
//       ),
//
//       // Recent items ko date ke hisaab se group karke dikhao
//       // Hum yahan normal mapping use karenge taaki ListView ke andar ListView crash na ho
//       ..._buildRecentVerticalList(context, recentItems),
//     ],
//   );
// }

//OLD GROUPED LIST
//
// // 🛠️ Date-wise Grouping Logic (UI Helper)
// Widget _buildGroupedList(List<SpaceContent> feed, String category) {
//
//   print("UI DEBUG: Total Items received in UI = ${feed.length}");
//   for (var i in feed.take(10)) { // Pehle 10 items ka type check karne ke liye
//     print("UI DEBUG: Item Type = ${i.typeValue} | Date = ${i.publishedAtDate}");
//   }
//   // Ye print bata dega ki puri list mein launches hain ya nahi
//   final launchesInList = feed.where((item) => item.typeValue == 'launches').length;
//   final eventsInList = feed.where((item) => item.typeValue == 'events').length;
//
//   print("UI DEBUG: Total Items = ${feed.length}");
//   print("UI DEBUG: Launches Found = $launchesInList");
//   print("UI DEBUG: Events Found = $eventsInList");
//
//
//   // 1. Data ko date ke hisaab se group karna (Map<String, List>)
//   final groupedData = <String, List<SpaceContent>>{};
//   for (var item in feed) {
//     final dateKey = item.formattedDate; // Interface se formatted date li
//     groupedData.putIfAbsent(dateKey, () => []).add(item);
//   }
//
//   final sortedDates = groupedData.keys.toList();
//
//   return ListView.builder(
//     // Performance ke liye physics add kar sakte ho
//     physics: const BouncingScrollPhysics(),
//     itemCount: sortedDates.length,
//     itemBuilder: (context, index) {
//       final date = sortedDates[index];
//       final items = groupedData[date]!;
//
//       return StickyHeader(
//         header: Container(
//           height: 40.0,
//           color: Theme.of(context).scaffoldBackgroundColor,
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           alignment: Alignment.centerLeft,
//           child: Text(
//             date,
//             style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
//           ),
//         ),
//         content: Column(
//           children: items.map((item) {
//             // Yahan check karenge ki agar 'All' chip hai toh limit lagani hai ya nahi
//             return SpaceContentCard(content: item);
//           }).toList(),
//         ),
//       );
//old logic
// 2. Main Content Area (Cubit Driven)
// Expanded(
//   child: BlocBuilder<SpaceNewsCubit, SpaceNewsState>(
//     builder: (context, state) {
//       final cubit = context.read<SpaceNewsCubit>();
//       if (state is SpaceNewsLoadingState ||
//           state is SpaceNewsInitial) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       } else if (state is SpaceNewsSuccessState) {
//         return _buildGroupedList(
//           context,
//           state.combinedFeed,
//           state.activeCategory,
//         );
//       } else if (state is SpaceNewsErrorState) {
//         return CustomErrorWidget(
//           errorMessage: 'state.errorMessage',
//           onRetry: () {
//             cubit.getCombinedFeed();
//           },
//         );
//       }
//       return const Center(
//         child: Text("Start exploring space..."),
//       );
//     },
//   ),
// ),
//     },
//   );
// }
