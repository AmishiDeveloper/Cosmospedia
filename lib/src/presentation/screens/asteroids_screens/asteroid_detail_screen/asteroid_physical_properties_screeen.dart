import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_feed_model.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_lookup_model.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_detail_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/animated_orbit_widget.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_radar_chart.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_size_comparison.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/orbit_loading_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AsteroidPhysicalPropertiesScreen extends StatefulWidget {
  final NearEarthObject asteroid;

  const AsteroidPhysicalPropertiesScreen({
    super.key,
    required this.asteroid,
  });

  @override
  State<AsteroidPhysicalPropertiesScreen> createState() =>
      _AsteroidPhysicalPropertiesScreenState();
}

class _AsteroidPhysicalPropertiesScreenState
    extends State<AsteroidPhysicalPropertiesScreen> {
  @override
  Widget build(BuildContext context) {

    // 1. Create a local variable that is safely nullable
    final estimatedDiameter = widget.asteroid.estimatedDiameter;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: 40.h,
        left: 10.w,
        right: 10.w,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.h),

          AsteroidSizeComparison(asteroid: widget.asteroid),

          //_buildEnhancedSizeComparison(context, widget.asteroid),
          SizedBox(height: 20.h),

          (estimatedDiameter != null)
              ? SizedBox(
                  height: 550.h,
                  child: AsteroidRadarChart(
                    diameter: estimatedDiameter,
                  ),
                )
              :
                // Graceful handling if data is missing
                SizedBox(
                  height: 550.h,
                  child: Center(
                    child: Text(
                      "Diameter data not available for this object",
                      style: AppTextStyles.headingSmallStyle(context),
                    ),
                  ),
                ),

          SizedBox(height: 20.h),


          BlocConsumer<AsteroidDetailCubit, AsteroidDetailState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            buildWhen: (previous, current) =>
                current is AsteroidDetailLoadingState ||
                current is AsteroidDetailErrorState ||
                current is AsteroidDetailSuccessState,
            builder: (context, state) {
              if (state is AsteroidDetailLoadingState) {
                return orbitLoadingWidget();
              } else if (state is AsteroidDetailErrorState) {
                return CustomErrorWidget(
                  errorMessage: state.errorMessage,
                  onRetry: () {
                    context.read<AsteroidDetailCubit>().fetchAsteroidLookupData(
                      asteroidId: widget.asteroid.id ?? "0",
                    ); // int.tryParse(widget.asteroid.id??'0')??0
                  },
                );
              } else if (state is AsteroidDetailSuccessState) {
                return AnimatedOrbitWidget(
                  eccentricity:
                      double.tryParse(
                        state.lookupModel.orbitalData?.eccentricity ?? '0',
                      ) ??
                      0.0,
                  semiMajorAxis:
                      double.tryParse(
                        state.lookupModel.orbitalData?.semiMajorAxis ?? '0',
                      ) ??
                      0.0,
                  isHazardous:
                      state.lookupModel.isPotentiallyHazardousAsteroid ?? false,
                  asteroidName: state.lookupModel.name ?? "Unknown",
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildEnhancedSizeComparison(BuildContext context, dynamic asteroid) {
  //   // 1. Data Parsing (Safely handling values)
  //   final minSize =
  //       asteroid.estimatedDiameter.kilometers.estimatedDiameterMin ?? 0.0;
  //   final maxSize =
  //       asteroid.estimatedDiameter.kilometers.estimatedDiameterMax ?? 0.0;
  //   final avgSize = (minSize + maxSize) / 2;
  //
  //   // Reference constants (in km)
  //   const double footballField = 0.11;
  //   const double eiffelTower = 0.33;
  //   const double empireState = 0.44;
  //   const double burjKhalifa = 0.828;
  //
  //   final comparisons = [
  //     {
  //       'name': 'Football Field',
  //       'size': footballField,
  //       'color': AppColors.infoDark,
  //       'icon': Icons.sports_football,
  //     },
  //     {
  //       'name': 'Eiffel Tower',
  //       'size': eiffelTower,
  //       'color': AppColors.success,//
  //          // AppColors.primaryDark,
  //       'icon': Icons.location_city,
  //     },
  //     {
  //       'name': 'Empire State',
  //       'size': empireState,
  //       'color': //AppColors.orangeShade800,
  //           Colors.cyan,
  //       'icon': Icons.apartment,
  //     },
  //     {
  //       'name': 'Burj Khalifa',
  //       'size': burjKhalifa,
  //       'color': AppColors.orangeShade800,//textDeepPurple, //Colors.indigo,
  //       'icon': Icons.business,
  //     },
  //   ];

  // return Container(
  //   padding: EdgeInsets.all(16.r),
  //   decoration: BoxDecoration(
  //     color: AppColors.greyShimmerShade900.withOpacity(0.4),//drawerHeaderGradient.withOpacity(0.4),
  //     //splashBlueBackground, drawerHeader
  //     borderRadius: BorderRadius.circular(20.r),
  //     border: Border.all(color: AppColors.greyShimmerShade400),
  //   ),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // --- Header ---
  //       Row(
  //         children: [
  //           Icon(
  //             Icons.compare_arrows,
  //             color: AppColors.surfaceLight,
  //             size: 20.sp,
  //           ),
  //           SizedBox(width: 8.w),
  //           Text(
  //             'Size Comparison',
  //             style: AppTextStyles.headingSmallStyle(context),
  //           ),
  //         ],
  //       ),
  //       Divider(color: AppColors.greyShimmerShade100, height: 25.h),
  //
  //       // --- Central Asteroid Visual ---
  //       Center(
  //         child: Container(
  //           width: 100.w,
  //           height: 100.w,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             gradient: RadialGradient(
  //               colors: [
  //                 AppColors.greyShimmerShade400,
  //                 AppColors.greyShimmerShade800,
  //               ],
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: AppColors.infoDark.withOpacity(0.3),
  //                 blurRadius: 20.r,
  //                 spreadRadius: 5.r,
  //               ),
  //             ],
  //           ),
  //           child: Center(
  //             child: Text(
  //               '${avgSize.toStringAsFixed(2)}\nkm',
  //               textAlign: TextAlign.center,
  //               style: AppTextStyles.headingSmallStyle(
  //                 context,
  //               ).copyWith(fontSize: 16.sp),
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 20.h),
  //
  //       // --- Comparison Bars ---
  //       ...comparisons.map((item) {
  //         final double objectSize = item['size'] as double;
  //         final ratio = avgSize / objectSize;
  //
  //         double asteroidWidthFactor;
  //         double buildingWidthFactor;
  //         String comparisonText;
  //
  //         if (avgSize >= objectSize) {
  //           // Case 1: Asteroid bada hai
  //           asteroidWidthFactor = 1.0;
  //           buildingWidthFactor = (objectSize / avgSize).clamp(0.1, 1.0);
  //           comparisonText = '${ratio.toStringAsFixed(1)}x\nlarger';
  //         } else {
  //           // Case 2: Building badi hai
  //           buildingWidthFactor = 1.0;
  //           asteroidWidthFactor = (avgSize / objectSize).clamp(0.1, 1.0);
  //           comparisonText = '${(1 / ratio).toStringAsFixed(1)}x\nsmaller';
  //         }
  //
  //         return Padding(
  //           padding: EdgeInsets.symmetric(vertical: 10.h),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(
  //                     item['icon'] as IconData,
  //                     color: item['color'] as Color,
  //                     size: 26.sp,
  //                   ),
  //                   SizedBox(width: 8.w),
  //                   Text(
  //                     item['name'] as String,
  //                     style: AppTextStyles.headingSmallStyle(
  //                       context,
  //                     ).copyWith(fontSize: 16.sp),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 6.h),
  //               Row(
  //                 children: [
  //                   SizedBox(
  //                     width: 55.w,
  //                     child: Text(
  //                       comparisonText,
  //                       style: AppTextStyles.headingSmallStyle(context)
  //                           .copyWith(
  //                             color: ratio >= 1.0
  //                                 ? AppColors.errorDark
  //                                 : AppColors.greyShimmerShade400,
  //                             fontSize: 14.sp,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                     ),
  //                   ),
  //
  //
  //
  //                   //visual bars
  //                   Expanded(
  //                     child: Container(
  //                       height: 30.h,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(15.r),
  //                         color: Colors.black12, // Khali track ka color
  //                       ),
  //                       child: Stack(
  //                         children: [
  //                           // 1. BASE BAR (Jo bada hai wo niche)
  //                           Container(
  //                             width: double.infinity, // Full Width
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(15.r),
  //                               // AGAR Asteroid bada hai toh White, varna Building ka color (Dull)
  //                               color: ratio >= 1.0
  //                                   ? AppColors.surfaceLight
  //                                   : (item['color'] as Color).withOpacity(0.4),
  //                             ),
  //                             alignment: Alignment.centerLeft,
  //                             padding: EdgeInsets.only(left: 12.w),
  //                             child: Text(
  //                               ratio >= 1.0 ? 'Asteroid (Base)' : item['name'] as String,
  //                               style: TextStyle(
  //                                 color: ratio >= 1.0 ? AppColors.black : Colors.white70,
  //                                 fontSize: 9.sp,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //
  //                           // 2. OVERLAY BAR (Jo chota hai wo upar chamkega)
  //                           FractionallySizedBox(
  //                             widthFactor: ratio >= 1.0 ? buildingWidthFactor : asteroidWidthFactor,
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(15.r),
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     color: AppColors.black.withOpacity(0.2),
  //                                     blurRadius: 4,
  //                                     offset: const Offset(2, 0),
  //                                   )
  //                                 ],
  //                                 // AGAR Asteroid bada hai toh Building Color, varna Asteroid (White) chamkega
  //                                 color: ratio >= 1.0
  //                                     ? (item['color'] as Color)
  //                                     : AppColors.surfaceLight,
  //                                 border: Border.all(color: AppColors.surfaceLight.withOpacity(0.5), width: 1),
  //                               ),
  //                               alignment: Alignment.centerLeft,
  //                               padding: EdgeInsets.only(left: 12.w),
  //                               child: Text( ratio >= 1.0
  //                                   ? item['name'] as String
  //                                   : 'Asteroid',
  //                                   style: TextStyle(
  //                                   color: ratio >= 1.0 ? AppColors.surfaceLight : AppColors.black,
  //                                   fontSize: 9.sp,
  //                                   fontWeight: FontWeight.bold,
  //                                   overflow: TextOverflow.ellipsis,
  //                                   ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //
  //       SizedBox(height: 10.h),
  //
  //       // color indicator
  //       _buildLegendRow(context,AppColors.surfaceLight,'Asteroid'),
  //       SizedBox(
  //         height: 10.h
  //       ),
  //
  //       SizedBox(
  //         height: 20.h,
  //         child: ListView(
  //           scrollDirection: Axis.horizontal,
  //           children: [
  //             _buildLegendRow(context,AppColors.infoDark,'FootBall Field'),
  //             SizedBox(width: 20.w),
  //             _buildLegendRow(context,AppColors.success,'Eiffel Tower'),
  //             SizedBox(width: 20.w),
  //             _buildLegendRow(context,Colors.cyan,'Empire State'),
  //             SizedBox(width: 20.w),
  //             _buildLegendRow(context,AppColors.orangeShade800,'Burj Khalifa'),
  //             SizedBox(width: 20.w),
  //           ],
  //         ),
  //       ),
  //
  //       // --- Footer Range ---
  //       SizedBox(height: 15.h),
  //       Center(
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
  //           decoration: BoxDecoration(
  //             color: Colors.blue.withOpacity(0.2),
  //             borderRadius: BorderRadius.circular(20.r),
  //             border: Border.all(color: Colors.blue.withOpacity(0.4)),
  //           ),
  //           child: Text(
  //             'Diameter Range: ${minSize.toStringAsFixed(2)} - ${maxSize.toStringAsFixed(2)} km',
  //             style: AppTextStyles.headingSmallStyle(
  //               context,
  //             ).copyWith(fontSize: 12.sp),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // );
}

// Widget _buildLegendRow(BuildContext context,Color color, String label) {
//   return Row(
//       children:[
//         Container(
//         padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.5.h),
//         decoration: BoxDecoration(
//           color: color,//AppColors.surfaceLight,
//           borderRadius: BorderRadius.circular(2.r),
//           //border: Border.all(color: Colors.blue.withOpacity(0.4)),
//         ),
//       ),
//       SizedBox(width: 10.w),
//       Text(
//         label,//'Asteroid',
//         style: AppTextStyles.headingSmallStyle(
//           context,
//         ).copyWith(fontSize: 12.sp),
//       ),
//       ],
//   );
// }
//}

// Row(
// children:[
// Container(
//   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
//   decoration: BoxDecoration(
//     color: AppColors.infoDark,
//     borderRadius: BorderRadius.circular(2.r),
//     // border: Border.all(color: Colors.blue.withOpacity(0.4)),
//   ),
// ),
// SizedBox(width: 10.w),
// Text(
//   'FootBall Field',
//   style: AppTextStyles.headingSmallStyle(
//     context,
//   ).copyWith(fontSize: 12.sp),
// ),
//
// SizedBox(width: 20.w),
//
// Container(
// padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
// decoration: BoxDecoration(
// color: AppColors.success,
// borderRadius: BorderRadius.circular(2.r),
// // border: Border.all(color: Colors.blue.withOpacity(0.4)),
// ),
// ),
// SizedBox(width: 10.w),
// Text(
// 'Eiffel Tower',
// style: AppTextStyles.headingSmallStyle(
// context,
// ).copyWith(fontSize: 12.sp),
// ),
//
// SizedBox(width: 20.w),
//
// Container(
// padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
// decoration: BoxDecoration(
// color: Colors.cyan,
// borderRadius: BorderRadius.circular(2.r),
// // border: Border.all(color: Colors.blue.withOpacity(0.4)),
// ),
// ),
// SizedBox(width: 10.w),
// Text(
// 'Empire State',
// style: AppTextStyles.headingSmallStyle(
// context,
// ).copyWith(fontSize: 12.sp),
// ),
//
// SizedBox(width: 20.w),
//
// Container(
// padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
// decoration: BoxDecoration(
// color: AppColors.orangeShade800,
// borderRadius: BorderRadius.circular(2.r),
// // border: Border.all(color: Colors.blue.withOpacity(0.4)),
// ),
// ),
// SizedBox(width: 10.w),
// Text(
// 'Burj Khalifa',
// style: AppTextStyles.headingSmallStyle(
// context,
// ).copyWith(fontSize: 12.sp),
// ),
// ],
// ),

// Visual Bars color not visible
// Expanded(
//   child: Container(
//     height: 28.h,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(14.r),
//       color: (item['color'] as Color).withOpacity(0.05),
//     ),
//     child: Stack(
//       children: [
//         // 1. Asteroid Bar
//         FractionallySizedBox(
//           widthFactor: asteroidWidthFactor,
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primaryDark,
//                   AppColors.textDeepPurple,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(14.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primaryDark
//                       .withOpacity(0.3),
//                   blurRadius: 4,
//                 ),
//               ],
//             ),
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.only(left: 10.w),
//             child: Text(
//               'Asteroid',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 10.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//
//         // 2. Building Bar (Overlay)
//         FractionallySizedBox(
//           widthFactor: buildingWidthFactor,
//           child: Container(
//             decoration: BoxDecoration(
//               color: (item['color'] as Color).withOpacity(
//                 0.7,
//               ),
//               borderRadius: BorderRadius.circular(14.r),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.5),
//                 width: 1.5,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

// Expanded(
//   child: Container(
//     height: 24.h,
//     decoration: BoxDecoration(
//       color: (item['color'] as Color).withOpacity(0.2),
//       borderRadius: BorderRadius.circular(12.r),
//     ),
//     child: Stack(
//       children: [
//
//
//         // The Background Bar
//         FractionallySizedBox(
//           widthFactor: 1.0,
//           child: Container(
//               decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.r),
//               color: (item['color'] as Color).withOpacity(0.3),
//               ),
//           ),
//         ),
//
//         // The "Asteroid" Progress Part
//         FractionallySizedBox(
//           widthFactor: 0.7, // Image ke hisaab se asteroid bar bada hai
//           child: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [AppColors.primaryDark, (item['color'] as Color)]),
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(color: AppColors.greyShimmerShade700)
//             ),
//             child: Text('Asteroid', style: AppTextStyles.headingSmallStyle(context).copyWith( fontSize: 14.sp)),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

// Expanded(
//   child: Container(
//     height: 24.h,
//     child: Stack(
//       children: [
//         // 1. Background (Total Width)
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.r),
//             color: (item['color'] as Color).withOpacity(
//               0.1,
//             ),
//           ),
//         ),
//
//         // 2. Asteroid Bar (Hamesha Full ya bada dikhega)
//         // Hum isse base maan rahe hain
//         FractionallySizedBox(
//           widthFactor: 1.0,
//           child: Container(
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.only(left: 8.w),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primaryDark,
//                   (item['color'] as Color),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Text(
//               'Asteroid',
//               style: TextStyle(fontSize: 10.sp),
//             ),
//           ),
//         ),
//
//         // 3. Object Bar (Burj Khalifa/Tower etc.)
//         // Yeh asteroid ke upar ya niche overlay hoga relative size mein
//         FractionallySizedBox(
//           widthFactor: objectWidthFactor,
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.surfaceLight.withOpacity(
//                 0.8,
//               ),
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(
//                 color: item['color'] as Color,
//                 width: 1.5,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
