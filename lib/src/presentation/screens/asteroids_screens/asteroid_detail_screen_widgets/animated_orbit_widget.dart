import 'dart:math' as math;
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedOrbitWidget extends StatefulWidget {
  final double eccentricity; // API se: orbital_data.eccentricity
  final double semiMajorAxis; // API se: orbital_data.semi_major_axis
  final bool isHazardous;
  final String asteroidName;

  const AnimatedOrbitWidget({
    super.key,
    required this.eccentricity,
    required this.semiMajorAxis,
    required this.isHazardous,
    required this.asteroidName,
  });

  @override
  State<AnimatedOrbitWidget> createState() => _AnimatedOrbitWidgetState();
}

class _AnimatedOrbitWidgetState extends State<AnimatedOrbitWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animation ki speed: 20 seconds mein ek chakkar
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              width: constraints.maxWidth,
              height: 570.h,
              padding: EdgeInsets.all(16.h),
              //drawerHeaderGradient.withOpacity(0.4),
              //splashBlueBackground, drawerHeader
              decoration: BoxDecoration(
                color: AppColors.greyShimmerShade900.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.greyShimmerShade400),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Header ---
                  Row(
                    children: [
                      Icon(
                        Icons.track_changes_rounded,
                        color: AppColors.surfaceLight,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Orbit Visualization',
                        style: AppTextStyles.headingSmallStyle(context),
                      ),
                    ],
                  ),

                  Divider(color: AppColors.greyShimmerShade100, height: 10.h),

                  // SizedBox(height: 5.h),

                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: OrbitPainter(
                          eccentricity: widget.eccentricity,
                          semiMajorAxis: widget.semiMajorAxis,
                          isHazardous: widget.isHazardous,
                          asteroidName: widget.asteroidName,
                          animationValue: _controller.value,
                        ),
                        size: Size(constraints.maxWidth, 350),
                      );
                    },
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendRow(context,Colors.blue, 'Earth\'s Orbit'),
                         SizedBox(width: 24.w),
                        _buildLegendRow(context,
                          widget.isHazardous
                              ? AppColors.error
                              : AppColors.success,
                          '${widget.asteroidName} Orbit',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.isHazardous
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.isHazardous
                            ? Colors.red.withOpacity(0.3)
                            : Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isHazardous
                              ? Icons.warning_amber
                              : Icons.check_circle,
                          color: widget.isHazardous
                              ? AppColors.error.withOpacity(0.3)
                              : AppColors.success.withOpacity(0.3),
                          size: 36.h,
                        ),
                        SizedBox(width: 12.w),
                        Flexible(
                          // Added Flexible here
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isHazardous
                                    ? 'Potentially Hazardous Asteroid'
                                    : 'Non-Hazardous Asteroid',
                                style: AppTextStyles.headingSmallStyle(
                                 context).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.isHazardous
                                    ? 'This asteroid\'s orbit intersects Earth\'s orbit path and it is large enough to cause significant damage if impact occurs.'
                                    : 'This asteroid\'s orbit does not currently pose a threat to Earth.',
                                style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmerShade100),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Legend aur Warning Box aapka pehle wala hi rahega...
          ],
        );
      },
    );
  }
  Widget _buildLegendRow(BuildContext context,Color color, String label) {
    return Row(
      children:[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.5.h),
          decoration: BoxDecoration(
            color: color,//AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(2.r),
            //border: Border.all(color: Colors.blue.withOpacity(0.4)),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          label,//'Asteroid',
          style: AppTextStyles.headingSmallStyle(
            context,
          ).copyWith(fontSize: 12.sp),
        ),
      ],
    );
  }
}

class OrbitPainter extends CustomPainter {
  final double eccentricity;
  final double semiMajorAxis;
  final bool isHazardous;
  final String asteroidName;
  final double animationValue;

