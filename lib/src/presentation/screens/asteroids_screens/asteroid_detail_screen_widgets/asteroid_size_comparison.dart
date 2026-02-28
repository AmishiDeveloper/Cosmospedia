import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_feed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/*
Scenario,Calculation (ratio=ObjAvg),Ratio Result,Text Logic,Screen Par Kya Dikhega?
"Asteroid Bada hai (e.g., 2km vs 1km)",2/1,2.0,ratio≥1,"""2.0x larger than object"""
"Dono Barabar hain (e.g., 1km vs 1km)",1/1,1.0,ratio≥1,"""1.0x larger (Equal)"""
"Asteroid Chota hai (e.g., 0.5km vs 1km)",0.5/1,0.5,ratio<1 use 1/ratio,"""2.0x smaller than object"""
"Asteroid Bahut Chota (e.g., 0.1km vs 1km)",0.1/1,0.1,ratio<1 use 1/ratio,"""10.0x smaller than object"""
*/


class AsteroidSizeComparison extends StatelessWidget {

  final NearEarthObject asteroid;
  const AsteroidSizeComparison({super.key, required this.asteroid});

  @override
  Widget build(BuildContext context) {
    // 1. Data Parsing (Safely handling values)
    final minSize =
        asteroid.estimatedDiameter?.kilometers?.estimatedDiameterMin ?? 0.0;
    final maxSize =
        asteroid.estimatedDiameter?.kilometers?.estimatedDiameterMax ?? 0.0;
    final avgSize = (minSize + maxSize) / 2;

    // Reference constants (in km)
    const double footballField = 0.11;
    const double eiffelTower = 0.33;
    const double empireState = 0.44;
    const double burjKhalifa = 0.828;

    final comparisons = [
      {
        'name': 'Football Field',
        'size': footballField,
        'color': AppColors.infoDark,
        'icon': Icons.sports_football,
      },
      {
        'name': 'Eiffel Tower',
        'size': eiffelTower,
        'color': AppColors.success,//
        // AppColors.primaryDark,
        'icon': Icons.location_city,
      },
      {
        'name': 'Empire State',
        'size': empireState,
        'color': //AppColors.orangeShade800,
        Colors.cyan,
        'icon': Icons.apartment,
      },
      {
        'name': 'Burj Khalifa',
        'size': burjKhalifa,
        'color': AppColors.orangeShade800,//textDeepPurple, //Colors.indigo,
        'icon': Icons.business,
      },
    ];

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade900.withOpacity(0.4),//drawerHeaderGradient.withOpacity(0.4),
        //splashBlueBackground, drawerHeader
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greyShimmerShade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            children: [
              Icon(
                Icons.compare_arrows,
                color: AppColors.surfaceLight,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Size Comparison',
                style: AppTextStyles.headingSmallStyle(context),
              ),
            ],
          ),
          Divider(color: AppColors.greyShimmerShade100, height: 25.h),

          // --- Central Asteroid Visual ---
          Center(
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.greyShimmerShade400,
                    AppColors.greyShimmerShade800,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.infoDark.withOpacity(0.3),
                    blurRadius: 20.r,
                    spreadRadius: 5.r,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${avgSize.toStringAsFixed(2)}\nkm',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingSmallStyle(
                    context,
                  ).copyWith(fontSize: 16.sp),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // --- Comparison Bars ---
          ...comparisons.map((item) {
            final double objectSize = item['size'] as double;
            final ratio = avgSize / objectSize;

            double asteroidWidthFactor;
            double buildingWidthFactor;
            String comparisonText;

            if (avgSize >= objectSize) {
              // Case 1: Asteroid bada hai
              asteroidWidthFactor = 1.0;
              buildingWidthFactor = (objectSize / avgSize).clamp(0.1, 1.0);
              comparisonText = '${ratio.toStringAsFixed(1)}x\nlarger';
            } else {
              // Case 2: Building badi hai
              buildingWidthFactor = 1.0;
              asteroidWidthFactor = (avgSize / objectSize).clamp(0.1, 1.0);
              comparisonText = '${(1 / ratio).toStringAsFixed(1)}x\nsmaller';
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                        size: 26.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item['name'] as String,
                        style: AppTextStyles.headingSmallStyle(
                          context,
                        ).copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      SizedBox(
                        width: 55.w,
                        child: Text(
                          comparisonText,
                          style: AppTextStyles.headingSmallStyle(context)
                              .copyWith(
                            color: ratio >= 1.0
                                ? AppColors.errorDark
                                : AppColors.greyShimmerShade400,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),



                      //visual bars
                      Expanded(
                        child: Container(
                          height: 30.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: Colors.black12, // Khali track ka color
                          ),
                          child: Stack(
                            children: [
                              // 1. BASE BAR (Jo bada hai wo niche)
                              Container(
                                width: double.infinity, // Full Width
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  // AGAR Asteroid bada hai toh White, varna Building ka color (Dull)
                                  color: ratio >= 1.0
                                      ? AppColors.surfaceLight
                                      : (item['color'] as Color).withOpacity(0.4),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 12.w),
                                child: Text(
                                  ratio >= 1.0 ? 'Asteroid (Base)' : item['name'] as String,
                                  style: TextStyle(
                                    color: ratio >= 1.0 ? AppColors.black : Colors.white70,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // 2. OVERLAY BAR (Jo chota hai wo upar chamkega)
                              FractionallySizedBox(
                                widthFactor: ratio >= 1.0 ? buildingWidthFactor : asteroidWidthFactor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(2, 0),
                                      )
                                    ],
                                    // AGAR Asteroid bada hai toh Building Color, varna Asteroid (White) chamkega
                                    color: ratio >= 1.0
                                        ? (item['color'] as Color)
                                        : AppColors.surfaceLight,
                                    border: Border.all(color: AppColors.surfaceLight.withOpacity(0.5), width: 1),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 12.w),
                                  child: Text( ratio >= 1.0
                                      ? item['name'] as String
                                      : 'Asteroid',
                                    style: TextStyle(
                                      color: ratio >= 1.0 ? AppColors.surfaceLight : AppColors.black,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 10.h),

          // color indicator
          _buildLegendRow(context,AppColors.surfaceLight,'Asteroid'),
          SizedBox(
              height: 10.h
          ),

          SizedBox(
            height: 20.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildLegendRow(context,AppColors.infoDark,'FootBall Field'),
                SizedBox(width: 20.w),
                _buildLegendRow(context,AppColors.success,'Eiffel Tower'),
                SizedBox(width: 20.w),
                _buildLegendRow(context,Colors.cyan,'Empire State'),
                SizedBox(width: 20.w),
                _buildLegendRow(context,AppColors.orangeShade800,'Burj Khalifa'),
                SizedBox(width: 20.w),
              ],
            ),
          ),

          // --- Footer Range ---
          SizedBox(height: 15.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.blue.withOpacity(0.4)),
              ),
              child: Text(
                'Diameter Range: ${minSize.toStringAsFixed(2)} - ${maxSize.toStringAsFixed(2)} km',
                style: AppTextStyles.headingSmallStyle(
                  context,
                ).copyWith(fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(BuildContext context,Color color, String label) {
    return Row(
      children:[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.5.h),
          decoration: BoxDecoration(
            color: color,//AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(2.r),
            //border: Border.all(color: Colors.blue.withOpacity(0.4)),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          label,//'Asteroid',
          style: AppTextStyles.headingSmallStyle(
            context,
          ).copyWith(fontSize: 12.sp),
        ),
      ],
    );
  }
}
