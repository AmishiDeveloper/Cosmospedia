import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CmeAnalysisScreen extends StatelessWidget {
  final List<CmeAnalysisModel> analysisData;
  final double impactProbability;

  const CmeAnalysisScreen({
    super.key,
    required this.analysisData,
    required this.impactProbability,
  });

  @override
  Widget build(BuildContext context) {
    // making event speed list from speed extracted from each event of analysisData
    final List<double> speedData = analysisData
        .where((a) => a.speed != null)
        .map((a) => a.speed!)
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 8.w),
      child: Column(
        children: [
          // cme summary card
          _buildCmeAnalysisSummaryHeader(context, analysisData),

          SizedBox(height: 20.h),

          // speed line chart
          _buildEnhancedSpeedAnalysisChart(context, speedData),

          SizedBox(height: 12.h),

          //events impact on earth
          _buildEarthImpactProbabilityChart(context, impactProbability),

          SizedBox(height: 12.h),

          // type of event
          _buildCmeTypeDistributionChart(context, analysisData),

          SizedBox(height: 12.h),

          // angle distribution of cmes
          _buildCmeAngleDistributionChart(context,analysisData),

          SizedBox(height: 12.h),

          // source of eruption of cme on sun
          _buildCmeSourceLocationChart(context,analysisData),

          SizedBox(height: 12.h),

        ],
      ),
    );
  }

  Widget _buildCmeAnalysisSummaryHeader(
    BuildContext context,
    List<CmeAnalysisModel> analysisList,
  ) {
    final speeds = analysisList
        .where((a) => a.speed != null)
        .map((a) => a.speed!)
        .toList();

    // Max Speed logic
    final double maxSpeed = speeds.isNotEmpty
        ? speeds.reduce((a, b) => a > b ? a : b)
        : 0.0;

    // Average Speed logic (Safety from division by zero)
    final double avgSpeed = speeds.isNotEmpty
        ? speeds.fold<double>(0, (p, c) => p + c) / speeds.length
        : 0.0;

    // Angle/Width logic
    final angles = analysisList
        .where((a) => a.halfAngle != null)
        .map((a) => a.halfAngle!)
        .toList();

    final double avgAngle = angles.isNotEmpty
        ? angles.fold<double>(0, (p, c) => p + c) / angles.length
        : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade100.withOpacity(0.17),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greyShimmerShade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Summary',
            style: AppTextStyles.headingSmallStyle(context),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAnalysisStatItem(
                context,
                icon: Icons.speed_rounded,
                value: '${maxSpeed.toInt()}',
                unit: 'km/s',
                label: 'Max Speed',
                color: AppColors.error,
              ),
              _buildAnalysisStatItem(
                context,
                icon: Icons.av_timer_rounded,
                value: '${avgSpeed.toInt()}',
                unit: 'km/s',
                label: 'Avg Speed',
                color: AppColors.orange,
              ),
              _buildAnalysisStatItem(
                context,
                icon: Icons.straighten_rounded,
                value: '${avgAngle.toInt()}°',
                unit: 'deg',
                label: 'Avg Width',
                color: AppColors.newsCalendarIconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function for individual items
  Widget _buildAnalysisStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String unit,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 28.h),
        ),
        SizedBox(height: 10.h),
        Text('$value $unit', style: AppTextStyles.headingSmallStyle(context)),

        Text(
          label,
          style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(),
        ),
      ],
    );
  }

  Widget _buildEnhancedSpeedAnalysisChart(
    BuildContext context,
    List<double> speedData,
  ) {
    if (speedData.isEmpty) return const SizedBox.shrink();

    // 1. Data Cleaning & Sorting
    final sortedSpeeds = List<double>.from(speedData)..sort();
    final int totalCount = sortedSpeeds.length;
    final double maxSpeed = sortedSpeeds.last;
    final double avgSpeed =
        sortedSpeeds.fold(0.0, (p, c) => p + c) / totalCount;

    // 2. Y-Axis Logic (250 multiples)
    final double maxY = ((maxSpeed / 250).ceil() * 250).toDouble();

    // 3. Find EXACT event index where speed hits average
    final int avgHitIndex = sortedSpeeds.indexWhere((s) => s >= avgSpeed);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.greyShimmerShade400,
        ), // Main Outer Box
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CME Speed Analysis',
            style: AppTextStyles.headingSmallStyle(context),
          ),
          SizedBox(height: 8.h),
          Text(
            'Distribution of CME speeds (km/s)',
            style: AppTextStyles.descriptionSmallTextStyle(
              context,
            ).copyWith(color: AppColors.greyShimmer),
          ),
          SizedBox(height: 16.h),

          // --- Numerical Summary Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartSummaryStat(
                context,
                'Min',
                '${sortedSpeeds.first.toInt()} km/s',
                AppColors.success,
              ),
              _buildChartSummaryStat(
                context,
                'Avg',
                '${avgSpeed.toInt()} km/s',
                AppColors.orange,
              ),
              _buildChartSummaryStat(
                context,
                'Max',
                '${maxSpeed.toInt()} km/s',
                AppColors.error,
              ),
            ],
          ),
          SizedBox(height: 30.h),

          // --- Main Graph Area ---
          SizedBox(
            height: 250.h,
            child: LineChart(
              LineChartData(
                // Box Boundaries
                minX: 0,
                maxX: (totalCount - 1).toDouble(),
                minY: 0,
                maxY: maxY,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  // Grid lines for professional look
                  horizontalInterval: 250,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: AppColors.greyShimmerShade600,
                    strokeWidth: 0.2,
                  ),
                  getDrawingVerticalLine: (val) => FlLine(
                    color: AppColors.greyShimmerShade600,
                    strokeWidth: 0.2,
                  ),
                ),

                titlesData: FlTitlesData(
                  show: true,
                  // Y-Axis Speed Labels
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      "Speed (km/s)  ----->",
                      style: AppTextStyles.smallTextStyle(
                        context,
                      ).copyWith(color: AppColors.greyShimmerShade300),
                    ),
                    axisNameSize: 20,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 250,
                      reservedSize: 32,
                      getTitlesWidget: (v, m) => Text(
                        '${v.toInt()}',
                        style: AppTextStyles.descriptionSmallTextStyle(context)
                            .copyWith(
                              color: AppColors.greyShimmerShade400,
                              fontSize: 10.sp,
                            ),
                      ),
                    ),
                  ),
                  // X-Axis Index Labels (Dynamic)
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        int i = val.toInt();
                        // Only show labels for Start, Median, Max, and Avg-Hit
                        if (i == 0 ||
                            i == totalCount ~/ 2 ||
                            i == totalCount - 1 ||
                            i == avgHitIndex) {
                          String label = "";
                          if (i == 0)
                            label = "Slow";
                          else if (i == totalCount ~/ 2)
                            label = "Median";
                          else if (i == totalCount - 1)
                            label = "Fast";
                          else
                            label = "Avg Hit"; // Specific marker

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "#${i + 1}",
                                style: AppTextStyles.smallTextStyle(context)
                                    .copyWith(
                                      color: AppColors.info,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                label,
                                style: AppTextStyles.smallTextStyle(context)
                                    .copyWith(
                                      color: AppColors.greyShimmerShade300,
                                      fontSize: 9.sp,
                                    ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),

                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppColors.greyShimmerShade400,
                    width: 1.w,
                  ), // The inner graph box
                ),

                lineBarsData: [
                  // Speed Curve
                  LineChartBarData(
                    spots: sortedSpeeds
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    barWidth: 3.w,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.success,
                        AppColors.orange,
                        AppColors.error,
                      ],
                    ),
                    dotData: FlDotData(show: totalCount <= 20),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.info.withOpacity(0.1),
                    ),
                  ),
                  // Horizontal Avg Line
                  LineChartBarData(
                    spots: [
                      FlSpot(0, avgSpeed),
                      FlSpot((totalCount - 1).toDouble(), avgSpeed),
                    ],
                    dashArray: [5, 5],
                    color: AppColors.greyShimmerShade300,
                    barWidth: 1.w,
                    dotData: const FlDotData(show: false),
                  ),
                  // Vertical Avg Hit Line (With Index label at bottom)
                  if (avgHitIndex != -1)
                    LineChartBarData(
                      spots: [
                        FlSpot(avgHitIndex.toDouble(), 0),
                        FlSpot(avgHitIndex.toDouble(), maxY),
                      ],
                      dashArray: [5, 5],
                      color: AppColors.success,
                      barWidth: 1.w,
                      dotData: const FlDotData(show: false),
                    ),
                ],
              ),
            ),
          ),

          Center(
            child: Text(
              "CME Events sorted by speed ----->",
              style: AppTextStyles.smallTextStyle(
                context,
              ).copyWith(color: AppColors.greyShimmerShade300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSummaryStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label (Min, Avg, Max) - Colored and Bold
        Text(
          label,
          style: AppTextStyles.smallTextStyle(context).copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),

        SizedBox(height: 4.h),

        // Value (e.g., 298 km/s) - Large and White
        Text(
          value,
          style: AppTextStyles.descriptionSmallTextStyle(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildEarthImpactProbabilityChart(
    BuildContext context,
    double probability,
  ) {
    // Color switch logic based on danger
    Color progressColor = probability > 70
        ? AppColors.error
        : (probability > 30 ? AppColors.orange : AppColors.success);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.greyShimmerShade400,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Earth Impact Probability',
            style: AppTextStyles.headingSmallStyle(context),
          ),
          SizedBox(height: 10.h),
          Text(
            'Likelihood of CMEs affecting Earth',
            style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmerShade400),
          ),
          SizedBox(height: 30.h),

          SizedBox(
            height: 180.h,
            child: Stack(
              children: [
                // The Actual Chart
                PieChart(
                  PieChartData(
                    startDegreeOffset: 270, // Top se shuru ho
                    sectionsSpace: 0,
                    centerSpaceRadius: 60.r,
                    sections: [
                      // Impact Section
                      PieChartSectionData(
                        value: probability == 0 ? 0.1 : probability,
                        // 0 pe chota sa spot
                        color: progressColor,
                        radius: 15.r,
                        showTitle: false,
                      ),
                      // Safe Section (Remaining)
                      PieChartSectionData(
                        value: 100 - probability,
                        color: AppColors.greyShimmerShade600.withOpacity(0.5),
                        radius: 12.r,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                // Center Text
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${probability.toInt()}%',
                        style: AppTextStyles.headingSmallStyle(
                          context,
                        ).copyWith(fontSize: 24.sp, color: progressColor),
                      ),
                      Text(
                        probability > 50 ? 'High Risk' : 'Low Risk',
                        style: AppTextStyles.descriptionSmallTextStyle(
                          context,
                        ).copyWith(fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              probability == 0
                  ? "Safe: No Earth-directed events detected."
                  : (probability >0 && probability< 50)
                       ? "Warning: Potential geomagnetic activity."
                       : "Critical: High probability of Earth impact!",
              textAlign: TextAlign.center,
              style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                color: (probability == 0)
                    ? AppColors.success
                    : (probability >0 && probability< 50) ? AppColors.orange : AppColors.error,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCmeTypeDistributionChart(
    BuildContext context,
    List<CmeAnalysisModel> analysisList,
  ) {
    // 1. Data Grouping Logic
    int sCount = 0;
    int cCount = 0;
    int oCount = 0;

    for (var analysis in analysisList) {
      final speed = analysis.speed ?? 0;
      if (speed > 1000) {
        oCount++;
      } else if (speed >= 500) {
        cCount++;
      } else if (speed > 0) {
        sCount++;
      }
    }

    final int total = sCount + cCount + oCount;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.greyShimmerShade400,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CME Type Distribution',
            style: AppTextStyles.headingSmallStyle(context),
          ),
          SizedBox(height: 10.h,),
          Text(
            'Categories of observed Coronal Mass Ejections',
            style:  AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmerShade400),
          ),

          SizedBox(height: 20.h),

          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40.r,
                sections: [
                  if (sCount > 0)
                    PieChartSectionData(
                      value: sCount.toDouble(),
                      title: '$sCount',
                      color: AppColors.success,
                      radius: 50.r,
                      titleStyle: AppTextStyles.descriptionSmallTextStyle(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                  if (cCount > 0)
                    PieChartSectionData(
                      value: cCount.toDouble(),
                      title: '$cCount',
                      color: AppColors.yellow,
                      radius: 50.r,
                      titleStyle:
                          AppTextStyles.descriptionSmallTextStyle(
                            context,
                          ).copyWith(
                            color: AppColors.greyShimmerShade600,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  if (oCount > 0)
                    PieChartSectionData(
                      value: oCount.toDouble(),
                      title: '$oCount',
                      color: AppColors.error,
                      radius: 50.r,
                      titleStyle: AppTextStyles.descriptionSmallTextStyle(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Dynamic Legends Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (sCount > 0) _buildLegendItem(context, 'Type S', AppColors.success),
              if (cCount > 0) ...[
                SizedBox(width: 15.w),
                _buildLegendItem(context, 'Type C', AppColors.yellow),
              ],
              if (oCount > 0) ...[
                SizedBox(width: 15.w),
                _buildLegendItem(context, 'Type O', AppColors.error),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmerShade300, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildCmeSourceLocationChart(BuildContext context, List<CmeAnalysisModel> analysisList) {
    // 1. Logic to group by Latitude
    int northCount = 0;
    int southCount = 0;
    int equatorialCount = 0;

    for (var analysis in analysisList) {
      if (analysis.latitude != null) {
        double lat = analysis.latitude!.toDouble();
        if (lat > 15) {
          northCount++;
        } else if (lat < -15) {
          southCount++;
        } else {
          equatorialCount++;
        }
      }
    }

    final int total = northCount + southCount + equatorialCount;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greyShimmerShade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Heading Left-Aligned
        children: [
          Text('CME Source Locations', style: AppTextStyles.headingSmallStyle(context)),
          SizedBox(height: 10.h),
          Text(
            'Where on the Sun are these eruptions coming from?',
            style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmerShade400),
          ),
          SizedBox(height: 20.h),

          // Donut Chart
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40.r,
                sections: [
                  if (northCount > 0)
                    PieChartSectionData(
                      value: northCount.toDouble(),
                      title: 'North\n$northCount',
                      color: AppColors.info, // Blue
                      radius: 50.r,
                      titleStyle: AppTextStyles.smallTextStyle(context).copyWith(fontWeight: FontWeight.bold,fontSize: 10.sp),
                    ),
                  if (equatorialCount > 0)
                    PieChartSectionData(
                      value: equatorialCount.toDouble(),
                      title: 'Equatorial\n$equatorialCount',
                      color: AppColors.success, // Green
                      radius: 50.r,
                      titleStyle:  AppTextStyles.smallTextStyle(context).copyWith(fontWeight: FontWeight.bold,fontSize: 10.sp),
                    ),
                  if (southCount > 0)
                    PieChartSectionData(
                      value: southCount.toDouble(),
                      title: 'South\n$southCount',
                      color: Colors.purpleAccent, // Purple
                      radius: 50.r,
                      titleStyle: AppTextStyles.smallTextStyle(context).copyWith(fontWeight: FontWeight.bold, fontSize: 10.sp),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Legends Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendCircle('North', AppColors.info),
              SizedBox(width: 15.w),
              _buildLegendCircle('Equatorial', AppColors.success),
              SizedBox(width: 15.w),
              _buildLegendCircle('South', Colors.purpleAccent),
            ],
          ),
        ],
      ),
    );
  }

// Helper for Legend
  Widget _buildLegendCircle(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
        ),
        SizedBox(width: 6.w),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
      ],
    );
  }

  Widget _buildCmeAngleDistributionChart(
      BuildContext context,
      List<CmeAnalysisModel> analysisList,
      ) {
    // 1. Data Processing: Bins (Groups) calculation
    int narrow = 0; // < 20°
    int normal = 0; // 20°-40°
    int wide = 0;   // 40°-60°
    int halo = 0;   // > 60°

    final angles = analysisList
        .where((a) => a.halfAngle != null)
        .map((a) => a.halfAngle!)
        .toList();

    for (var angle in angles) {
      if (angle < 20) narrow++;
      else if (angle < 40) normal++;
      else if (angle < 60) wide++;
      else halo++;
    }

    // Numerical Stats for Header
    final double minAngle = angles.isNotEmpty ? (List.from(angles)..sort()).first : 0.0;
    final double maxAngle = angles.isNotEmpty ? (List.from(angles)..sort()).last : 0.0;
    final double avgAngle = angles.isNotEmpty ? angles.fold<double>(0, (p, c) => p + c) / angles.length : 0.0;

    // 2. Y-Axis Logic: Max count find karna aur 2 ke multiple mein set karna
    int maxCount = [narrow, normal, wide, halo].reduce((a, b) => a > b ? a : b);
    double maxY = ((maxCount / 2).ceil() * 2).toDouble();
    if (maxY == 0) maxY = 4; // Default safe height

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greyShimmerShade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CME Angle Distribution', style: AppTextStyles.headingSmallStyle(context)),
          SizedBox(height: 8.h),
          Text(
            'Angular width of Coronal Mass Ejections',
            style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmer),
          ),
          SizedBox(height: 16.h),

          // --- Numerical Summary Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartSummaryStat(context, 'Min', '${minAngle.toInt()}°', AppColors.success),
              _buildChartSummaryStat(context, 'Avg', '${avgAngle.toInt()}°', AppColors.info),
              _buildChartSummaryStat(context, 'Max', '${maxAngle.toInt()}°', Colors.purpleAccent),
            ],
          ),
          SizedBox(height: 30.h),

          // --- Main Bar Chart Area ---
          SizedBox(
            height: 250.h,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 4, // Scale of 2 as requested
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(color: AppColors.greyShimmerShade600, strokeWidth: 0.2),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: AppColors.greyShimmerShade400, width: 1.w), // Box Boundary
                ),
                titlesData: FlTitlesData(
                  show: true,
                  // Y-Axis: No of Events
                  leftTitles: AxisTitles(
                    axisNameWidget: Text("No. of Events  ----->",
                        style: AppTextStyles.smallTextStyle(context).copyWith(color: AppColors.greyShimmerShade300)),
                    axisNameSize: 20,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 4,
                      reservedSize: 30,
                      getTitlesWidget: (v, m) => Text('${v.toInt()}',
                          style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmerShade300, fontSize: 11.sp)),
                    ),
                  ),
                  // X-Axis: Labels with Range and Name
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (val, meta) {
                        String range = "";
                        String label = "";
                        switch (val.toInt()) {
                          case 0: range = "< 20°"; label = "Narrow"; break;
                          case 1: range = "20°-40°"; label = "Normal"; break;
                          case 2: range = "40°-60°"; label = "Wide"; break;
                          case 3: range = "> 60°"; label = "Halo"; break;
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10.h),
                            Text(range, style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmerShade300, fontSize: 11.sp),),
                            Text(label, style: TextStyle(color: AppColors.info, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                          ],
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  _makeGroupData(0, narrow.toDouble(), AppColors.info), // Blue
                  _makeGroupData(1, normal.toDouble(), AppColors.success), // Green
                  _makeGroupData(2, wide.toDouble(), AppColors.orange), // Orange
                  _makeGroupData(3, halo.toDouble(), AppColors.error), // Red
                ],
              ),
            ),
          ),

          Center(
            child: Text(
              "CME Angle ----->",
              style: AppTextStyles.smallTextStyle(context).copyWith(color: AppColors.greyShimmerShade300),
            ),
          ),
        ],
      ),
    );
  }

// Helper to create Bar Groups
  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 35.w, // Thickness of bar
          borderRadius: BorderRadius.circular(4.r),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 0,
            color: Colors.white10,
          ),
        ),
      ],
    );
  }


}
