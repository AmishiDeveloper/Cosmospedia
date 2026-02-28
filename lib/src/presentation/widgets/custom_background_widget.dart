import 'package:cosmospedia/src/core/const/image/app_images.dart';
import 'package:flutter/material.dart';

Widget customBackgroundWidget({required Widget child}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage(
              AppImages.background,
          ),
        fit: BoxFit.cover,
        // colorFilter: ColorFilter.mode(
        //     Colors.black.withOpacity(0.7),
        //     BlendMode.darken,
        // ),
      ),
    ),
    child: child,
  );
}