  OrbitPainter({
    required this.eccentricity,
    required this.semiMajorAxis,
    required this.isHazardous,
    required this.asteroidName,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Container ke andar hi rahe, isliye ClipRect zaroori hai
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final center = Offset(size.width / 2, size.height / 2);
    final double rotationAngle = 0.5; // Fixed rotation for both ellipse and point

    // 2. DYNAMIC AUTO-FIT SCALING (Ye sabse important hai)
    // Hum check karenge ki asteroid ka sabse door wala point (Aphelion) kitna bada hai
    double aphelion = semiMajorAxis * (1 + eccentricity);
    // Agar asteroid Earth se chota hai, toh Earth (1.0) ko base maano, warna asteroid ko
    double maxOrbitalDistance = math.max(1.1, aphelion);

    // Available space ka 40% (0.4) use karenge taki padding bachi rahe
    double scale =
        (math.min(size.width, size.height) * 0.45) / maxOrbitalDistance;

    final double earthRadius = 1.0 * scale;
    final double a = semiMajorAxis * scale;
    final double b =
        a * math.sqrt(1 - math.pow(eccentricity.clamp(0.0, 0.99), 2));
    final double focusOffset = a * eccentricity;

    // --- 1. SUN GLOW EFFECT ---
    final glowPaint = Paint()
      ..color = AppColors.yellow.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
    canvas.drawCircle(center, 25, glowPaint);

    // --- Paint Styles ---
    final sunPaint = Paint()..color = AppColors.yellow;

    final earthOrbitPaint = Paint()
      ..color = AppColors.primaryDark.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final asteroidOrbitPaint = Paint()
      ..color = isHazardous ? AppColors.error: AppColors.success
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 3. DRAW SUN and glow
    //canvas.drawCircle(center, 25, sunGlowPaint);
    canvas.drawCircle(center, 14, sunPaint);

    // 4. DRAW EARTH ORBIT
    canvas.drawCircle(center, earthRadius, earthOrbitPaint);

    // 5. DRAW ASTEROID ORBIT
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    // Sun focus par rahe, isliye center shift (-focusOffset)
    Rect asteroidRect = Rect.fromCenter(
      center: Offset(-focusOffset, 0),
      width: a * 2,
      height: b * 2,
    );
    canvas.drawOval(asteroidRect, asteroidOrbitPaint);
    canvas.restore();

    // 6. ANIMATED POSITIONS
    // Earth Position
    double earthAngle = 2 * math.pi * animationValue;
    Offset earthPos = Offset(
      center.dx + earthRadius * math.cos(earthAngle),
      center.dy + earthRadius * math.sin(earthAngle),
    );
    canvas.drawCircle(earthPos, 8, Paint()..color = AppColors.primaryDark);

    // Asteroid Position Logic
    double astAngle = 2 * math.pi * animationValue;
    // Local coordinates (relative to focus/Sun)
    double localX = a * math.cos(astAngle) - focusOffset;
    double localY = b * math.sin(astAngle);

    // Apply rotation to the point manually
    double rotatedX =
        center.dx +
        (localX * math.cos(rotationAngle) - localY * math.sin(rotationAngle));
    double rotatedY =
        center.dy +
        (localX * math.sin(rotationAngle) + localY * math.cos(rotationAngle));
    Offset asteroidPos = Offset(rotatedX, rotatedY);

    canvas.drawCircle(
      asteroidPos,
      6,
      Paint()..color = isHazardous ? AppColors.error : AppColors.greyShimmer,
    );

    // 7. LABELS WITH BACKGROUND
    // Sun Label
    _drawLabelWithBg(
      canvas,
      "Sun",
      Offset(center.dx, center.dy + 28),
      Colors.yellow.withOpacity(0.4),
    );
    // Earth Label
    _drawLabelWithBg(
      canvas,
      "Earth",
      Offset(earthPos.dx, earthPos.dy + 15),
      Colors.blue.withOpacity(0.4),
    );
    // Asteroid Label
    Color astLabelColor = isHazardous
        ? AppColors.error.withOpacity(0.5)
        : AppColors.success.withOpacity(0.5);
    _drawLabelWithBg(
      canvas,
      asteroidName,
      Offset(asteroidPos.dx, asteroidPos.dy + 15),
      astLabelColor,
    );
  }

  void _drawLabelWithBg(Canvas canvas, String text, Offset pos, Color bgColor) {
    // 1. Text ko layout karna taaki width/height mil sake
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColors.surfaceLight,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // 2. Background box ke liye dimensions (Text + padding)
    final rect = Rect.fromCenter(
      center: pos,
      width: tp.width + 12, // Width padding
      height: tp.height + 6, // Height padding
    );

    // 3. Rounded Rectangle draw karna
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(6)),
      Paint()..color = bgColor,
    );

