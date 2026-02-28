import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_feed_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';

/*1. Unit Conversion ka Logic: Aapne bilkul sahi kaha ki chahe units alag hon
(KM, Miles, Feet), asli asteroid ka size (physical distance) toh utna hi hai.
Agar hum ek hi scale (jaise sirf 0-1000 ki ginti) par sabko rakhenge, toh
Feet wala point sabse bahar nikal jayega aur Miles/KM wale points itne chote
honge ki dikhenge hi nahi (Negligible ho jayenge). Isse graph "Irregular" aur bekar dikhega.

2. Relative Scale (Percentage) ka Logic: Aapne sahi pakda ki humein har unit ke
liye "Max Diameter" ko hi "End of the Scale" maan lena chahiye.
Matlab, agar Max Diameter 2 KM hai, toh wahi hamare liye KM axis ka "100%" hai.
Agar Max Diameter 1000 Feet hai, toh wahi hamare liye Feet axis ka "100%" hai.
Isse fayda ye hoga ki chahe unit koi bhi ho, Max Diameter hamesha chart ke sabse
bahar wale kone (End point) par hi aayega.

3. Min aur Max ka Relation: Aapka ye point ki "Min Diameter kahan lie karega" sabse zaruri hai.
Jab Max hamesha 100% par hoga aur Min uske hisab se plot hoga (jaise 1 KM vs 2 KM = 50%),
toh chart par ek Uniform Polygon banega.Ye polygon user ko ye batayega ki asteroid ke Min
aur Max size mein kitna gap hai, na ki ye ki Feet aur KM mein kitna gap hai.

4. Asteroid ke Size ki Limitation: Aapne bilkul sahi kaha ki hum koi fixed scale (jaise 1000) nahi rakh sakte kyunki koi asteroid chota hota hai aur koi bahut bada. Agar humne scale fix kar di, toh bada asteroid graph ke bahar chala jayega. Isiliye Max Diameter ko hi scale ki limit maan lena sabse best tarika hai.

Summary:

Max Diameter = Scale ka aakhri point (100% ya 1.0).

Min Diameter = Max ke mukable kitna hai (Min / Max).

Isse har asteroid ka chart ek jaisa (Uniform) dikhega, aur user ko units ki confusion nahi hogi.
*/

class AsteroidRadarChart extends StatelessWidget {
  final EstimatedDiameter diameter;

