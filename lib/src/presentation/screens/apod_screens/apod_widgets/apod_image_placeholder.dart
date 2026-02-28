import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

//helper widget banaiye jo sirf loading ke waqt dikhega
Widget buildImagePlaceholder() {
  return Skeletonizer(
    enabled: true,
    effect: const ShimmerEffect(
      baseColor: AppColors.whiteShimmer,
      highlightColor: Colors.white70,
    ),
    child: Container(
      color: AppColors.whiteShimmer, // Skeletonizer is color par effect daalega
      width: double.infinity,
      height: double.infinity,
    ),
  );
}