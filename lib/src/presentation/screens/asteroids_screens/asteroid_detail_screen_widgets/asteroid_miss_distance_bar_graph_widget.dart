import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_common_models/asteroid_close_approach_model.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_timeline_views_miss_distance_cubit/miss_distance_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AsteroidMissDistanceBarGraphWidget extends StatelessWidget {
  final List<CloseApproachDatum> closeApproachData;

  const AsteroidMissDistanceBarGraphWidget({
    super.key,
    required this.closeApproachData,
  });

  // --- Normalization Logic (Option 3) ---
  double getNormalizedY(double value, String name) {
    double referenceMax = 1.0;
    if (name == 'KM')
      referenceMax = 150000000.0; //700000000.0
    else if (name == 'Miles')
      referenceMax = 93000000.0; //45000000.0
    else if (name == 'Lunar')
      referenceMax = 400.0; //150.0
    else if (name == 'AU')
      referenceMax = 1.0; //0.5

    return ((value / referenceMax) * 100).clamp(10.0, 100.0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissDistanceCubit, MissDistanceState>(
      builder: (context, state) {
        final selected = state.selectedApproach;

        // --- Data Extraction ---
        final km =
            double.tryParse(selected.missDistance?.kilometers ?? '0') ?? 0.0;
        final miles =
            double.tryParse(selected.missDistance?.miles ?? '0') ?? 0.0;
        final au =
            double.tryParse(selected.missDistance?.astronomical ?? '0') ?? 0.0;
        final lunar =
            double.tryParse(selected.missDistance?.lunar ?? '0') ?? 0.0;

        final List<Map<String, dynamic>> barItems = [
          {
            'name': 'KM',
            'val': km,
            'color': AppColors.info,
            'icon': Icons.straighten,
          },
          {
            'name': 'Miles',
            'val': miles,
            'color': AppColors.textPurple,
            'icon': Icons.map,
          },
          {
            'name': 'Lunar',
            'val': lunar,
            'color': AppColors.success,
            'icon': Icons.nightlight_round,
          },
          {
            'name': 'AU',
            'val': au,
            'color': AppColors.orange,
            'icon': Icons.wb_sunny,
          },
        ];

        return Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: AppColors.greyShimmerShade900.withOpacity(0.4),
            //drawerHeaderGradient.withOpacity(0.4),
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
                    size: 25.sp,
                  ),

                  SizedBox(width: 8.w),

                  Expanded(
                    child: Text(
                      'Miss Distance Comparison',
                      style: AppTextStyles.headingSmallStyle(
                        context,
                      ).copyWith(fontSize: 17.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //SizedBox(width: 10.w),

                  // DROPDOWN
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: _buildDropdown(context, selected),
                    ),
                  ),
                ],
              ),

              Divider(color: AppColors.greyShimmerShade100, height: 25.h),

              SizedBox(height: 5.h),

              // BAR CHART (Option 3 Logic)
              SizedBox(height: 220.h, child: _buildBarChart(context, barItems)),

              SizedBox(height: 16.h),

              _buildContextBox(context, lunar, au),
            ],
          ),
        );
      },
    );
  }


  // Dropdown update karne ke liye Cubit call karein
  Widget _buildDropdown(BuildContext context, CloseApproachDatum selected) {
    return Container(
      padding: EdgeInsets.only(left: 8.w),
      decoration: BoxDecoration(
        // Drawer header gradient ya koi bhi dark color use kar sakte ho
        color: AppColors.greyShimmerShade600.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        // Yahan se Round Corners aayenge
        border: Border.all(
          color: AppColors.greyShimmerShade400.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        // Default underline hatane ke liye
        child: DropdownButton<CloseApproachDatum>(
          value: selected,
          dropdownColor: AppColors.drawerHeaderGradient,
          items: closeApproachData.map((approach) {
            return DropdownMenuItem(
              value: approach,
              child: Text(
                DateFormat(
                  'yyyy-MM-dd',
                ).format(approach.closeApproachDate ?? DateTime.now()),
                style: AppTextStyles.descriptionSmallTextStyle(context),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<MissDistanceCubit>().updateApproach(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    List<Map<String, dynamic>> barItems,
  ) {
    return BarChart(
      BarChartData(
        maxY: 115,
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50.h, // Space badhai taaki text fit ho sake
              getTitlesWidget: (val, meta) {
                final index = val.toInt();
                if (index < 0 || index >= barItems.length)
                  return const SizedBox();

                final item = barItems[index];

                String fullName;
                switch (item['name']) {
                  case 'KM':
                    fullName = 'Kilometers';
                    break;
                  case 'Miles':
                    fullName = 'Miles';
                    break;
                  case 'Lunar':
                    fullName = 'Lunar';
                    break;
                  case 'AU':
                    fullName = 'AU';
                    break;
                  default:
                    fullName = item['name'];
                }

                return Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  //Icon + Text label x axis pe lane ke liye on the graph
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item['icon'], color: item['color'], size: 18.sp),

                      SizedBox(height: 4.h),

                      Text(
                        fullName,
                        style: AppTextStyles.descriptionSmallTextStyle(
                          context,
                        ).copyWith(fontSize: 9.sp),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(barItems.length, (index) {
          final item = barItems[index];
          return BarChartGroupData(
            x: index,
            showingTooltipIndicators: [0],
            barRods: [
              BarChartRodData(
                toY: getNormalizedY(item['val'], item['name']),
                //bar ki unchai
                color: item['color'],
                //bar ka color (blue, purple, green, orange)
                width: 40.w,

                //background box
                borderRadius: BorderRadius.circular(6.r),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 100,
                  color: AppColors.surfaceLight.withOpacity(0.2),
                ),
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipMargin: 10.h,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final val = barItems[groupIndex]['val'];
              String display = val >= 1000000
                  ? "${(val / 1000000).toStringAsFixed(1)}M"
                  : val.toStringAsFixed(2);
              return BarTooltipItem(
                display,
                AppTextStyles.headingSmallStyle(
                  context,
                ).copyWith(fontSize: 12.sp),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContextBox(BuildContext context, double lunar, double au) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.greyShimmerShade400.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Context:', style: AppTextStyles.headingSmallStyle(context)),

          SizedBox(height: 10.h),

          Text(
            '• Lunar (LD) : Distance from the center of the Earth to the center of the Moon (1 LD= ~384,400 KM).\n${lunar.toStringAsFixed(2)} LD: This asteroid is currently ${lunar.toStringAsFixed(2)} times the distance between Earth & Moon.',
            style: AppTextStyles.headingSmallStyle(
              context,
            ).copyWith(fontSize: 12.sp, color: AppColors.greyShimmerShade300),
            softWrap: true,
          ),

          SizedBox(height: 15.h),

          Text(
            '• Astronomical Unit (AU): Average distance between Earth and the Sun (1 AU = 150M KM).\n ${au.toStringAsFixed(4)} AU: This asteroid is currently ${au.toStringAsFixed(4)} times the distance between Earth & Sun.',
            style: AppTextStyles.headingSmallStyle(
              context,
            ).copyWith(fontSize: 12.sp, color: AppColors.greyShimmerShade300),
            softWrap: true,
          ),

          SizedBox(height: 10.h),

          Text(
            'Benchmark Reference: ',
            style: AppTextStyles.headingSmallStyle(context),
          ),

          SizedBox(height: 10.h),

          Text(
            'The graph uses an average Near-Earth limit as 100% scale for visual comparison:',
            style: AppTextStyles.headingSmallStyle(
              context,
            ).copyWith(fontSize: 14.sp, color: AppColors.greyShimmerShade300),
            softWrap: true,
          ),

          SizedBox(height: 10.h),

          Text(
            '•Kilometers: 150 Million km (1 AU)\n• Miles: 93 Million miles\n• Lunar Distance: 400 LD\n• Astronomical Units: 1.0 AU',
            style: AppTextStyles.headingSmallStyle(
              context,
            ).copyWith(fontSize: 14.sp, color: AppColors.greyShimmerShade300),
            softWrap: true,
          ),

          SizedBox(height: 10.h),

          Text(
            'Note: A full bar indicates the asteroid is at or beyond these deep-space benchmarks.',
            style: AppTextStyles.headingSmallStyle(
              context,
            ).copyWith(fontSize: 14.sp, color: AppColors.greyShimmerShade300),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
