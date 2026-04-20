import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/const/regular_expressions/regex.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/logic/cubits/auth/sign_in_cubit/sign_in_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/user_account_cubit/user_account_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/auth/sign_in_screen/sign_in_screen.dart';
import 'package:cosmospedia/src/presentation/screens/user_account_screens/help_and_support/faq_screen.dart';
import 'package:cosmospedia/src/presentation/screens/user_account_screens/legal_and_privacy/privacy_policy_screen.dart';
import 'package:cosmospedia/src/presentation/screens/user_account_screens/legal_and_privacy/terms_and_conditions_screen.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_text_form_field.dart';
import 'package:cosmospedia/src/presentation/widgets/show_cosmos_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UserAccountScreen> {
  final GlobalKey<FormState> _editNameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _changePasswordFormKey = GlobalKey<FormState>();

  late TextEditingController
  _editNameController; // controllers are used to store the value the user types in the field
  late TextEditingController _newPasswordController;
  late FocusNode _newPasswordFocusNode;
  late TextEditingController _confirmNewPasswordController;
  late FocusNode _confirmNewPasswordFocusNode;

  final List<String> designationList = [
    'Student',
    'Educator/Teacher',
    'Space Enthusiast',
    'Amateur Astronaut',
    'General Public',
  ];

  @override
  void initState() {
    // used for initialization. this method allocates memory space.
    // this method is only called once at the time of screen load

    super.initState();
    context.read<UserAccountCubit>().fetchUserData();
    _editNameController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
    _newPasswordFocusNode = FocusNode();
    _confirmNewPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    /* controllers and focus node always keep using system resources
    and when user leaves (means not only switching the page but
    that page also needs to be removed from the stack. this is
    done using Navigator.pushReplacement . but is navigator.push
    is used the page remains in the stack even if the screen is
    switched to some other screen the controllers and focus node
    will not be disposed for it to happen the pg needs to be
    removed from stack) the page these have to be disposed (thrown)
    to release memory. */
    //Pehle focus hatao taaki keyboard hide ho jaye
    FocusManager.instance.primaryFocus?.unfocus();
    _editNameController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmNewPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Yahan hum BlocBuilder use karenge Firebase se data lane ke liye
    return Scaffold(
      body: customBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              // app bar
              CustomAppBar(title: 'My Profile'),

              BlocListener<UserAccountCubit, UserAccountState>(
                listener: (context, state) {
                  if (state is UserAccountError) {
                    showCustomSnackBar(
                      context: context,
                      message: state.errorMessage,
                      success: false,
                    );
                  }

                  if (state is UserAccountLoaded && state.message != null) {
                    // Jaise hi message mile, Snackbar dikhao
                    showCustomSnackBar(
                      context: context,
                      message: state.message!,
                      success: true,
                    );
                  }

                  if (state is UserAccountLogoutSuccess) {
                    showCustomSnackBar(
                      context: context,
                      message: "Logged out successfully!",
                      success: true,
                    );

                    // Final Navigation
                    Navigator.pushAndRemoveUntil(
                      context,
                      AppRoute.scale(
                        BlocProvider(
                          create: (context) => SignInCubit(),
                          child: const SignInScreen(),
                        ),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        // --- HEADER CARD ---
                        BlocBuilder<UserAccountCubit, UserAccountState>(
                          builder: (context, state) {
                            String displayName = "User";
                            String displayEmail = "Loading...";
                            String designation =
                                "General Public"; // Default value

                            if (state is UserAccountLoaded) {
                              displayName = state.user.name;
                              displayEmail = state.user.email;
                              designation = state
                                  .user
                                  .designation; //  Firestore se designation uthayi
                              _editNameController.text =
                                  state.user.name; // Controller pre-fill kar do
                            }

                            return Column(
                              children: [
                                _buildUserHeader(
                                  context,
                                  displayName,
                                  displayEmail,
                                  designation,
                                ),

                                SizedBox(height: 20.h),

                                // --- ACCOUNT SETTINGS  ---
                                _buildSectionHeader(
                                  context,
                                  "Account Settings",
                                  [AppColors.blueShade700, AppColors.info],
                                ),

                                //name list tile
                                _buildUserAccountMenuTile(
                                  icon: Icons.person,
                                  title: "Name",
                                  subtitle: displayName,
                                  onTap: () {
                                    if (state is UserAccountLoaded) {
                                      //Dialog khulne se pehle controller ko original name par reset karo
                                      _editNameController.text =
                                          state.user.name;
                                    }
                                    _showEditNameDialog(context);
                                  },
                                  gradientColors: [
                                    AppColors.blueShade700,
                                    AppColors.cyan,
                                  ],
                                ),

                                // password list tile
                                _buildUserAccountMenuTile(
                                  icon: Icons.lock,
                                  title: "Change Password",
                                  subtitle: "Update your security credentials",
                                  onTap: () {
                                    _newPasswordController.clear();
                                    _confirmNewPasswordController.clear();
                                    _showChangePasswordDialog(context);
                                  },
                                  gradientColors: [
                                    AppColors.blueShade700,
                                    AppColors.cyan,
                                  ],
                                ),

                                SizedBox(height: 20.h),

                                // --- HELP & SUPPORT header---
                                _buildSectionHeader(context, "Help & Support", [
                                  AppColors.purpleShade700,
                                  AppColors.purple,
                                ]),

                                // _buildProfileMenuTile(
                                //   icon: Icons.help_outline,
                                //   title: "Queries",
                                //   subtitle: "Ask us anything about Cosmospedia",
                                //   onTap: () {},
                                // ),
                                // _buildProfileMenuTile(
                                //   icon: Icons.contact_support,
                                //   title: "Contact Us",
                                //   subtitle: "Get in touch with our support team",
                                //   onTap: () {},
                                // ),

                                // faq list tile
                                _buildUserAccountMenuTile(
                                  icon: Icons.question_answer,
                                  title: "FAQs",
                                  subtitle: "Find answers to common questions",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      AppRoute.scale(const FaqScreen()),
                                    );
                                  },
                                  gradientColors: [
                                    AppColors.purpleShade700,
                                    AppColors.purpleShade400,
                                  ],
                                ),

                                SizedBox(height: 20.h),

                                // --- LEGAL & PRIVACY header ---
                                _buildSectionHeader(
                                  context,
                                  "Legal & Privacy",
                                  [
                                    AppColors.tealShade700,
                                    AppColors.tealShade400,
                                  ],
                                ),

                                // terms and conditions list tile
                                _buildUserAccountMenuTile(
                                  icon: Icons.gavel,
                                  title: "Terms & Conditions",
                                  subtitle: "Read our terms of service",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      AppRoute.scale(
                                        const TermsAndConditionsScreen(),
                                      ),
                                    );
                                  },
                                  gradientColors: [
                                    AppColors.tealShade700,
                                    AppColors.success,
                                  ],
                                ),

                                // privacy policy list tile
                                _buildUserAccountMenuTile(
                                  icon: Icons.security,
                                  title: "Privacy Policy",
                                  subtitle: "How we handle your data",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      AppRoute.scale(
                                        const PrivacyPolicyScreen(),
                                      ),
                                    );
                                  },
                                  gradientColors: [
                                    AppColors.tealShade700,
                                    AppColors.success,
                                  ],
                                ),

                                SizedBox(height: 30.h),

                                // --- LOGOUT BUTTON  ---
                                SizedBox(
                                  width: 200.w,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.error,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                        horizontal: 10.w,
                                      ),
                                    ),
                                    onPressed: () {
                                      _showLogoutConfirmationDialog(context);
                                      // Firebase Logout Logic
                                      //context.read<UserAccountCubit>().logOut();
                                    },
                                    icon: const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Log Out",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50.h),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditNameDialog(BuildContext context) {
    return showCustomCosmosDialog(
      context,
      child: Form(
        key: _editNameFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Utni hi jagah lega jitni zaroorat hai
          children: [
            // 1. Header (Logo/Icon) - Easily changeable
            //Icon(Icons.rocket_launch, size: 70.h),

            //SizedBox(height: 15.h),

            // 2. Title
            Text(
              "Edit Display Name",
              style: AppTextStyles.headingMediumStyle(
                context,
              ).copyWith(color: AppColors.black),
            ),

            SizedBox(height: 10.h),

            // 3. Body (TextField)
            CustomTextField(
              controller: _editNameController,
              //focusNode: _editNameFocusNode,
              hintText: "Name",
              hintStyle: AppTextStyles.descriptionMediumTextStyle(context)
                  .copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ),
              labelText: 'Name',
              labelStyle: AppTextStyles.descriptionMediumTextStyle(context)
                  .copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ),
              textStyle: AppTextStyles.descriptionMediumTextStyle(
                context,
              ).copyWith(fontWeight: FontWeight.w400, color: AppColors.black),
              // onFieldSubmitted: (v) {
              //   _editNameFocusNode.unfocus();
              // },
              prefix: Icon(
                Icons.person_rounded,
                size: 20.r,
                color: AppColors.textSecondaryLight,
              ),
              focusedBorderColor: AppColors.black,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegularExpressions.usernameInput,
                ),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),

            SizedBox(height: 15.h),

            // 4. Footer (Action Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.headingMediumStyle(
                      context,
                    ).copyWith(color: AppColors.textDeepPurple),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    if (_editNameFormKey.currentState!.validate()) {
                      print(
                        "Updating Firebase Name from user account screen: ${_editNameController.text}",
                      );

                      context.read<UserAccountCubit>().updateName(
                        _editNameController.text.trim(),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Save',
                    style: AppTextStyles.headingMediumStyle(
                      context,
                    ).copyWith(color: AppColors.textDeepPurple),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. CHANGE PASSWORD DIALOG ---
  Future<void> _showChangePasswordDialog(BuildContext context) {
    //final cubit = context.read<UserAccountCubit>();

    //Dono password fields ke liye alag-alag Notifiers
    final ValueNotifier<bool> isNewPasswordVisible = ValueNotifier<bool>(false);
    final ValueNotifier<bool> isConfirmNewPasswordVisible = ValueNotifier<bool>(
      false,
    );

    return showCustomCosmosDialog(
      context,
      child: Form(
        key: _changePasswordFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Change Password",
              style: AppTextStyles.headingMediumStyle(
                context,
              ).copyWith(color: AppColors.black),
            ),

            SizedBox(height: 15.h),

            ValueListenableBuilder(
              valueListenable: isNewPasswordVisible,
              builder: (context, bool visible, child) {
                return CustomTextField(
                  controller: _newPasswordController,
                  focusNode: _newPasswordFocusNode,
                  onFieldSubmitted: (v) => FocusScope.of(
                    context,
                  ).requestFocus(_confirmNewPasswordFocusNode),
                  hintText: "New Password",
                  labelText: "New Password",
                  hintStyle: AppTextStyles.descriptionMediumTextStyle(context)
                      .copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryLight,
                      ),
                  labelStyle: AppTextStyles.descriptionMediumTextStyle(context)
                      .copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryLight,
                      ),
                  textStyle: AppTextStyles.descriptionMediumTextStyle(context)
                      .copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                  prefix: Icon(
                    Icons.lock,
                    size: 20.r,
                    color: AppColors.textSecondaryLight,
                  ),
                  suffix: IconButton(
                    onPressed: () {
                      isNewPasswordVisible.value = !isNewPasswordVisible.value;
                    },
                    icon: Icon(
                      visible
                          ? Icons.visibility_sharp
                          : Icons.visibility_off_sharp,
                      size: 20.r,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  obscureText: !visible,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New Password is required';
                    }
                    if (!RegularExpressions.passwordRegex.hasMatch(value)) {
                      return 'Min. 8-15 non-space chars, 1 uppercase, 1 lowercase, 1 digit & 1 special char.';
                    }
                    return null;
                  },
                );
              },
            ),

            SizedBox(height: 10.h),

            ValueListenableBuilder(
              valueListenable: isConfirmNewPasswordVisible,
              builder: (context, visible, child) {
                return CustomTextField(
                  controller: _confirmNewPasswordController,
                  focusNode: _confirmNewPasswordFocusNode,
                  onFieldSubmitted: (v) {
                    _confirmNewPasswordFocusNode.unfocus();
                  },
                  textInputAction: TextInputAction.done,
                  hintText: "Confirm New Password",
                  labelText: 'Confirm New Password',
                  hintStyle: AppTextStyles.descriptionMediumTextStyle(context)
                      .copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryLight,
                      ),
                  labelStyle: AppTextStyles.descriptionMediumTextStyle(context)
                      .copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryLight,
                      ),
                  textStyle: AppTextStyles.descriptionMediumTextStyle(context)
                      .copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                  prefix: Icon(
                    Icons.lock,
                    size: 20.r,
                    color: AppColors.textSecondaryLight,
                  ),
                  suffix: IconButton(
                    onPressed: () {
                      isConfirmNewPasswordVisible.value =
                          !isConfirmNewPasswordVisible.value;
                    },
                    icon: Icon(
                      visible
                          ? Icons.visibility_sharp
                          : Icons.visibility_off_sharp,
                      color: AppColors.textSecondaryLight,
                      size: 20.r,
                    ),
                  ),
                  obscureText: !visible,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm New Password is required';
                    }
                    if (value.isNotEmpty &&
                        value != _newPasswordController.text) {
                      return 'Enter confirm new password that matches new password.';
                    }
                    return null;
                  },
                );
              },
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _newPasswordController.clear();
                    _confirmNewPasswordController.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.headingMediumStyle(
                      context,
                    ).copyWith(color: AppColors.textDeepPurple),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    if (_changePasswordFormKey.currentState!.validate()) {
                      print("Updating Password to  $_newPasswordController");

                      context.read<UserAccountCubit>().changePassword(
                        _newPasswordController.text,
                      );

                      _newPasswordController.clear();
                      _confirmNewPasswordController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Update',
                    style: AppTextStyles.headingMediumStyle(
                      context,
                    ).copyWith(color: AppColors.textDeepPurple),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Widgets ---
  Widget _buildUserHeader(
    BuildContext context,
    String name,
    String email,
    String designation,
  ) {
    return Container(
      //width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blueShade900, AppColors.purpleShade900],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueShade700.withOpacity(0.3),
            blurRadius: 15.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with cosmic background and gradient border
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.blueShade400, AppColors.purple],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blueShade400.withOpacity(0.6),
                  blurRadius: 20.r,
                  spreadRadius: 3.r,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: Center(
                child: Text(
                  'HI',
                  //name.substring(0, 1).toUpperCase(),
                  style: AppTextStyles.headingLargeStyle(context).copyWith(
                    //fontSize: 32.sp,
                    shadows: [
                      Shadow(
                        color: AppColors.black.withOpacity(0.5),
                        blurRadius: 5.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // user info
          FittedBox(
            child: Text(
              name,
              style: AppTextStyles.headingMediumStyle(context).copyWith(
                shadows: [
                  Shadow(
                    color: AppColors.black.withOpacity(0.5),
                    blurRadius: 3.r,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.greyShimmerShade600,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: FittedBox(
              child: Text(
                email,
                style: AppTextStyles.descriptionLargeTextStyle(
                  context,
                ).copyWith(color: AppColors.greyShimmerShade300),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          _buildDesignationDropdown(context, designation),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    List<Color> gradientColor,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColor,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          title,
          style: AppTextStyles.descriptionLargeTextStyle(context),
        ),
      ),
    );
  }

  Widget _buildUserAccountMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 4.r,
      color: AppColors.greyShimmerShade700.withOpacity(0.6),
      //AppColors.surfaceLight.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.surfaceLight),
        ),
        title: Text(
          title,
          style: AppTextStyles.descriptionMediumTextStyle(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.descriptionMediumTextStyle(
            context,
          ).copyWith(color: AppColors.greyShimmerShade400, fontSize: 14.sp),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.all(4.r),
          child: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.greyShimmerShade200,
            size: 16.r,
          ),
        ),
      ),
    );
  }

  Widget _buildDesignationDropdown(
    BuildContext context,
    String currentDesignation,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.greyShimmerShade600.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyShimmerShade400.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: designationList.contains(currentDesignation)
              ? currentDesignation
              : designationList.last,
          isExpanded: true,
          // Poori width lene ke liye
          dropdownColor: AppColors.black.withOpacity(0.9),
          // Dark theme ke liye
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.surfaceLight,
          ),
          items: designationList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: AppTextStyles.descriptionSmallTextStyle(
                  context,
                ).copyWith(color: AppColors.surfaceLight),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null && newValue != currentDesignation) {
              // Sirf tab call karo jab value badli ho
              // Hum Cubit ko call karenge Firestore update ke liye
              context.read<UserAccountCubit>().updateDesignation(newValue);
            }
          },
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) {
    return showCustomCosmosDialog(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Title
          Text(
            "Log Out",
            style: AppTextStyles.headingLargeStyle(
              context,
            ).copyWith(color: AppColors.black),
          ),

          SizedBox(height: 15.h),

          // 2. Content
          Text(
            "Are you sure you want to log out of your account?",
            textAlign: TextAlign.center,
            style: AppTextStyles.descriptionMediumTextStyle(
              context,
            ).copyWith(color: AppColors.textSecondaryLight),
          ),

          SizedBox(height: 25.h),

          // 3. Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.headingMediumStyle(
                    context,
                  ).copyWith(color: AppColors.textDeepPurple),
                ),
              ),

              // Logout Button (Target Action)
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Dialog band karo
                  //  2. CACHE CLEAR LOGIC
                  debugPrint(" Clearing APOD cache before logout...");
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('cached_apod_data'); // Cubit wali key

                  if (context.mounted) {
                    context
                        .read<UserAccountCubit>()
                        .logOut(); // Cubit call karo
                  }
                },
                child: Text(
                  'Logout',
                  style: AppTextStyles.headingMediumStyle(context).copyWith(
                    color: Colors.redAccent, // Logout thoda alag dikhe
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
