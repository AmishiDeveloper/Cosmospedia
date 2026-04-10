import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/const/regular_expressions/regex.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/logic/cubits/auth/sign_in_cubit/sign_in_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/auth/sign_up_cubit/sign_up_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/bottom_nav_bar/navigation_bar_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/auth/sign_up_screen/sign_up_screen.dart';
import 'package:cosmospedia/src/presentation/screens/bottom_nav_bar_screen/navigation_bar_screen.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_elevated_button.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_text_form_field.dart';
import 'package:cosmospedia/src/presentation/widgets/show_cosmos_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<
        FormState
      >(); // work- to control whole form like to check if all fields are valid or not
  //late in dart means it doesn't have value yet but before using it dart will provide value to it .
  //it is used because in flutter everything cannot be created as soon as
  // class is created. they have to be created in the initState()
  // because they require either context or system resources.
  // if late is not used then dart asks to either provide value
  // to objects or make objs nullable. by using late we do not
  // need to write _emailController?.text ie no need for null check

  late TextEditingController
  _emailController; // controllers are used to store the value the user types in the field
  late TextEditingController _passwordController;
  late FocusNode
  _emailFocus; // focus nodes are used to tell in which field cursor is currently in
  late FocusNode _passwordFocus;
  final _dialogFormKey = GlobalKey<FormState>();
  late TextEditingController _forgotEmailController;
  late FocusNode _forgotEmailFocusNode;

  @override
  void initState() {
    // used for initialization. this method allocates memory space.
    // this method is only called once at the time of screen load
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _forgotEmailController = TextEditingController();
    _forgotEmailFocusNode = FocusNode();
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

    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _forgotEmailController.dispose();
    _forgotEmailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
    return Scaffold(
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignInErrorState) {
            showCustomSnackBar(
              context: context,
              message: state.errorMessage,
              success: false,
            );
          }
          if (state is SignInSuccessState) {
            showCustomSnackBar(
              context: context,
              message: "Login Successful!",
              success: true, // Taki background green dikhe
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
                          size: 70.h,
                          color: AppColors.surfaceLight,
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          'Welcome to',
                          style: AppTextStyles.subHeadingMediumStyle(context)
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryDark,
                              ),
                        ),

                        SizedBox(height: 5.h),

                        Text(
                          'CosmosPedia',
                          style: AppTextStyles.headingLargeStyle(context),
                        ),

                        SizedBox(height: 5.h),

                        Text(
                          'A Personalized Astronomical Companion',
                          style: AppTextStyles.subHeadingMediumStyle(context),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 40.h),

                        CustomTextField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
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
                              value)) {
                              return 'Enter valid email Address';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        CustomTextField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          onFieldSubmitted: (v) {
                            // either make keyboard go down or
                            _passwordFocus.unfocus();

                            // directly start sign in on clicking the done/enter button in keyboard without clicking sigin button
                            // if (_formKey.currentState!.validate()) {
                            //   context.read<SignInCubit>().signIn(
                            //     email: _emailController.text.trim(),
                            //     password: _passwordController.text,
                            //   );
                            // }
                          },
                          textInputAction: TextInputAction.done,
                          obscureText: !cubit.isPasswordVisible,
                          // eye close if pwd visible if eye open then pwd not visible
                          hintText: 'Password',
                          labelText: 'Password',
                          prefix: Icon(
                            Icons.lock,
                            size: 20.r,
                            color: AppColors.textPrimaryDark,
                          ),
                          suffix: IconButton(
                            icon: Icon(
                              cubit.isPasswordVisible
                                  ? Icons.visibility_sharp
                                  : Icons.visibility_off_sharp,
                            ),
                            iconSize: 20.r,
                            color: AppColors.textPrimaryDark,
                            onPressed: () {
                              cubit.togglePassword(cubit.isPasswordVisible);
                            },
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (!RegularExpressions.passwordRegex.hasMatch(
                              value)) {
                              return 'Enter valid password (8-15 characters).';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 30.h),

                        CustomElevatedButton(
                          isLoading: state is SignInLoadingState,
                          text: 'Sign in',
                          width: double.infinity,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //context.read<SignInCubit>().init();
                            }
                          },
                        ),

                        SizedBox(height: 15.h),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              AppRoute.slide(
                                BlocProvider(
                                  create: (context) => SignUpCubit(),
                                  child: SignUpScreen(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Don\'t have an account? Sign Up',
                            style: AppTextStyles.bodyTextStyle(context),
                            softWrap: true,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            showCustomCosmosDialog(
                              context,
                              child: Form(
                                key: _dialogFormKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // Utni hi jagah lega jitni zaroorat hai
                                  children: [
                                    // 1. Header (Logo/Icon) - Easily changeable
                                    Icon(Icons.rocket_launch, size: 70.h),

                                    SizedBox(height: 15.h),

                                    // 2. Title
                                    Text(
                                      "Reset Password",
                                      style: AppTextStyles.headingMediumStyle(
                                        context,
                                      ).copyWith(color: AppColors.black,
                                      ),
                                    ),

                                    SizedBox(height: 10.h),

                                    // 3. Body (TextField)
                                    CustomTextField(
                                      controller: _forgotEmailController,
                                      focusNode: _forgotEmailFocusNode,
                                      hintText: "Email",
                                      hintStyle: AppTextStyles.descriptionMediumTextStyle(context).copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textSecondaryLight,
                                      ),
                                      labelText: 'Email',
                                      labelStyle: AppTextStyles.descriptionMediumTextStyle(context).copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textSecondaryLight,
                                      ),
                                      textStyle:  AppTextStyles.descriptionMediumTextStyle(context).copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black,
                                      ),
                                      onFieldSubmitted: (v) {
                                        _forgotEmailFocusNode.unfocus();
                                      },
                                      prefix: Icon(
                                        Icons.email,
                                        size: 20.r,
                                        color: AppColors.textSecondaryLight,
                                      ),
                                      focusedBorderColor: AppColors.black,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegularExpressions.emailInput,
                                        ),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email is required';
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
                                              if (_dialogFormKey.currentState!.validate()) {
                                                //         // Agar valid hai toh logic yahan likhein
                                                print("Email: ${_forgotEmailController.text}",
                                                );
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text('Send Reset Link',
                                              style:AppTextStyles.headingMediumStyle(context).
                                              copyWith(
                                                  color:AppColors.textDeepPurple,
                                              ),
                                            ),
                                        ),

                                        TextButton(
                                          onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          child: Text(
                                            'Cancel',
                                            style:AppTextStyles.headingMediumStyle(context).
                                            copyWith(
                                                color:AppColors.textDeepPurple,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password',
                            style: AppTextStyles.descriptionMediumTextStyle(
                              context,
                            ),
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
