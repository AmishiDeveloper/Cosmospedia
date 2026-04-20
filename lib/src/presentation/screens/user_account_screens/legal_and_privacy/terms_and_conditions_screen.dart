import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTermsContent(context),
    );
  }

  Widget _buildTermsContent(BuildContext context) {
    return customBackgroundWidget(
      child: SafeArea(
        child: Column(
          children: [

            Stack(
              children: [
                // 1. Back Button (Left mein fix rahega)
                Positioned(
                  left: 8.w,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.surfaceLight),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // 2. Title (Screen ke ekdum center mein)
                Center(
                  child: CustomAppBar(title: 'Terms & Conditions'),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.purple.withOpacity(0.3), AppColors.info.withOpacity(0.3)],
                ),
                //AppColors.surfaceLight.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
                border: Border.all(color: AppColors.surfaceLight.withOpacity(0.4))
              ),
              child: Center(
                child: Text(
                  'Cosmospedia Terms',
                  style: AppTextStyles.subHeadingLargeStyle(
                    context,
                  ).copyWith(fontSize: 20.sp),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _buildTermsSection(
                    context,
                    '1. Introduction',
                    'Welcome to the CosmosPedia mobile application (hereinafter referred to as the "App"), developed and maintained by CosmosPedia. These Terms and Conditions ("Terms") govern your access to and use of the App. By accessing, installing, or using the App, you agree to be bound by these Terms. We encourage you to read them carefully.',
                    Icons.info_outline,
                    AppColors.info,
                  ),
                  _buildTermsSection(
                    context,
                    '2. Acceptance of Terms',
                    'By downloading, installing, or using the App, you acknowledge and affirm that you have read, understood, and agree to comply with these Terms in full. If you do not agree with any part of these Terms, you must refrain from using the App.',
                    Icons.check_circle_outline,
                    AppColors.success,
                  ),
                  _buildTermsSection(
                    context,
                    '3. License and Permitted Use',
                    'CosmosPedia grants you a limited, revocable, non-exclusive, non-transferable, and non-sublicensable license to use the App strictly for personal, non-commercial purposes, subject to these Terms. You agree not to exploit the App or its content for any unlawful, unauthorized, or prohibited activity.',
                    Icons.verified_user_outlined,
                    AppColors.cyan,
                  ),
                  _buildTermsSection(
                    context,
                    '4. User Accounts',
                    'Certain functionalities of the App may require you to register an account. You are solely responsible for maintaining the confidentiality and security of your account credentials and for all activities that occur under your account. You agree to promptly notify us of any unauthorized access or security breaches related to your account.',
                    Icons.person_outline,
                    AppColors.orange,
                  ),
                  _buildTermsSection(
                    context,
                    '5. Content Disclaimer',
                    'All content presented through the App—including text, imagery, data, and multimedia—is provided for general informational purposes only. While we endeavor to ensure accuracy and reliability, CosmosPedia makes no warranties, representations, or guarantees—express or implied—regarding the completeness, precision, or reliability of the content.',
                    Icons.warning_amber_outlined,
                    AppColors.warningDark,
                  ),
                  _buildTermsSection(
                    context,
                    '6. Intellectual Property Rights',
                    'The App, including but not limited to its design, functionality, visual elements, codebase, and all associated content, is the exclusive property of CosmosPedia and its licensors. It is protected under applicable intellectual property laws, including copyright, trademark, and patent laws. Unauthorized reproduction, modification, or distribution of any part of the App is strictly prohibited.',
                    Icons.copyright_outlined,
                    AppColors.purple,
                  ),
                  _buildTermsSection(
                    context,
                    '7. Third-Party Links and Services',
                    'The App may contain links to or integrations with third-party websites, services, or content not operated or controlled by CosmosPedia. We assume no responsibility for the content, privacy practices, or policies of any third parties. Your interaction with such external resources is governed by their respective terms and policies.',
                    Icons.link,
                    AppColors.teal,
                  ),
                  _buildTermsSection(
                    context,
                    '8. Limitation of Liability',
                    'To the maximum extent permitted by applicable law, CosmosPedia, its affiliates, officers, directors, employees, agents, partners, and licensors shall not be liable for any direct, indirect, incidental, special, consequential, or exemplary damages—including but not limited to loss of revenue, data, or business opportunities—arising from or related to your access to or use of the App.',
                    Icons.policy_outlined,
                    AppColors.primaryDark,
                  ),
                  _buildTermsSection(
                    context,
                    '9. Amendments to the Terms',
                    'We reserve the right to amend, revise, or update these Terms at our sole discretion. Material changes will be communicated via the App or by other appropriate means. Continued use of the App after the effective date of the updated Terms constitutes your acceptance of the revised agreement.',
                    Icons.update_outlined,
                    AppColors.textDeepPurple,
                  ),
                  _buildTermsSection(
                    context,
                    '10. Governing Law and Jurisdiction',
                    'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which CosmosPedia operates, excluding any conflict of laws provisions. You agree to submit to the exclusive jurisdiction of the courts located in said jurisdiction for the resolution of any disputes arising out of or in connection with these Terms or the use of the App.',
                    Icons.balance_outlined,
                    AppColors.yellow,
                  ),
                  _buildContactSection(context),

                  SizedBox(height: 24.h),

                  _buildAcceptanceButton(context),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color iconColor,
  ) {

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 8.r,
      color: AppColors.black.withOpacity(0.45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: iconColor.withOpacity(0.6), width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [iconColor, iconColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.5),
                        blurRadius: 10.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 24.r, color: AppColors.surfaceLight),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.headingMediumStyle(context),
                  ),
                ),
              ],
            ),
            Divider(color: iconColor.withOpacity(0.3), height: 24.h),

            Text(
              content,
              style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                color: AppColors.greyShimmerShade300.withOpacity(0.9),
                height: 1.5,
              ),
              //textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 8.r,
      color: AppColors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: AppColors.pink.withOpacity(0.6), width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.pink, AppColors.pink.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withOpacity(0.5),
                        blurRadius: 10.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.contact_support_outlined,
                    size: 24.r,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(width: 16.w),
                
                Expanded(
                  child: Text(
                    '11. Contact Information',
                    style: AppTextStyles.headingMediumStyle(context)
                  ),
                ),
              ],
            ),

            Divider(color:AppColors.pink.withOpacity(0.3), height: 24.h),

            Text(
              'For any inquiries, clarifications, or concerns regarding these Terms, please reach out to us via:',
              style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                color: AppColors.greyShimmerShade300.withOpacity(0.9),
                height: 1.5,
              ),
              //textAlign: TextAlign.justify,
            ),

            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.pink.withOpacity(0.2),
                    AppColors.purple.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.greyShimmerShade600),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFixedContactDetail(
                    context,
                    'Email',
                    'cosmospedia0720@gmail.com',
                    Icons.email_outlined,
                    AppColors.pink.withOpacity(0.9),
                  ),

                  Divider(color: AppColors.pink.withOpacity(0.2), height: 16.h),

                  _buildFixedContactDetail(
                    context,
                    'In-app Support',
                    'Available in settings menu',
                    Icons.help_outline,
                    AppColors.purpleShade400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fixed contact detail widget to prevent overflow
  Widget _buildFixedContactDetail(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20.r),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(color: AppColors.greyShimmerShade200, fontSize: 14.sp),
              ),

              SizedBox(height: 2.h),

              Text(
                value,
                style: AppTextStyles.descriptionSmallTextStyle(context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcceptanceButton(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.info.withOpacity(0.5),
              blurRadius: 15.r,
              spreadRadius: 2.r,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Handle acceptance logic
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blueShade700,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            elevation: 0.r,
          ),
          child: Text(
            'I Accept These Terms',
            style: AppTextStyles.descriptionMediumTextStyle(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
