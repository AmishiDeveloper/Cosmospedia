import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AsteroidHorizontalDateRow extends StatelessWidget{

final AsteroidSuccessState state;
final AsteroidCubit cubit;

const AsteroidHorizontalDateRow({super.key, required this.state, required this.cubit});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: state.rangeDates.length,
        itemBuilder: (context, index) {
          DateTime date = state.rangeDates[index];
          // Formatting for UI
          String dayName = DateFormat('EEE').format(date); // Mon, Tue...
          //String monthName = DateFormat('MMM').format(date); // Jan, Feb...
          String dayNumber = DateFormat('dd').format(date); // 23, 24...

          bool isSelected =
              date.day == state.activeDate.day &&
                  date.month ==
                      state
                          .activeDate
                          .month; //checks if active date is equal to the date of the horizontal list date.day == state.activeDate.day

          return GestureDetector(
            onTap: () => cubit.changeActiveDate(date),
            child: Container(
              width: 55.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.surfaceLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.surfaceLight
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: AppTextStyles.descriptionSmallTextStyle(context)
                        .copyWith(
                      color: isSelected
                          ? AppColors.surfaceLight
                          : AppColors.greyShimmerShade400,
                    ),
                  ),
                  Text(
                    dayNumber,
                    style: AppTextStyles.subHeadingLargeStyle(
                      context,
                    ).copyWith(fontSize: 18.sp),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}