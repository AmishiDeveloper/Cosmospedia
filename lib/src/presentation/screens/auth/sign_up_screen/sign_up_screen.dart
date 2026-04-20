import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/const/regular_expressions/regex.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/logic/cubits/auth/sign_in_cubit/sign_in_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/auth/sign_up_cubit/sign_up_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/bottom_nav_bar/navigation_bar_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/auth/sign_in_screen/sign_in_screen.dart';
import 'package:cosmospedia/src/presentation/screens/bottom_nav_bar_screen/navigation_bar_screen.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_elevated_button.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late FocusNode _nameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isConfirmPasswordVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();

    return Scaffold(
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is SignUpErrorState) {
            showCustomSnackBar(
              context: context,
              message: state.errorMessage,
              success: false,
            );
          }
          if (state is SignUpSuccessState) {
            showCustomSnackBar(
              context: context,
              message: 'Sign Up Successful!',
              success: true,
            );
            Navigator.pushAndRemoveUntil(
              context,
              AppRoute.slide(
                BlocProvider(
                  create: (context) => NavigationBarCubit(),
                  child: const NavigationBarScreen(),
                ),
              ),
                  (Route<dynamic> route) => false,
            );
          }
        },
        builder: (context, state) {
          return customBackgroundWidget(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rocket_launch,
                          color: AppColors.surfaceLight,
                          size: 70.h,
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          'Create Account',
                          style: AppTextStyles.headingLargeStyle(context),
                        ),

                        SizedBox(height: 30.h),

                        CustomTextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          onFieldSubmitted: (v) => FocusScope.of(
                            context,
                          ).requestFocus(_emailFocusNode),
                          hintText: 'Display Name',
                          labelText: 'Display Name',
                          prefix: Icon(
                            Icons.person,
                            size: 20.h,
                            color: AppColors.textPrimaryDark,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegularExpressions.usernameInput,
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            if (!RegularExpressions.usernameRegex.hasMatch(
                              value)) {
                              return 'Name must be 6-20 character long with no special character except space.';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10.h),

                        CustomTextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          onFieldSubmitted: (v) => FocusScope.of(
                            context,
                          ).requestFocus(_passwordFocusNode),
                          hintText: 'Email',
                          labelText: 'Email',
                          prefix: Icon(
                            Icons.email,
                            size: 20.r,
                            color: AppColors.textPrimaryDark,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegularExpressions.emailInput,
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegularExpressions.emailRegex.hasMatch(
                              value,
                            )) {
                              return 'Enter valid email Address';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10.h),

                        ValueListenableBuilder(
                          valueListenable: isPasswordVisible,
                          builder: (context, bool visible, child) {
                            return CustomTextField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
                              hintText: 'Password',
                              labelText: 'Password',
                              prefix: Icon(
                                Icons.lock,
                                size: 20.r,
                                color: AppColors.textPrimaryDark,
                              ),
                              suffix: IconButton(
                                onPressed: () {
                                  isPasswordVisible.value = !isPasswordVisible.value;
                                },
                                icon: Icon(
                                  visible
                                      ? Icons.visibility_sharp
                                      : Icons.visibility_off_sharp,
                                  size: 20.r,
                                  color: AppColors.textPrimaryDark,
                                ),
                              ),
                              obscureText: !visible,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (!RegularExpressions.passwordRegex.hasMatch(
                                  value,
                                )) {
                                  return 'Min. 8-15 non-space chars, 1 uppercase, 1 lowercase, 1 digit & 1 special char.';
                                }
                                return null;
                              },
                            );
                          }
                        ),

                        SizedBox(height: 10.h),

                        ValueListenableBuilder(
                          valueListenable: isConfirmPasswordVisible,
                          builder: (context, bool visible, child) {
                            return CustomTextField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              onFieldSubmitted: (v) {
                              _confirmPasswordFocusNode.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              hintText: 'Confirm Password',
                              labelText: 'Confirm Password',
                              prefix: Icon(
                                Icons.lock,
                                size: 20.r,
                                color: AppColors.textPrimaryDark,
                              ),
                              suffix: IconButton(
                                onPressed: () {
                                  isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
                                },
                                icon: Icon(
                                  visible
                                      ? Icons.visibility_sharp
                                      : Icons.visibility_off_sharp,
                                  color: AppColors.textPrimaryDark,
                                  size: 20.r,
                                ),
                              ),
                              obscureText: !visible,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm Password is required';
                                }
                                if (value.isNotEmpty &&
                                    value != _passwordController.text) {
                                  return 'Enter confirm password that matches password.';
                                }
                                return null;
                              },
                            );
                          }
                        ),

                        SizedBox(height: 30.h),

                        CustomElevatedButton(
                          isLoading: state is SignUpLoadingState,
                          loadingText: 'Signing up...',
                          text: 'Sign up',
                          width: double.infinity,
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState!.validate()) {
                              context.read<SignUpCubit>().signUpUser(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            }
                          },
                        ),

                        SizedBox(height: 10.h),

                        Text(
                          'By Signing Up , you agree to the Terms and Conditions of the application.',
                          style:
                              AppTextStyles.descriptionSmallTextStyle(
                                context,
                              ).copyWith(
                                color: AppColors.textPrimaryDark,
                                fontSize: 12.sp,
                              ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(
                          height: 20.h,
                        ),

                        TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                              context,
                              AppRoute.slide(
                                BlocProvider(
                                  create: (context)=> SignInCubit(),
                                  child:SignInScreen(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Already have an account? Sign In',
                            style: AppTextStyles.bodyTextStyle(context),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