  const AsteroidRadarChart({super.key, required this.diameter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade900.withOpacity(0.4), //drawerHeaderGradient.withOpacity(0.4),//splashBlueBackground, drawerHeader
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greyShimmerShade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radar, color: AppColors.surfaceLight, size: 20.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'Diameter in different Units',
                  style: AppTextStyles.headingSmallStyle(context),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),

          Divider(color: AppColors.greyShimmerShade100, height: 25.h),

          SizedBox(height: 5.h),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:15.w,vertical: 5.h),
              child:
                  // RadarChart(
                  //   RadarChartData(
                  //     radarShape: RadarShape.polygon,
                  //     radarBorderData: const BorderSide(color: AppColors.surfaceLight,width: 1),
                  //     // 0.2 ka matlab hai text ko chart ke center ki taraf 20% move karna
                  //     //titlePositionPercentageOffset: 0.2,
                  //
                  //     getTitle: (index,angle) {
                  //       // Units names for axes
                  //       const titles = ['KM', 'Meters', 'Miles', 'Feet'];
                  //       return RadarChartTitle(
                  //           text: titles[index],
                  //           angle: 0,
                  //       );
                  //     },
                  //     titleTextStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
                  //
                  //     // --- GRID LINES (Black/Grey circles) ---
                  //     gridBorderData: BorderSide(
                  //       color: AppColors.black.withOpacity(0.9),
                  //       width: 1,
                  //     ),
                  //
                  //     // Grid aur Lines ka code
                  //     //gridBorderData: BorderSide(color: Colors.black.withOpacity(0.5), width: 1.5),
                  //     // --- TICK COUNT (Kitni lines dikhani hain) ---
                  //     tickCount: 4, // Yeh wo andar ki black lines create karega
                  //     tickBorderData: BorderSide(
                  //       color: AppColors.black,
                  //       width: 1,
                  //     ),
                  //     ticksTextStyle: const TextStyle(color: Colors.transparent), // Values chhupane ke liye
                  //
                  //
                  //     dataSets: [
                  //       // MAXIMUM DIAMETER LAYER (Redish/Purple)
                  //       RadarDataSet(
                  //         fillColor: AppColors.error.withOpacity(0.2),
                  //         borderColor: AppColors.error,
                  //         entryRadius: 4,//Isse points bade ho jayenge
                  //         dataEntries: [
                  //           RadarEntry(
                  //             value: _normalize(
                  //               diameter.kilometers?.estimatedDiameterMax ?? 0,
                  //               5,
                  //             ),
                  //           ),
                  //           RadarEntry(
                  //             value: _normalize(
                  //               diameter.meters?.estimatedDiameterMax ?? 0,
                  //               5000,
                  //             ),
                  //           ),
                  //           RadarEntry(
                  //             value: _normalize(
                  //               diameter.miles?.estimatedDiameterMax ?? 0,
                  //               3,
                  //             ),
                  //           ),
                  //           RadarEntry(
                  //             value: _normalize(
                  //               diameter.feet?.estimatedDiameterMax ?? 0,
                  //               15000,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       // MINIMUM DIAMETER LAYER (Light Blue/Cyan)
                  //       RadarDataSet(
                  //         fillColor: AppColors.primaryDark.withOpacity(0.2),
                  //         borderColor: AppColors.primaryDark,
                  //         entryRadius: 4,
                  //         dataEntries: [
                  //           RadarEntry(
                  //             value: _normalize(
                  //               diameter.kilometers?.estimatedDiameterMin ?? 0,
                  //               5,
                  //             ),
                  //           ),
                  //           RadarEntry(
                  //             value: _normalize(
                  //               diameter.meters?.estimatedDiameterMin ?? 0,
                  //               5000,
                  //             ),
                  //           ),
                  //           RadarEntry(
                  //             value: _normalize(
                  //               diameter.miles?.estimatedDiameterMin ?? 0,
                  //               3,
                  //             ),
                  //           ),
                  //           RadarEntry(
                  //             value: _normalize(
                  //               diameter.feet?.estimatedDiameterMin ?? 0,
                  //               15000,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      // Text ko container ke thoda andar lane ke liye
                      //titlePositionPercentageOffset: 0.15,

                      // Titles ko seedha (horizontal) dikhane ke liye angle 0
                      getTitle: (index, angle) {
                        const titles = ['KM', 'Meters', 'Miles', 'Feet'];
                        return RadarChartTitle(
                            text: titles[index],
                            angle: 0,
                        );
                      },

                      titleTextStyle: AppTextStyles.headingSmallStyle(context).copyWith(fontSize: 12.sp),

                      // Black grid lines jaisa aapne manga tha
                      gridBorderData: BorderSide(
                        color: AppColors.black.withOpacity(0.9),
                        width: 1.5,
                      ),
                      // --- TICK COUNT (Kitni lines dikhani hain) ---
                      tickCount: 5,
                      tickBorderData: BorderSide(
                        color: AppColors.black,
                        width: 1,
                      ),
                      ticksTextStyle: AppTextStyles.headingSmallStyle(context).copyWith(color:Colors.transparent),

