import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_feed_model.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_detail_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen/asteroid_physical_properties_screeen.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen/asteroid_timeline_view_screen.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//for sticking the tabs at the top but scrolling the content above it

// NestedScrollView: Yeh do hisson mein banti hai.

// headerSliverBuilder: Yahan hum saare apne screen ki widgets rakhte hain .
// SliverToBoxAdapter: yeh widget use karke hum iske andar vo widgets dete h
// jo scroll hone par upar gayab ho jayenge (Aapka Name/ID wala container).

// SliverPersistentHeader: Iska use hum TabBar ke liye karte hain taaki jab
// user scroll kare, toh Tabs upar jakar "Stick" (chipak) jayein aur neeche
// ka content scroll hota rahe.

// body: Yahan aapka TabBarView aayega.

class AsteroidDetailScreen extends StatefulWidget {
  final String asteroidId;
  final String name;
  final bool isHazardous;
  final NearEarthObject? asteroid;

  const AsteroidDetailScreen({
    super.key,
    required this.asteroidId,
    required this.name,
    required this.isHazardous,
    this.asteroid,
  });

  @override
  State<AsteroidDetailScreen> createState() {
    return _AsteroidDetailScreenState();
  }
}

class _AsteroidDetailScreenState extends State<AsteroidDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Widget build hone ke turant baad chalega
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //final int asteroidId = int.tryParse(widget.asteroidId) ?? 0;

      if (context.mounted) {
        context.read<AsteroidDetailCubit>().fetchAsteroidLookupData(
          asteroidId: widget.asteroidId,//asteroidId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 1. for 2 tabs chahiye
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: CustomAppBar(title: 'Asteroid Insights'),
          ),
        ),
        body: customBackgroundWidget(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: NestedScrollView(
                //headerSliverBuilder:Yahan hum saare apne screen ki widgets rakhte hain .
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    //sliverToBoxAdapter: yeh widget use karke hum iske andar vo widgets dete h
                    // jo scroll hone par upar gayab ho jayenge (Aapka Name/ID wala container).
                    SliverToBoxAdapter(child: SizedBox(height: 10.h)),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 15.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greyShimmerShade100.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: AppColors.textPrimaryDark),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // name and id of asteroid
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: AppTextStyles.headingMediumStyle(
                                    context,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),

                                SizedBox(height: 5.h),

                                Text(
                                  'Asteroid ID: ${widget.asteroidId}',
                                  style:
                                      AppTextStyles.descriptionLargeTextStyle(
                                        context,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),

                            // SizedBox(width: 15.w),

                            // safe/ hazardous container
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: widget.isHazardous
                                    ? AppColors.error
                                    : AppColors.success,
                                borderRadius: BorderRadius.circular(15.r),
                                // border: Border.all(
                                //   color: AppColors.textPrimaryDark,
                                // ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (widget.isHazardous
                                                ? AppColors.error
                                                : AppColors.success)
                                            .withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                //Essential for Slivers
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.isHazardous
                                        ? Icons.warning_amber_rounded
                                        : Icons.verified_rounded,
                                    size: 35.h,
                                    color: AppColors.surfaceLight,
                                  ),

                                  Text(
                                    widget.isHazardous ? 'Dangerous' : 'Safe',
                                    style:
                                        AppTextStyles.descriptionLargeTextStyle(
                                          context,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                    // SliverPersistentHeader: Iska use hum TabBar ke liye karte hain taaki jab
                    // user scroll kare, toh Tabs upar jakar "Stick" (chipak) jayein aur neeche
                    // ka content scroll hota rahe.
                    // 2. Tab Bar Design
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.greyShimmerShade600,
                            borderRadius: BorderRadius.circular(18.r),
                            //border: Border.all(color: AppColors.textPrimaryDark),
                          ),
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            // 3. Indicator poore tab ko cover karega
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.r),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryDark,
                                  AppColors.textDeepPurple,
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.textPrimaryDark,
                              ), // Selected tab color
                            ),
                            labelStyle:
                                AppTextStyles.subHeadingLargeStyle(
                                  context,
                                ).copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                            unselectedLabelColor: AppColors.greyShimmerShade50,
                            dividerColor: Colors.transparent,
                            // 4. Bottom line hatane ke liye
                            tabs: const [
                              Tab(text: "Core Characteristics"),
                              Tab(text: "Timeline View"),
                            ],
                          ),
                        ),
                        height: 50.h,
                      ),
                    ),
                  ]; // children of header sliver builder
                },
                //headerSliverBuilder
                //body of nested scrollview here the screens that have to be scrolled comes
                body:
                    // 5. Tab View (Content)
                    // ClipRect(
                    //   clipper: _TopGapClipper(gap: 15.h),
                    //   child:
                    // BlocBuilder<AsteroidDetailCubit, AsteroidDetailState>(
                    //   builder: (context, state) {
                    //     if (state is AsteroidDetailLoadingState) {
                    //       return const Center(child: CircularProgressIndicator()
                    //       );
                    //     }
                    //     else if (state is AsteroidDetailErrorState) {
                    //       return Center(child: Text(state.errorMessage));
                    //     }
                    //     else if (state is AsteroidDetailSuccessState) {
                    //       return
                    TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        widget.asteroid != null
                            ? AsteroidPhysicalPropertiesScreen(
                          asteroid: widget.asteroid!,
                          //lookupModel: state.lookupModel,
                        ):const Center(child: Text("Data Missing")),
                        // Tab 1 Content

                        BlocBuilder<AsteroidDetailCubit, AsteroidDetailState>(
                          builder: (context, state) {
                            if (state is AsteroidDetailLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is AsteroidDetailErrorState) {
                              return Center(child: Text(state.errorMessage));
                            } else if (state is AsteroidDetailSuccessState) {
                              return AsteroidTimelineViewScreen(
                                lookupModel: state.lookupModel,
                              );
                              // Tab 2 Content
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                //}
                //return const SizedBox();;
                //},
                //),
                //),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Sticky Header Delegate ---
// Yeh class zaroori hai TabBar ko fix karne ke liye
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverAppBarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height; //+ 15.h; // TabBar ki minimum height
  @override
  double get maxExtent => height; //+15.h; // TabBar ki maximum height

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Sizedbox use karein taaki child poori height le sake
    return SizedBox.expand(child: child);
    // Column(
    //   children: [
    //     // 1. Aapka TabBar
    //     SizedBox(height: height, child: child),
    //
    //     // 2. MAGIC BOUNDARY (Mask)
    //     // Iska color wahi rakhein jo aapki screen ke background ka hai
    //     Container(
    //       height: 15.h,
    //       // Agar background gradient hai toh color: Colors.transparent use karein
    //       // Ya phir exact background color dein taaki data yahan "chup" jaye
    //       color: Colors.transparent,
    //     ),
    //   ],
    // );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

// class _TopGapClipper extends CustomClipper<Rect> {
//   final double gap;
//
//   _TopGapClipper({required this.gap});
//
//   @override
//   Rect getClip(Size size) {
//     // Yeh line batati hai ki data 'gap' distance ke baad se dikhna shuru hoga
//     // Aur top wala hissa (0 se gap tak) cut ho jayega
//     return Rect.fromLTRB(0, gap, size.width, size.height);
//   }
//
//   @override
//   bool shouldRebuild(_TopGapClipper oldClipper) => oldClipper.gap != gap;
//
//   @override
//   bool shouldReclip(covariant _TopGapClipper oldClipper) {
//     // Agar gap badal jaye, tabhi dubara re-clip karo
//     return oldClipper.gap != gap;
//   }
//
// }
