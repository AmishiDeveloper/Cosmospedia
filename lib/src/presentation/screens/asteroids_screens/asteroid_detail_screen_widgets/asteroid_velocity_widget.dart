import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_common_models/asteroid_close_approach_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AsteroidVelocityWidget extends StatelessWidget {
  final List<CloseApproachDatum> closeApproachDatum;

  const AsteroidVelocityWidget({super.key, required this.closeApproachDatum});

  @override
  Widget build(BuildContext context) {

    final currentYear = DateTime.now().year;
    final limitYear = currentYear + 10; // 2026 + 10 = 2036 tak ka data

    // 1. Filter: Shuruat se lekar aaj ke year se 10 saal aage tak
    final List<CloseApproachDatum> filteredApproaches = closeApproachDatum.where((a) {
      if (a.closeApproachDate == null) return false;
      final year = a.closeApproachDate!.year;
      // Condition: Saal limitYear (2036) se chota ya barabar hona chahiye
      return year <= limitYear;
    }).toList();

    // 4. Safety Check: Agar list bahut lambi ho jaye (e.g. 200 points),
    // toh sirf aakhri 20 points dikhao taaki graph clean rahe.
    final finalApproaches = filteredApproaches.length > 25
        ? filteredApproaches.sublist(filteredApproaches.length - 25)
        : filteredApproaches;

    // 2. Data Extraction
    final List<double> velocities = finalApproaches.map((a) =>
    double.tryParse(a.relativeVelocity?.kilometersPerSecond??'0') ?? 0.0).toList();

    final List<String> closeApproachDates = finalApproaches.map((a) => a.closeApproachDate != null
        ? DateFormat('yyyy-MM-dd').format(a.closeApproachDate!)
        : "N/A"
    ).toList();

    // 2. Dynamic Y-Axis Scaling (30 km/s se upar handle karne ke liye)
    double maxVel = velocities.reduce((a, b) => a > b ? a : b);

    // 2. Dynamic Interval: Max value ko 5 se divide karo aur round off kar do
    double intervalY = (maxVel / 5).ceilToDouble();
    if (intervalY < 1) intervalY = 1; // Safety check

    // Isse graph hamesha (interval * multiples) par khatam hoga
    double chartMaxY = ((maxVel / intervalY).ceil() + 1) * intervalY;

    //double chartMaxY = maxVel + (maxVel * 0.2); // 20% buffer upar se//0.2

    // return Card(
    //   elevation: 8,
    //   color: Colors.blueGrey.withOpacity(0.2),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Row(
    //           children: [
    //             const Icon(Icons.speed, color: Colors.white),
    //             const SizedBox(width: 8),
    //             Text(
    //               'Approach Velocity Over Time',
    //               style: Theme
    //                   .of(context)
    //                   .textTheme
    //                   .titleLarge
    //                   ?.copyWith(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ],
    //         ),
    //         const Divider(color: Colors.white30),
    //         const SizedBox(height: 16),




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
                  Icons.speed,
                  color: AppColors.surfaceLight,
                  size: 25.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Center(
                    child: Text(
                      'Approach Velocity Over Time',
                      style: AppTextStyles.headingSmallStyle(context).copyWith(fontSize: 20.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: AppColors.greyShimmerShade100, height: 25.h),

            SizedBox(height:15.h),

            SizedBox(
              height: 310.h,
              child: LineChart(
                LineChartData(
                  // Max Y ko dynamic rakha hai taaki data cut na ho
                  maxY: chartMaxY,
                  minY: 0,
                  // X-axis Index-based hai (0 se length-1 tak)
                  minX: 0,
                  maxX: (velocities.length-1).toDouble(),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final index = barSpot.x.toInt();
                          return LineTooltipItem(
                            '${closeApproachDates[index]}\n${velocities[index]
                                .toStringAsFixed(2)} km/s',
                             AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                                fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    // Grid lines ko dynamic adjust karna
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    horizontalInterval: intervalY,//(chartMaxY / 5).clamp(1, 50),
                    // har data point ke liye line
                    verticalInterval: 1,//(velocities.length / 5).clamp(1, 100).toDouble(),
                    getDrawingHorizontalLine: (value) =>
                    const FlLine(color: Colors.white10, strokeWidth: 1),
                    getDrawingVerticalLine: (value) =>
                    const FlLine(color: Colors.white10, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40.sp,
                        interval: 1, // for dates in x axis bottom
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index < 0 || index > finalApproaches.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 8.0.h),
                            child: Transform.rotate(
                              angle: -1.2,
                              child: Text(
                                closeApproachDates[index].substring(0, 7),
                                // YYYY-MM format
                                style: AppTextStyles.smallTextStyle(context).copyWith(color: AppColors.greyShimmerShade400,fontSize: 10.sp),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text(
                        'Velocity (km/s)',
                        style: AppTextStyles.smallTextStyle(context).copyWith(color: AppColors.greyShimmerShade400),
                        ),
                        sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25.sp,
                        // Interval ko dynamic banaya taaki y-axis labels sahi dikhein
                        interval: intervalY,//(chartMaxY / 5).floorToDouble().clamp(1, 100),
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: AppTextStyles.smallTextStyle(context).copyWith(color: AppColors.greyShimmerShade400,),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: AppColors.greyShimmerShade400),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      // Index based spots: (0, vel[0]), (1, vel[1])...
                      spots: List.generate(
                        velocities.length,
                            (index) =>
                            FlSpot(index.toDouble(), velocities[index]),
                      ),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.info.withOpacity(0.8),
                          Colors.lightBlueAccent.withOpacity(0.8),
                        ],
                      ),
                      barWidth: 3.sp,
                      isStrokeCapRound: true,
                      //color: Colors.blueAccent,
                      dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6.r,
                            color: AppColors.surfaceLight,
                            strokeWidth: 2.w,
                            strokeColor: AppColors.info,
                          );
                        },
                      ),
                      // Clean look ke liye dots hide kiye
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            // Colors.blueAccent.withOpacity(0.3),
                            // Colors.transparent
                            AppColors.info.withOpacity(0.3),
                            AppColors.info.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
             SizedBox(height: 12.h),
            Center(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.info.withOpacity(0.5),),
              ),
                child:Text(
                  'Max Recorded Velocity: ${maxVel.toStringAsFixed(2)} km/s',
                  style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                      color: AppColors.blueShade400, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
  }
}