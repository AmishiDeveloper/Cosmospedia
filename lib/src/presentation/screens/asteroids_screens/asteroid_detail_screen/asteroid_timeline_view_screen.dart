import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_common_models/asteroid_close_approach_model.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_lookup_model.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_close_approach_cubit/close_approach_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_detail_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_timeline_velocity_cubit/asteroid_velocity_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_timeline_views_miss_distance_cubit/miss_distance_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_miss_distance_bar_graph_widget.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_miss_distance_loading_widget.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_velocity_loading_widget.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_velocity_widget.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_approaches_table.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/close_approach_loading_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AsteroidTimelineViewScreen extends StatefulWidget {
  final AsteroidLookUpModel lookupModel;

  const AsteroidTimelineViewScreen({super.key, required this.lookupModel});

  @override
  State<AsteroidTimelineViewScreen> createState() =>
      _AsteroidTimelineViewScreenState();
}

class _AsteroidTimelineViewScreenState
    extends State<AsteroidTimelineViewScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Cubit ki state par nazar rakho
    final mainCubitState = context
        .watch<AsteroidDetailCubit>()
        .state;

    final bool isInitialOrLoading = mainCubitState is AsteroidDetailLoadingState ||
        mainCubitState is AsteroidDetailInitial;

    final bool isError = mainCubitState is AsteroidDetailErrorState;

    // 2. Data check karo (Success state se ya widget se)
    // Hum priority Success state ke data ko denge
    List<CloseApproachDatum> approachData = [];
    if (mainCubitState is AsteroidDetailSuccessState) {
      approachData = mainCubitState.lookupModel.closeApproachData ?? [];
    } else {
      approachData = widget.lookupModel.closeApproachData ?? [];
    }

    final bool haCloseApproachData = approachData.isNotEmpty;

    // final data = widget.lookupModel.closeApproachData ?? [];

    // Agar Error hai toh Widgets dikhao (kyunki widgets ke andar apna error handling logic hai)
    // Agar Loading hai toh Widgets dikhao (kyunki widgets ke andar shimmer hai)
    // Agar Success hai aur Data hai toh Widgets dikhao
    // SIRF tab Empty State dikhao jab API Success ho chuki ho AUR data empty ho.

    bool showEmptyState = mainCubitState is AsteroidDetailSuccessState &&
        !haCloseApproachData;

    if (showEmptyState) {
      return _buildEmptyStateWidget(context);
    }

    return// (haCloseApproachData || isInitialOrLoading)?
       SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: 40.h,
        left: 10.w,
        right: 10.w,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          SizedBox(height: 20.h),

          /// velocity
          BlocBuilder<AsteroidDetailCubit, AsteroidDetailState>(
            builder: (context, mainState) {
              if (mainState is AsteroidDetailLoadingState ||
                  mainState is AsteroidDetailInitial) {
                return asteroidVelocityLoadingWidget();
              }

              if (mainState is AsteroidDetailErrorState) {
                return CustomErrorWidget(
                  errorMessage: mainState.errorMessage,
                  onRetry: () =>
                      context
                          .read<AsteroidDetailCubit>()
                          .fetchAsteroidLookupData(
                          asteroidId: widget.lookupModel.id ?? "0"
                      ),
                );
              }

              if (mainState is AsteroidDetailSuccessState) {
                return BlocProvider(
                  create: (context) =>
                  AsteroidVelocityCubit()
                    ..loadVelocityData(
                        mainState.lookupModel.closeApproachData ?? []),
                  child: BlocBuilder<
                      AsteroidVelocityCubit,
                      AsteroidVelocityState>(
                    builder: (context, velocityState) {
                      if (velocityState is AsteroidVelocityLoadingState) {
                        return asteroidVelocityLoadingWidget();
                      }
                      if (velocityState is AsteroidVelocitySuccessState) {
                        return AsteroidVelocityWidget(
                          closeApproachDatum: velocityState.closeApproachData,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          SizedBox(height: 15.h),

          ///miss distance
          BlocBuilder<AsteroidDetailCubit, AsteroidDetailState>(
            builder: (context, mainState) {
              if (mainState is AsteroidDetailLoadingState ||
                  mainState is AsteroidDetailInitial) {
                return asteroidMissDistanceLoadingWidget();
              }

              if (mainState is AsteroidDetailErrorState) {
                return CustomErrorWidget(
                  errorMessage: mainState.errorMessage,
                  onRetry: () =>
                      context
                          .read<AsteroidDetailCubit>()
                          .fetchAsteroidLookupData(
                          asteroidId: widget.lookupModel.id ?? "0"
                      ),
                );
              }

              if (mainState is AsteroidDetailSuccessState) {
                final data = mainState.lookupModel.closeApproachData ?? [];
                return BlocProvider(
                  create: (context) =>
                  MissDistanceCubit(data.first)
                    ..initializeData(data), // Custom method for loading state
                  child: BlocBuilder<MissDistanceCubit, MissDistanceState>(
                    builder: (context, missState) {
                      if (missState is MissDistanceLoadingState) {
                        return asteroidMissDistanceLoadingWidget();
                      }
                      if (missState is MissDistanceSuccessState) {
                        return AsteroidMissDistanceBarGraphWidget(
                          closeApproachData: data,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          SizedBox(height: 15.h),

          // close approach
          BlocBuilder<AsteroidDetailCubit, AsteroidDetailState>(
            builder: (context, mainState) {
              if (mainState is AsteroidDetailLoadingState ||
                  mainState is AsteroidDetailInitial) {
                return closeApproachLoadingWidget();
              }

              if (mainState is AsteroidDetailErrorState) {
                return CustomErrorWidget(
                  errorMessage: mainState.errorMessage,
                  onRetry: () =>
                      context
                          .read<AsteroidDetailCubit>()
                          .fetchAsteroidLookupData(
                          asteroidId: widget.lookupModel.id ?? "0"
                      ),
                );
              }

              if (mainState is AsteroidDetailSuccessState) {
                final data = mainState.lookupModel.closeApproachData ?? [];
                return BlocProvider(
                  create: (context) =>
                  CloseApproachCubit()
                    ..loadCloseApproachData(data),
                  // Custom method for loading state
                  child: BlocBuilder<CloseApproachCubit, CloseApproachState>(
                    builder: (context, closeApproachState) {
                      if (closeApproachState is CloseApproachLoadingState) {
                        return closeApproachLoadingWidget();
                      }
                      if (closeApproachState is CloseApproachSuccessState) {
                        return AsteroidApproachesTable(
                          closeApproachDatum: data,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

        ],
      ),
    );
  }

  Widget _buildEmptyStateWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_graph_rounded,
              size: 80.h,
              color: AppColors.surfaceLight,
            ),

            SizedBox(height: 20.h),

            Text(
              'NASA hasn\'t calculated the close approach trajectory for this asteroid yet. This usually happens with very recently discovered objects.',
              textAlign: TextAlign.justify,
              style: AppTextStyles.descriptionSmallTextStyle(context),
            ),

          ],
        ),
      ),
    );
  }
}