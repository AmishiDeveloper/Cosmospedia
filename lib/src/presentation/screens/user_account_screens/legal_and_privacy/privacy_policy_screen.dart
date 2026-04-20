import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildPrivacyContent(context),
    );
  }

  Widget _buildPrivacyContent(BuildContext context) {

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
                  child:CustomAppBar(title: 'Terms & Conditions'),
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
                  'CosmosPedia Privacy Policy',
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
                  _buildPrivacySection(
                    context,
                    '1. Introduction',
                    'Welcome to CosmosPedia ("we", "our", or "us"). This Privacy Policy governs your use of the CosmosPedia mobile application (the "App") and outlines how we collect, utilize, disclose, and safeguard your personal information. We are committed to ensuring that your privacy is protected and that your data is handled in accordance with applicable laws and industry standards.',
                    Icons.info_outline,
                    AppColors.info,
                  ),
                  _buildPrivacySection(
                    context,
                    '2. Information Collection and Use',
                    'We collect various categories of information to deliver an optimal and personalized user experience:\n'
                        '• Account Information: When registering for an account, we collect your email address, display name, and password to facilitate authentication and account management.\n'
                        '• Usage Data: We automatically collect data relating to your interactions with the App, including device type, operating system, app version, and engagement metrics with features.\n'
                        '• Favorites Data: User-saved preferences, such as selected asteroids, rover imagery, and space weather events, are stored to personalize content and enhance usability.\n'
                        '• Crash Reports: In the event of a system malfunction, diagnostic information is collected to support issue resolution and improve app stability.',
                    Icons.data_usage,
                    AppColors.success,
                  ),
                  _buildPrivacySection(
                    context,
                    '3. Firebase Services Integration',
                    'We utilize the following Firebase services:\n'
                        '• Firebase Authentication: For secure user sign-in and account management.\n'
                        '• Firebase Analytics: To gain insights into user behavior and app performance.\n'
                        '• Firebase Crashlytics: For real-time crash reporting and issue diagnosis.',
                    Icons.cloud_outlined,
                    AppColors.cyan,
                  ),
                  _buildPrivacySection(
                    context,
                    '4. How We Use Your Data',
                    'We process your personal data for the following legitimate business purposes:\n'
                        '• To deliver, operate, and maintain the App and its features\n'
                        '• To inform users of updates, enhancements, or critical changes to the App\n'
                        '• To enable participation in interactive and personalized features\n'
                        '• To provide responsive customer support\n'
                        '• To perform data analysis to refine and evolve the App\n'
                        '• To monitor overall usage trends and engagement\n'
                        '• To detect, investigate, and mitigate technical issues and security vulnerabilities',
                    Icons.psychology_outlined,
                    AppColors.orange,
                  ),
                  _buildPrivacySection(
                    context,
                    '5. Data Sharing and Disclosure',
                    'We do not sell, rent, or lease your personal information. Disclosure of personal data is limited to the following instances:\n'
                        '• Service Providers: Trusted third parties such as Firebase may process your information on our behalf for purposes such as hosting, analytics, and customer support.\n'
                        '• Legal Compliance: We may disclose your data if mandated by law or in response to valid requests from public authorities.',
                    Icons.share_outlined,
                    AppColors.warningDark,
                  ),
                  _buildPrivacySection(
                    context,
                    '6. Data Security',
                    'We employ a combination of administrative, technical, and physical safeguards to protect your data. These measures include encrypted data transmission, secure authentication protocols, and regular security assessments. While we strive to use commercially acceptable means to protect your information, no electronic transmission or storage method is entirely foolproof.',
                    Icons.security,
                    AppColors.purple,
                  ),
                  _buildPrivacySection(
                    context,
                    '7. Your Data Protection Rights',
                    'Depending on your jurisdiction, you may be entitled to exercise certain rights under data protection laws, including:\n'
                        '• The right to access, correct, or delete your personal information\n'
                        '• The right to restrict or object to data processing\n'
                        '• The right to data portability\n'
                        '• The right to withdraw consent where processing is based on consent',
                    Icons.gavel_outlined,
                    AppColors.teal,
                  ),
                  _buildPrivacySection(
                    context,
                    '8. Children\'s Privacy',
                    'The App is not intended for children under the age of 13. We do not knowingly collect personal data from children. If we become aware that we have collected information from a child without verifiable parental consent, we will take appropriate steps to delete such data promptly.',
                    Icons.child_care_outlined,
                    AppColors.primaryDark,
                  ),
                  _buildPrivacySection(
                    context,
                    '9. Changes to This Privacy Policy',
                    'We may revise this Privacy Policy from time to time to reflect changes in legal, regulatory, or operational requirements. We will notify users of significant changes by updating this page and modifying the "Effective Date" above.',
                    Icons.update_outlined,
                    AppColors.textDeepPurple,
                  ),
                  _buildPrivacySection(
                    context,
                    '10. Platform-Specific Disclosures',
                    'Google Play Store – Data Safety:\n'
                        '• Data Collected: Email address, usage statistics, crash diagnostics\n'
                        '• Purpose: Authentication, core app functionality, performance analytics\n'
                        '• Third-Party Sharing: Limited to Firebase services (managed by Google)\n'
                        '• Security Practices: Data encrypted in transit, secure authentication protocols employed\n'
                        '• User Control: Data deletion requests may be submitted via in-app settings or by contacting support\n\n'
                        'Apple App Store – Privacy Nutrition Label:\n'
                        '• Identifiers: User ID (for user account functionality)\n'
                        '• Usage Data: Feature interactions, session activity\n'
                        '• Diagnostics: Application crash logs\n'
                        '• Usage Purpose: Functional operation of the app, analytics, and service enhancement',
                    Icons.devices_outlined,
                    AppColors.yellow,
                  ),
                  _buildContactSection(context),

                  SizedBox(height: 24),

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

  Widget _buildPrivacySection(
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
              'If you have any questions, concerns, or requests regarding this Privacy Policy, you may contact us:',
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
            'I Accept This Privacy Policy',
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