import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_widgets/asteroid_empty_list_widget.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_widgets/asteroid_horizontal_date_row.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_widgets/asteroid_list_container.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_widgets/asteroid_shimmer_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_error_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AsteroidScreen extends StatefulWidget {
  const AsteroidScreen({super.key});

  @override
  State<AsteroidScreen> createState() {
    return _AsteroidScreenState();
  }
}

class _AsteroidScreenState extends State<AsteroidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: customBackgroundWidget(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppBar(title: 'Asteroids Near Earth'),

              Expanded(
                child: BlocConsumer<AsteroidCubit, AsteroidState>(
                  listener: (context, state) {
                    if (state is AsteroidErrorState) {
                      showCustomSnackBar(
                        context: context,
                        message: state.errorMessage,
                      );
                    }
                  },
                  buildWhen: (previous, current) {
                    return current is AsteroidErrorState ||
                        current is AsteroidLoadingState ||
                        current is AsteroidSuccessState;
                  },
                  builder: (context, state) {
                    final cubit = context.read<AsteroidCubit>();

                    if (state is AsteroidLoadingState ||
                        state is AsteroidInitial) {
                      return AsteroidShimmerWidget();
                    }

                    else if (state is AsteroidErrorState) {
                      return CustomErrorWidget(
                        errorMessage: state.errorMessage,
                        onRetry: () {
                          cubit.retryFetch();
                        },
                      );
                    }

                    else if (state is AsteroidSuccessState) {
                      // Current date ka data nikalna
                      final String dateKey = DateFormat('yyyy-MM-dd').format(state.activeDate);
                      final List? currentAsteroids = state.asteroidData[dateKey];

                      return Column(
                        children: [
                          _buildDateAndFilterContainer(context, cubit),

                          SizedBox(height: 15.h),

                          AsteroidHorizontalDateRow(state: state, cubit: cubit),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child:
                              (currentAsteroids == null ||
                                  currentAsteroids.isEmpty)
                                  ? AsteroidEmptyListWidget()
                                  : ListView.builder(
                                shrinkWrap: true, // Isse list apne content ke barabar height legi
                                itemCount: currentAsteroids.length, //10,
                                key: ValueKey(dateKey), //// Har date ke liye alag key, isse list refresh smooth hogi
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {

                                  final asteroid = currentAsteroids[index]; // Single asteroid nikaala
                                  return AsteroidListContainer(
                                    asteroid:asteroid, // Poora model pass kar diya
                                    //isHazardous: asteroid.isPotentiallyHazardousAsteroid ?? false,
                                  );

                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDateAndFilterContainer(BuildContext context,
      AsteroidCubit cubit,) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Asteroids Explorer',
            style: AppTextStyles.subHeadingLargeStyle(
              context,
            ).copyWith(fontSize: 20.sp),
          ),

          Spacer(),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryDark,
            ),
            child: IconButton(
              onPressed: () {
                cubit.pickStartDate(context);
              },
              icon: Icon(
                Icons.calendar_month_rounded,
                size: 24.h,
                color: AppColors.surfaceLight,
              ),
            ),
          ),

          // SizedBox(width: 10.w),
          //
          // Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: AppColors.primaryDark,
          //   ),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.filter_alt_rounded,
          //       size: 24.h,
          //       color: AppColors.surfaceLight,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
