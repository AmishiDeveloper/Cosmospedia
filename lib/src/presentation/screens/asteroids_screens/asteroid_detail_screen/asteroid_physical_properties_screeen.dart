import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_feed_model.dart';
import 'package:cosmospedia/src/logic/cubits/asteroids_cubits/asteroid_detail_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/animated_orbit_widget.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_radar_chart.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/asteroid_size_comparison.dart';
import 'package:cosmospedia/src/presentation/screens/asteroids_screens/asteroid_detail_screen_widgets/orbit_loading_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AsteroidPhysicalPropertiesScreen extends StatefulWidget {
  final NearEarthObject asteroid;

  const AsteroidPhysicalPropertiesScreen({
    super.key,
    required this.asteroid,
  });

  @override
  State<AsteroidPhysicalPropertiesScreen> createState() =>
      _AsteroidPhysicalPropertiesScreenState();
}

class _AsteroidPhysicalPropertiesScreenState
    extends State<AsteroidPhysicalPropertiesScreen> {
  @override
  Widget build(BuildContext context) {

    // 1. Create a local variable that is safely nullable
    final estimatedDiameter = widget.asteroid.estimatedDiameter;

    return SingleChildScrollView(
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

          AsteroidSizeComparison(asteroid: widget.asteroid),

          //_buildEnhancedSizeComparison(context, widget.asteroid),
          SizedBox(height: 20.h),

          (estimatedDiameter != null)
              ? SizedBox(
                  height: 550.h,
                  child: AsteroidRadarChart(
                    diameter: estimatedDiameter,
                  ),
                )
              :
                // Graceful handling if data is missing
                SizedBox(
                  height: 550.h,
                  child: Center(
                    child: Text(
                      "Diameter data not available for this object",
                      style: AppTextStyles.headingSmallStyle(context),
                    ),
                  ),
                ),

          SizedBox(height: 20.h),


          BlocConsumer<AsteroidDetailCubit, AsteroidDetailState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            buildWhen: (previous, current) =>
                current is AsteroidDetailLoadingState ||
                current is AsteroidDetailErrorState ||
                current is AsteroidDetailSuccessState,
            builder: (context, state) {
              if (state is AsteroidDetailLoadingState) {
                return orbitLoadingWidget();
              } else if (state is AsteroidDetailErrorState) {
                return CustomErrorWidget(
                  errorMessage: state.errorMessage,
                  onRetry: () {
                    context.read<AsteroidDetailCubit>().fetchAsteroidLookupData(
                      asteroidId: widget.asteroid.id ?? "0",
                    ); // int.tryParse(widget.asteroid.id??'0')??0
                  },
                );
              } else if (state is AsteroidDetailSuccessState) {
                return AnimatedOrbitWidget(
                  eccentricity:
                      double.tryParse(
                        state.lookupModel.orbitalData?.eccentricity ?? '0',
                      ) ??
                      0.0,
                  semiMajorAxis:
                      double.tryParse(
                        state.lookupModel.orbitalData?.semiMajorAxis ?? '0',
                      ) ??
                      0.0,
                  isHazardous:
                      state.lookupModel.isPotentiallyHazardousAsteroid ?? false,
                  asteroidName: state.lookupModel.name ?? "Unknown",
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

}
