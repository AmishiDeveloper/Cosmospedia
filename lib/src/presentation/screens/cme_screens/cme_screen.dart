import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_model/cme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CmeScreen extends StatelessWidget {
  final List<CmeModel> cmeData;
  const CmeScreen({super.key, required this.cmeData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [

          // cme summary card
          _buildCMESummaryCard(context,cmeData),

          SizedBox(height: 20.h,),

          // cme info card
          _buildTypeLegendCard(context),

           SizedBox(height: 16.h),

          //cme events list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            itemCount: cmeData.length,
            itemBuilder: (context, index) {
              final cme = cmeData[index];
              return _buildCMECard(context, cme);
            },
          ),

        ],
      ),
    );
  }

  Widget _buildCMESummaryCard(BuildContext context,List<CmeModel> cmeList) {
    // Calculate key statistics
    final totalEvents = cmeList.length;
    final hasAnalyses = cmeList.where((cme) => cme.cmeAnalyses?.isNotEmpty ?? false).length;
    final averageSpeed = cmeList
        .expand((cme) => cme.cmeAnalyses ?? [])
        .where((analysis) => analysis.speed != null)
        .map((analysis) => analysis.speed!)
        .fold<double>(0, (prev, speed) => prev + speed) /
        (cmeList.expand((cme) => cme.cmeAnalyses ?? []).where((analysis) => analysis.speed != null).length > 0 ?
        cmeList.expand((cme) => cme.cmeAnalyses ?? []).where((analysis) => analysis.speed != null).length : 1);

    return Card(
      margin:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.surfaceLight.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CME Summary',
              style: AppTextStyles.headingSmallStyle(context),
              ),

            SizedBox(height: 16.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context: context,
                  icon: Icons.event,
                  value: totalEvents.toString(),
                  label: 'Total Events',
                  color: AppColors.info,
                ),
                _buildStatItem(
                  context: context,
                  icon: Icons.analytics,
                  value: hasAnalyses.toString(),
                  label: 'With Analysis',
                  color: AppColors.success,
                ),
                _buildStatItem(
                  context: context,
                  icon: Icons.speed,
                  value: '${averageSpeed.toInt()} km/s',
                  label: 'Avg. Speed',
                  color: AppColors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28.h,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyles.headingSmallStyle(context),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.descriptionSmallTextStyle(context),
        ),
      ],
    );
  }

  Widget _buildTypeLegendCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greyShimmerShade400.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.surfaceLight, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'CME Classification Guide',
                style: AppTextStyles.headingSmallStyle(context).copyWith(fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem(context, 'Type S', '< 500', AppColors.success, 'Slow'),
              _buildLegendItem(context, 'Type C', '500-1000', Colors.yellowAccent, 'Common'),
              _buildLegendItem(context, 'Type O', '> 1000', AppColors.error, 'Fast'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String title, String range, Color color, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            title,
            style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          range,
          style: AppTextStyles.smallTextStyle(context).copyWith(
            color: AppColors.surfaceLight,
            fontSize: 10.sp,
          ),
        ),
        Text(
          'km/s',
          style: AppTextStyles.smallTextStyle(context).copyWith(
            color: AppColors.greyShimmerShade400,
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }

  Map<String, int> _groupCMEsByDate(List<CmeModel> cmeList) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final Map<String, int> result = {};

    for (final cme in cmeList) {
      try {
        final dateTime=cme.startTime ?? '';
        final date = DateTime.parse(dateTime.replaceAll('Z', ''));
        final dateStr = dateFormat.format(date);
        result[dateStr] = (result[dateStr] ?? 0) + 1;
      } catch (e) {
        continue;
      }
    }

    return result;
  }

  Widget _buildCMECard(BuildContext context, CmeModel cme) {

    // 1. Sabse accurate analysis find karo (Header mein dikhane ke liye)
    final hasAnalysis = cme.cmeAnalyses != null && cme.cmeAnalyses!.isNotEmpty;
    final CmeAnalysis? mainAnalysis = hasAnalysis
        ? cme.cmeAnalyses!.firstWhere((a) => a.isMostAccurate == true, orElse: () => cme.cmeAnalyses!.first)
        : null;

    // 2. Speed ke basis par UI elements set karo
    final double speed = (mainAnalysis?.speed ?? 0.0).toDouble();
    Color typeColor = AppColors.success; // Type S (Default)
    String typeLabel = mainAnalysis?.type?.name ?? "S";

    if (speed > 1000) {
      typeColor = AppColors.error; // Type O
      typeLabel = "O";
    } else if (speed >= 500) {
      typeColor = AppColors.yellow; // Type C
      typeLabel = "C";
    }


    return Card(
      margin:  EdgeInsets.only(bottom: 12.h),
      color: AppColors.surfaceLight.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
          side:BorderSide(color: AppColors.greyShimmerShade400.withOpacity(0.2),),
      ),
      child: ExpansionTile(
        collapsedIconColor: AppColors.greyShimmerShade300,
        iconColor: AppColors.surfaceLight,
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding:EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.solar_power,
            color: typeColor,//Colors.white,
          ),
        ),
        title: Text(
          cme.activityId ?? 'CME Event',
          style: AppTextStyles.headingSmallStyle(context).copyWith(fontSize: 14.sp),
        ),
        subtitle: Text(
          _formatDateTime(cme.startTime??''),
          style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(fontSize: 12.sp),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: typeColor),
          ),
          child: Text(
            'Type $typeLabel',
            style: AppTextStyles.smallTextStyle(context).copyWith(color: typeColor, fontWeight: FontWeight.bold,),
          ),
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: EdgeInsets.all(16.h),
        children: [
          _buildCMEDetails(context,cme),
        ],
      ),
    );
  }

  Widget _buildCMEDetails(BuildContext context, CmeModel cme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.greyShimmerShade700),
         SizedBox(height: 8.h),
        _buildDetailRow('Start Time', _formatDateTime(cme.startTime??'')),
        /*if (cme.endTime != null) _buildDetailRow('End Time', _formatDateTime(cme.endTime!)),*/
        if (cme.note != null && cme.note!.isNotEmpty) _buildDetailRow('Note', cme.note!),

        if (cme.cmeAnalyses != null && cme.cmeAnalyses!.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Text(
            'Scientific Analysis',
            style: AppTextStyles.headingSmallStyle(context).copyWith(fontSize: 16.sp)
          ),
           SizedBox(height: 8.h),
          ...cme.cmeAnalyses!.map((analysis) {
            final isBest = analysis.isMostAccurate ?? false;
            return Container(
              color: AppColors.surfaceLight.withOpacity(0.05),
              margin:  EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: isBest ? AppColors.info.withOpacity(0.1) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
            color: isBest ? AppColors.info.withOpacity(0.5) : AppColors.greyShimmerShade800,
            ),
              ),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(8.r),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isBest)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Icon(Icons.verified, color: AppColors.info, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text('Most Accurate Prediction',
                              style: AppTextStyles.smallTextStyle(context).copyWith(color: AppColors.info, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  if (analysis.speed != null) _buildDetailRow('Speed', '${analysis.speed} km/s'),
                  if (analysis.type != null) _buildDetailRow('Class', 'Type ${analysis.type!.name}'),
                  if (analysis.latitude != null && analysis.longitude != null)
                    _buildDetailRow('Location', 'Lat: ${analysis.latitude}°, Lon: ${analysis.longitude}°'),
                  if (analysis.halfAngle != null) _buildDetailRow('Half Angle', '${analysis.halfAngle}°'),
                  if (analysis.note != null && analysis.note!.isNotEmpty)
                    _buildDetailRow('Note', analysis.note!),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr.replaceAll('Z', ''));
      return DateFormat('MMM dd, yyyy - HH:mm UTC').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

}