import 'dart:ui'; // for providing blur effect
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/logic/cubits/apod_cubit/apod_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/bottom_nav_bar/navigation_bar_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/cme_cubits/cme_and_cme_analysis_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/space_news_cubit/space_news_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/user_account_cubit/user_account_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_screen.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_screen/asteroid_screen.dart';
import 'package:cosmospedia/src/presentation/screens/cme_screens/cme_and_cme_analysis_screen.dart';
import 'package:cosmospedia/src/presentation/screens/space_news_screen/space_news_screen.dart';
import 'package:cosmospedia/src/presentation/screens/user_account_screens/user_account_screen.dart';
import 'package:cosmospedia/src/presentation/widgets/show_cosmos_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationBarScreen extends StatelessWidget {
  const NavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NavigationBarCubit>();
    return PopScope(
      canPop: false, //Default back behavior ko block kar diya
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final state = cubit.state;
        if (state is NavigationBarUpdateIndexState && state.index != 0) {
          cubit.updateIndex(0);
        } else {
          //  Aapka Custom Cosmos Dialog Call ho raha hai
          bool shouldExit = false;

          await showCustomCosmosDialog(
            context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.rocket_launch, size: 70.h),
                SizedBox(height: 15.h),
                Text(
                  'Exit App',
                  style: AppTextStyles.headingMediumStyle(
                    context,
                  ).copyWith(color: AppColors.black),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Are you sure you want to exit CosmosPedia?',
                  style: AppTextStyles.descriptionMediumTextStyle(context)
                      .copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.greyShimmerShade700,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Close dialog
                      child: Text(
                        'No',
                        style: AppTextStyles.headingMediumStyle(
                          context,
                        ).copyWith(color: AppColors.textDeepPurple),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        shouldExit = true;
                        Navigator.pop(context); // Close dialog
                      },
                      child: Text(
                        'Yes',
                        style: AppTextStyles.headingMediumStyle(
                          context,
                        ).copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          if (shouldExit) {
            SystemNavigator.pop(); // App band
          }
        }
      },
      child: Scaffold(
        extendBody: true, // the page body/screen will go behind the bar
        body: BlocBuilder<NavigationBarCubit, NavigationBarState>(
          // diff screens like apod, asteroids, news,cme analysis, profile will be displayed
          buildWhen: (previous, current) =>
              current is NavigationBarUpdateIndexState,
          builder: (context, state) {
            final currentIndex = (state as NavigationBarUpdateIndexState).index;

            return IndexedStack(
              index: currentIndex,
              children: [
                //index 0
                BlocProvider(
                  create: (context) => ApodCubit(),
                  child: const ApodScreen(),
                ),

                //index 1
                BlocProvider(
                  create: (context) => AsteroidCubit(),
                  child: const AsteroidScreen(),
                ),

                // index 2
                BlocProvider(
                  create: (context) => SpaceNewsCubit(),
                  child: const SpaceNewsScreen(),
                ),

                //index 3
                BlocProvider(
                  create: (context) => CmeAndCmeAnalysisCubit(),
                  child: const CmeAndCmeAnalysisScreen(),
                ),

                //index 4
                BlocProvider(
                  create: (context) => UserAccountCubit(),
                  child: const UserAccountScreen(),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<NavigationBarCubit, NavigationBarState>(
          // our navigation bar
          buildWhen: (previous, current) =>
              current is NavigationBarUpdateIndexState,
          builder: (context, state) {
            final currentIndex = (state as NavigationBarUpdateIndexState).index;
            return Container(
              // giving extra space using height so that the icons can apper to be popping out of nav bar
              //color: Colors.green,
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              //padding: EdgeInsets.only(bottom: 20.h),
              height: 70.h, //110.h,
              child: Stack(
                // stack widget used so that ek ke upar ek widgets aa sake
                clipBehavior: Clip.none,
                alignment: AlignmentGeometry.bottomCenter,
                children: [
                  // layer 1 (bottom most) Glass Background
                  Container(
                    //margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    height: 60.h, // Asli bar ki height
                    decoration: BoxDecoration(
                      color: AppColors.textPrimaryDark.withOpacity(0.5),
                      //dark background
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        width: 1.5,
                        color: AppColors.surfaceLight.withOpacity(0.8),
                      ),
                    ),
                    child: ClipRRect(
                      // ClipRRect= Clip Rounded Rect
                      /*
                      in flutter when widgets like container or image need to have
                      round corners then only border radius is not enough. Sometimes
                      inner content like photo or blur effects gets out of the confined
                      regions. Here also we are giving blur using BackdropFilter but if
                      ClipRRect is not used then blur effect will exceed from the corners
                      by using clipRRect it confines the blur to a specific region
                      * */
                      borderRadius: BorderRadius.circular(25.r),
                      child: BackdropFilter(
                        //for blur effect
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),
                  //layer 2 WHITE CIRCLE ON WHICH ICON AND LABEL DISPLAYED
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 350),
                    // SPEED OF CIRCLE
                    // Smooth animation
                    curve: Curves.easeOutBack,
                    //easeInOut,//STYLE OF MOVEMENT OF CIRCLE with a little bounce
                    // Thoda natural movement
                    // Formula: currentIndex * (2 / (total_icons - 1)) - 1
                    alignment: Alignment(
                      currentIndex == 1
                          ? -1.0 // (leftmost) Asteroids
                          : currentIndex == 2
                          ? -0.5 // News
                          : currentIndex == 0
                          ? 0.0 // Home (Center) //currentIndex 0 hai, toh wo Alignment(0.0, -3.0)
                          : currentIndex == 3
                          ? 0.5 // CME ANALYSIS
                          : 1.0, // Profile (right most)
                      -3.0,
                    ),
                    //location of white circle. note alignment starts from left i.e -1 to right ie 1. -3.0 means circle comes above bar
                    child: FractionallySizedBox(
                      /*
                      this widget works according to the percentage
                      this is used because say there are 5 diff size screens if
                      white circle width is defined in pixels then it may happen
                      that on the large screen size the icon is greater than the width
                      of the white circle to avoid this the FractionallySizedBox widget
                      is used in this the property widthFactor: 1/5 means that it is
                      telling flutter that even if the screen size is large the white
                      circle should only occupy 1/5 = 20% of whole bar space. from this
                      the white circle appears exactly below the icon irrespective of
                      phone.
                      */
                      widthFactor: 1 / 5,
                      child: Container(
                        //alignment: Alignment.center,
                        //padding: EdgeInsets.only(bottom: 25.h),
                        height: 55.h, //60.h, // Icon se thoda bada circle
                        width: 55.h, //60.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.textDeepPurple,
                              AppColors.primaryDark,
                            ],
                          ), // Gole ka color
                          shape: BoxShape.circle, // shape of white circle
                          boxShadow: [
                            // shadow of white circle
                            BoxShadow(
                              color: Colors.black12, //white.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    //color: Colors.green,
                    height: 60.h,
                    child: Row(
                      // row containing icons and label
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // List.generate(5, (index) {
                        //   IconData icon;
                        //   switch (index) {
                        //     case 0: icon = Icons.home; break;
                        //     case 1: icon = Icons.rocket_launch; break;
                        //     case 2: icon = Icons.star; break;
                        //     case 3: icon = Icons.wb_sunny_sharp; break;
                        //     default: icon = Icons.person;
                        //   }
                        //   return _navItem(icon, index, currentIndex, cubit);
                        // }),
                        _navItem(
                          context,
                          Icons.rocket_launch_rounded,
                          'Asteroids',
                          1,
                          currentIndex,
                          cubit,
                        ),
                        _navItem(
                          context,
                          Icons.newspaper_rounded,
                          'News',
                          2,
                          currentIndex,
                          cubit,
                        ),
                        _navItem(
                          context,
                          Icons.home_rounded,
                          'APOD',
                          0,
                          currentIndex,
                          cubit,
                        ),
                        _navItem(
                          context,
                          Icons.wb_sunny_rounded,
                          'CME',
                          3,
                          currentIndex,
                          cubit,
                        ),
                        _navItem(
                          context,
                          Icons.person_rounded,
                          'Profile',
                          4,
                          currentIndex,
                          cubit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    int current,
    NavigationBarCubit cubit,
  ) {
    bool isSelected = (index == current);
    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.updateIndex(index),
        // behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          // used to send the icon up when selected
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          // MAGIC: Agar select hai toh icon 10 pixels upar chala jayega
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, isSelected ? -30.h : 0, 0),
          // this line ensures that the icon moves up if the icon is selected
          //-32.h
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSelected ? 26.sp : 24.sp,
                color: isSelected
                    ? AppColors.surfaceLight
                    : AppColors.greyShimmerShade400,
              ),
              Text(
                label,
                style: AppTextStyles.bodyTextStyle(context).copyWith(
                  color: isSelected
                      ? AppColors
                            .surfaceLight //textDeepPurple
                      : AppColors.greyShimmerShade400,
                  fontSize: isSelected ? 9.sp : 7.sp,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