    // 4. Text ko box ke center mein paint karna
    tp.paint(canvas, Offset(pos.dx - (tp.width / 2), pos.dy - (tp.height / 2)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// class OrbitPainter extends CustomPainter {
//   final double eccentricity;
//   final double semiMajorAxis;
//   final bool isHazardous;
//   final String asteroidName;
//   final double animationValue;
//
//   OrbitPainter({
//     required this.eccentricity,
//     required this.semiMajorAxis,
//     required this.isHazardous,
//     required this.asteroidName,
//     required this.animationValue,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//
//     // 1. Container ke andar hi rahe, isliye ClipRect zaroori hai
//     canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
//
//     final center = Offset(size.width / 2, size.height / 2);
//     final double rotationAngle = 0.5; // Fixed rotation for both ellipse and point
//
//     // 1. DYNAMIC AUTO-FITSCALING: Container ke andar fit karne ke liye
//     // Earth ko 1 AU manke scale kar rahe hain
//     double baseScale = math.min(size.width, size.height) * 0.35;
//
//     // // 1. SCIENTIFIC SCALING:
//     // // Earth's orbit radius hum base maante hain (1 AU approx)
//     // final double earthRadius = math.min(size.width, size.height) * 0.35;
//
//     // // Asteroid ki radii calculate karna (Real Math)
//     // // Semi-minor axis (b) = a * sqrt(1 - e^2)
//     // final double a =
//     //     earthRadius *
//     //     (semiMajorAxis > 2 ? 1.5 : semiMajorAxis); // Scale adjust for UI
//     // final double b = a * math.sqrt(1 - math.pow(eccentricity, 2));
//
//     // Agar semiMajorAxis bada hai toh orbit ko scale down karo
//     double scaleFactor = 1.0;
//     if (semiMajorAxis > 1.5) {
//       scaleFactor = 1.5 / semiMajorAxis;
//     }
//
//     // // Focus offset (Sun center mein nahi, focus par hota hai)
//     // final double focusOffset = a * eccentricity;
//
//     final double earthRadius = baseScale * scaleFactor;
//     final double a = (baseScale * semiMajorAxis) * scaleFactor;
//     final double b = a *
//         math.sqrt(1 - math.pow(eccentricity.clamp(0.0, 0.99), 2));
//     final double focusOffset = a * eccentricity;
//
//     // --- Paint Objects ---
//     final sunPaint = Paint()
//       ..color = Colors.yellow;
//     final earthOrbitPaint = Paint()
//       ..color = Colors.blue.withOpacity(0.5)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;
//
//     final asteroidOrbitPaint = Paint()
//       ..color = isHazardous ? Colors.red : Colors.green
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//
//     // 2. DRAW SUN (At Focus)
//     canvas.drawCircle(center, 10, sunPaint);
//
//     // 3. DRAW EARTH ORBIT
//     canvas.drawCircle(center, earthRadius, earthOrbitPaint);
//
//     // 4. DRAW ASTEROID ORBIT (Elliptical)
//     canvas.save();
//     canvas.translate(center.dx, center.dy);
//     // Rotation thoda random ya API ke inclination se le sakte hain
//     canvas.rotate(0.5);//(isHazardous ? 0.5 : 0.8);
//
//
//     // Rect asteroidRect = Rect.fromCenter(
//     //   center: Offset.zero,
//     //   width: a * 2,
//     //   height: b * 2,
//     // );
//
//     // Ellipse center shift karna padega taki Sun focus par rahe
//     Rect asteroidRect = Rect.fromCenter(
//         center: Offset(-focusOffset, 0), width: a * 2, height: b * 2);
//     canvas.drawOval(asteroidRect, asteroidOrbitPaint);
//     canvas.restore();
//
//     // canvas.translate(center.dx, center.dy); // Drawing at translated center
//     // canvas.drawOval(asteroidRect, asteroidOrbitPaint);
//     // canvas.restore();
//
//     // 5. ANIMATED POSITIONS (Earth & Asteroid)
//     // Earth Position
//     double earthAngle = 2 * math.pi * animationValue;
//     Offset earthPos = Offset(
//       center.dx + earthRadius * math.cos(earthAngle),
//       center.dy + earthRadius * math.sin(earthAngle),
//     );
//     canvas.drawCircle(earthPos, 6, Paint()
//       ..color = Colors.blue);
//
//     // Asteroid Position (Simplified Elliptical Motion)
//     double astAngle = 2 * math.pi * animationValue;
//     // X and Y formula for ellipse with focus at origin
//     //// Offset astPos = Offset(
//     ////   center.dx + a * math.cos(astAngle) - focusOffset,
//     ////   center.dy + b * math.sin(astAngle),
//     //// );
//     double astX = center.dx + (a * math.cos(astAngle) - focusOffset);
//     double astY = center.dy + (b * math.sin(astAngle));
//
//     // Rotate point logic (kyunki orbit rotate kiya hai)
//     double angle = 0.5;
//     double rotatedX = center.dx + (astX - center.dx) * math.cos(angle) -
//         (astY - center.dy) * math.sin(angle);
//     double rotatedY = center.dy + (astX - center.dx) * math.sin(angle) +
//         (astY - center.dy) * math.cos(angle);
//
//     // canvas.drawCircle(
//     //   astPos,
//     //   6,
//     //   Paint()..color = isHazardous ? Colors.red : Colors.grey,
//     // );
//
//     canvas.drawCircle(Offset(rotatedX, rotatedY), 5, Paint()
//       ..color = isHazardous ? Colors.red : Colors.blue);
//   }
//     // // 6. LABELS (With Substring Fix)
//     // String displayName = asteroidName.length > 12
//     //     ? "${asteroidName.substring(0, 12)}..."
//     //     : asteroidName;
//     //
//     // _drawLabel(canvas, "Earth", earthPos);
//     // _drawLabel(canvas, displayName, astPos);
//
//   void _drawLabel(Canvas canvas, String text, Offset pos) {
//     TextPainter(
//         text: TextSpan(
//           text: text,
//           style: const TextStyle(color: Colors.white, fontSize: 10),
//         ),
//         textDirection: TextDirection.ltr,
//       )
//       ..layout()
//       ..paint(canvas, Offset(pos.dx + 10, pos.dy + 10));
//   }
//
//   @override
//   // True taaki animation ke har frame par redraw ho
//   bool shouldRepaint(OrbitPainter oldDelegate) => true;
// }
