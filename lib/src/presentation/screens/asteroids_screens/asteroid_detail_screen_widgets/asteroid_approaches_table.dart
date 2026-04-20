import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_common_models/asteroid_close_approach_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AsteroidApproachesTable extends StatelessWidget {
  final List<CloseApproachDatum> closeApproachDatum;

  const AsteroidApproachesTable({super.key, required this.closeApproachDatum});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    CloseApproachDatum? closestPast;
    if (closeApproachDatum.isNotEmpty) {
      // Filter only past approaches
      final pastApproaches = closeApproachDatum.where((approachData) {
        final approachDate = approachData.closeApproachDate ?? DateTime.now();
        return approachDate.isBefore(today);
      }).toList();

      if (pastApproaches.isNotEmpty) {
        // Find the one with minimum kilometers
        closestPast = pastApproaches.reduce((curr, next) {
          double currDist =
              double.tryParse(curr.missDistance?.kilometers ?? '999999999') ??
              999999999;
          double nextDist =
              double.tryParse(next.missDistance?.kilometers ?? '999999999') ??
              999999999;
          return currDist < nextDist ? curr : next;
        });
      }
    }

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
                Icons.calendar_month_rounded,
                color: AppColors.surfaceLight,
                size: 25.sp,
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: Text(
                  'Close Approaches to Earth',
                  style: AppTextStyles.headingSmallStyle(
                    context,
                  ).copyWith(fontSize: 18.sp),
                  textAlign: TextAlign.center,
                ),
              ),

             // const Spacer(),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.greyShimmerShade400.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  '${closeApproachDatum.length}',
                  style: AppTextStyles.descriptionSmallTextStyle(context),
                ),
              ),
            ],
          ),

          Divider(color: AppColors.greyShimmerShade100, height: 25.h),

          SizedBox(height: 15.h),

          // DATA TABLE
          if (closeApproachDatum.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),//minWidth: 500.w - 64.w),
                child: DataTable(
                  columnSpacing: 24.w,
                  //HEADER ROW COLOR
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.drawerHeaderGradient,
                  ),
                  // --- VERTICAL & HORIZONTAL LINES ---
                  border: TableBorder(
                    verticalInside: BorderSide(color: Colors.white10, width: 2),
                    horizontalInside: BorderSide(color: Colors.white10, width: 1),
                  ),

                  rows: closeApproachDatum.asMap().entries.map((approach) {
                    final index = approach.key;
                    final aDate = approach.value.closeApproachDate ?? DateTime.now();
                    final isPast = aDate.isBefore(
                      today,
                    ); // Check if date has passed

                    return DataRow(
                      // PAST ROWS COLOR: Thoda dark/tinted for history
                      // FUTURE ROWS: Normal/Transparent
                      color: WidgetStateProperty.all(
                        isPast
                            ? AppColors.info.withOpacity(
                                0.15,
                              ) //607d8b-bluegrey
                            : Colors.transparent,
                      ),
                      cells: [
                        // DATE
                        DataCell(
                          Text(
                            DateFormat('yyyy-MM-dd').format(aDate),
                            style:
                                AppTextStyles.descriptionSmallTextStyle(
                                  context,
                                ).copyWith(
                                  color: isPast
                                      ? AppColors.surfaceLight
                                      : AppColors.greyShimmerShade400,
                                  fontWeight: isPast
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                          ),
                        ),

                        // VELOCITY
                        DataCell(
                          Center(
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [

                                //arrows
                                if (index > 0) _buildTrendIcon(approach.value, closeApproachDatum[index - 1]),

                                SizedBox(width: 5.w,),

                                Flexible(
                                  child: Text(
                                    double.parse(
                                      approach.value.relativeVelocity?.kilometersPerSecond ??
                                          '0',
                                    ).toStringAsFixed(2),
                                    style:
                                        AppTextStyles.descriptionSmallTextStyle(
                                          context,
                                        ).copyWith(
                                          color: isPast
                                              ? AppColors.surfaceLight
                                              : AppColors.greyShimmerShade400,
                                          fontWeight: isPast
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // miss  DISTANCE
                        DataCell(
                          Center(
                            child: Text(
                              _formatLargeNumber(
                                approach.value.missDistance?.kilometers ?? '0',
                              ),
                              style:
                                  AppTextStyles.descriptionSmallTextStyle(
                                    context,
                                  ).copyWith(
                                    color: isPast
                                        ? AppColors.surfaceLight
                                        : AppColors.greyShimmerShade400,
                                    fontWeight: isPast
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  columns: [
                    _buildDataColumn(context,Icons.event, 'Date'),
                    _buildDataColumn(context,Icons.speed, 'Velocity (km/s)',isCenter:true),
                    _buildDataColumn(context,Icons.straighten, 'Miss Distance (km)', isCenter:true),
                  ],
                ),
              ),
            ),

          // SUMMARY FOOTER: Closest Approach Till Now
          if (closestPast != null) ...[
            SizedBox(height: 20.h),
            _buildClosestSummary(context, closestPast),
          ],
        ],
      ),
    );
  }

  Widget _buildClosestSummary(
    BuildContext context,
    CloseApproachDatum closest,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1), // Distinct color for "Record"
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.history, color: Colors.orangeAccent, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Closest Approach Record (Till Now):',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'On ${DateFormat('yyyy-MM-dd').format(closest.closeApproachDate!)}, the asteroid passed at just ${_formatLargeNumber(closest.missDistance!.kilometers!)} km from Earth.',
                  style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLargeNumber(String value) {
    double? num = double.tryParse(value);
    if (num == null) return value;
    if (num >= 1000000) return "${(num / 1000000).toStringAsFixed(1)}M";
    if (num >= 1000) return "${(num / 1000).toStringAsFixed(0)}K";
    return num.toStringAsFixed(0);
  }

  DataColumn _buildDataColumn(BuildContext context,IconData icon, String label,{bool isCenter=false}) {
    return DataColumn(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.surfaceLight),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.headingSmallStyle(context).copyWith(fontSize: 14.sp),
            ),
        ],
      ),
    );
  }

  Widget _buildTrendIcon(CloseApproachDatum current, CloseApproachDatum previous) {
    final currVel = double.tryParse(current.relativeVelocity?.kilometersPerSecond ?? '0') ?? 0;
    final prevVel = double.tryParse(previous.relativeVelocity?.kilometersPerSecond ?? '0') ?? 0;

    if (currVel > prevVel) {
      return Icon(Icons.arrow_upward, color: Colors.redAccent, size: 16.sp);
    } else if (currVel < prevVel) {
      return Icon(Icons.arrow_downward, color: Colors.greenAccent, size: 16.sp);
    }
    return const SizedBox.shrink();
  }

}
