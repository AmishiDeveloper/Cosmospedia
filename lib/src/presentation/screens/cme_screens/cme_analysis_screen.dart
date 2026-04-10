import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CmeAnalysisScreen extends StatelessWidget {
  final List<CmeAnalysisModel> analysisData;
  const CmeAnalysisScreen({super.key, required this.analysisData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          // Yahan aapke Velocity Graphs ya Speed graphs aayenge
          // analysisData.speed ya analysisData.type use karke
          Text("Impact Prediction Charts", style: AppTextStyles.headingSmallStyle(context)),
          //
        ],
      ),
    );
  }
}