                      dataSets: [
                        // 1. MAXIMUM DIAMETER LAYER (Yeh hamesha full polygon banayega)
                        RadarDataSet(
                          fillColor: AppColors.error.withOpacity(0.2),
                          borderColor: AppColors.error,
                          entryRadius: 4,
                          borderWidth: 2,
                          dataEntries: const [
                            RadarEntry(value: 1.0), // 100% of Max KM
                            RadarEntry(value: 1.0), // 100% of Max Meters
                            RadarEntry(value: 1.0), // 100% of Max Miles
                            RadarEntry(value: 1.0), // 100% of Max Feet
                          ],
                        ),

                        // 2. MINIMUM DIAMETER LAYER (Yeh Max ke mukable dikhega)
                        RadarDataSet(
                          fillColor: AppColors.primaryDark.withOpacity(0.2),
                          borderColor: AppColors.primaryDark,
                          entryRadius: 4,
                          // Points ko thoda bada rakha hai
                          borderWidth: 2,
                          dataEntries: [
                            RadarEntry(
                              value: getNormalizedMin(
                                diameter.kilometers?.estimatedDiameterMin?? 0.0,
                                diameter.kilometers?.estimatedDiameterMax ?? 0.0,
                              ),
                            ),
                            RadarEntry(
                              value: getNormalizedMin(
                                diameter.meters?.estimatedDiameterMin ?? 0.0,
                                diameter.meters?.estimatedDiameterMax ?? 0.0,
                              ),
                            ),
                            RadarEntry(
                              value: getNormalizedMin(
                                diameter.miles?.estimatedDiameterMin ?? 0.0,
                                diameter.miles?.estimatedDiameterMax ?? 0.0,
                              ),
                            ),
                            RadarEntry(
                              value: getNormalizedMin(
                                diameter.feet?.estimatedDiameterMin ?? 0.0,
                                diameter.feet?.estimatedDiameterMax ?? 0.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            ),
          ),

          SizedBox(height: 16.h),

          Table(
            border: TableBorder.all(
                color: AppColors.greyShimmerShade400,
                borderRadius: BorderRadius.circular(5.r),
            ),
            children: [
              TableRow(
                decoration:  BoxDecoration(color: AppColors.textPrimaryDark.withOpacity(0.1)),
                children: [
                  _buildTableHeader(context,'Unit'),
                  _buildTableHeader(context,'Minimum'),
                  _buildTableHeader(context,'Maximum'),
                ],
              ),
              _buildTableRow(context,'Kilometers',  diameter.kilometers?.estimatedDiameterMin?.toStringAsFixed(2),
                  diameter.kilometers?.estimatedDiameterMax?.toStringAsFixed(2)),
              _buildTableRow(context,'Miles', diameter.miles?.estimatedDiameterMin?.toStringAsFixed(2),
                  diameter.miles?.estimatedDiameterMax?.toStringAsFixed(2)),
              _buildTableRow(context,'Meters', diameter.meters?.estimatedDiameterMin?.toStringAsFixed(2),
                  diameter.meters?.estimatedDiameterMax?.toStringAsFixed(2)),
              _buildTableRow(context,'Feet', diameter.feet?.estimatedDiameterMin?.toStringAsFixed(2),
                  diameter.feet?.estimatedDiameterMax?.toStringAsFixed(2)),
            ],
          ),

          SizedBox(height: 10.h),

          // --- Legend ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendRow(AppColors.primaryDark, 'Min Diameter'),
              SizedBox(width: 20.w),
              _buildLegendRow(AppColors.error, 'Max Diameter'),
            ],
          ),

        ],
      ),
    );
  }

  // // Normalization helper: Taaki chart ke bahar na jaye data
  // double _normalize(double value, double maxRange) {
  //   if (value == 0) return 0;
  //   return (value / maxRange) * 10; // 0 to 10 ke scale par map kar rahe hain
  // }

  // Aapka Logic: Min ko Max se divide karke percentage nikalna
  // Isse har axis par Max hamesha 1.0 (100%) rahega and min 100% ke andar lie karega

  double getNormalizedMin(double? min, double? max) {
    if (min == null || max == null || max == 0) return 0;
    return min / max; // Ratio hamesha 0 aur 1 ke beech rahega
  }

  Widget _buildTableHeader(BuildContext context,String text) {
    return Padding(
      padding:  EdgeInsets.all(8.h),
      child: Text(
        text,
        style:  AppTextStyles.headingMediumStyle(context).copyWith(fontSize: 16.sp),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context,String unit, String? min, String? max) {
    return TableRow(
      children: [
        Padding(
          padding:  EdgeInsets.all(8.h),
          child: Text(
            unit,
            style:  AppTextStyles.headingMediumStyle(context).copyWith(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Text(
            min??"",
            style: AppTextStyles.headingMediumStyle(context).copyWith(color:AppColors.primaryDark,fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Text(
            max??"",
            style: AppTextStyles.headingMediumStyle(context).copyWith(color:AppColors.error,fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendRow(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(color: AppColors.surfaceLight, fontSize: 14.sp),
        ),
      ],
    );
  }

}
