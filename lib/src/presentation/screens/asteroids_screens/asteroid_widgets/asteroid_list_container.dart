import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_feed_model.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_detail_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen/asteroid_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AsteroidListContainer extends StatelessWidget {
  final double? width;
  //final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? radius;
  final Widget? child;
 // final bool isHazardous;
  final NearEarthObject asteroid;

  const AsteroidListContainer({
    super.key,
    this.width,
    //this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.radius,
    this.child,
    //required this.isHazardous,
    required this.asteroid,
  });

  @override
  Widget build(BuildContext context) {
    final String? minEstDiameter = asteroid
        .estimatedDiameter
        ?.kilometers
        ?.estimatedDiameterMin
        ?.toStringAsFixed(2);
    final String? maxEstDiameter = asteroid
        .estimatedDiameter
        ?.kilometers
        ?.estimatedDiameterMax
        ?.toStringAsFixed(2);
    final String missDistance =
        double.tryParse(
          asteroid.closeApproachData?[0].missDistance?.kilometers ?? '0.00',
        )?.toStringAsFixed(2) ??
        '0.00';
    final String relativeVelocity =
        double.tryParse(
          asteroid
                  .closeApproachData?[0]
                  .relativeVelocity
                  ?.kilometersPerSecond ??
              '0.00',
        )?.toStringAsFixed(2) ??
        '0.00';
    final String closestDate = DateFormat(
      'dd-MM-yyyy',
    ).format(asteroid.closeApproachData![0].closeApproachDate!);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          AppRoute.slide(
            BlocProvider(
              create: (context) => AsteroidDetailCubit(),
              child: AsteroidDetailScreen(
                asteroidId: asteroid.id ?? "",
                name: asteroid.name ?? "",
                isHazardous: asteroid.isPotentiallyHazardousAsteroid ?? false,
                asteroid: asteroid,
              ),
            ),
          ),
        );
      },
      child: Container(
        //height: height ?? double.infinity,
        width: width ?? double.infinity,
        padding:
            padding ?? EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        margin: margin ?? EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.cardDark.withOpacity(0.6),
          border: Border.all(color: borderColor ?? AppColors.surfaceLight),
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: AppColors.primaryDark,
                //   ),
                //   child:  Icon(
                //       Icons.language,
                //       size: 20.h,
                //       color: AppColors.surfaceLight,
                //     ),
                // ),
                CircleAvatar(
                  backgroundColor: AppColors.primaryDark,
                  radius: 25.r,
                  child: Icon(
                    Icons.language,
                    size: 45.h,
                    color: AppColors.surfaceLight,
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        asteroid.name ?? '1620 Geographos (1951 RA)',
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headingMediumStyle(context),
                      ),

                      //SizedBox(height: 5.h),
                      Text(
                        asteroid.id ?? '1620',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.descriptionMediumTextStyle(
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Divider(color: AppColors.textPrimaryDark, height: 20.h),

            _buildInfoRow(
              context: context,
              title: 'Diameter',
              value:
                  '${minEstDiameter ?? "0"}-${maxEstDiameter ?? "0"} km' ??
                  '2.36 - 5.27 km',
            ),

            SizedBox(height: 5.h),

            // _buildInfoRow(
            //   context: context,
            //   title: 'Absolute Magnitude',
            //   value: '15.26',
            // ),
            //
            // SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Potentially Hazardous',
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.descriptionMediumTextStyle(context),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: asteroid.isPotentiallyHazardousAsteroid ?? false
                        ? AppColors.error
                        : AppColors.success,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    asteroid.isPotentiallyHazardousAsteroid ?? false
                        ? 'Yes'
                        : 'No',
                    style: AppTextStyles.descriptionMediumTextStyle(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.h),
              decoration: BoxDecoration(
                color:
                    backgroundColor ?? AppColors.surfaceLight.withOpacity(0.3),
                border: Border.all(
                  color: borderColor ?? AppColors.surfaceLight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.r)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Closest Approach',
                    textAlign: TextAlign.start,
                    style: AppTextStyles.descriptionLargeTextStyle(context),
                  ),

                  SizedBox(height: 7.h),

                  _buildInfoRow(
                    context: context,
                    title: 'Date',
                    value: closestDate, //'11-10-1907',
                  ),

                  SizedBox(height: 5.h),

                  _buildInfoRow(
                    context: context,
                    title: 'Distance',
                    //Matlab, us specific date par yeh asteroid dharti ke sabse zyada kareeb itni doori par tha.
                    value: '$missDistance km',
                  ),

                  SizedBox(height: 5.h),

                  _buildInfoRow(
                    context: context,
                    title: 'Relative Velocity',
                    value: '$relativeVelocity km/s',
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.descriptionMediumTextStyle(context)),

        Text(
          value,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.descriptionMediumTextStyle(context),
        ),
      ],
    );
  }
}
