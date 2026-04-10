import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/logic/cubits/auth/sign_in_cubit/sign_in_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/bottom_nav_bar/navigation_bar_cubit.dart';
import 'package:cosmospedia/src/logic/cubits/splash_cubit/splash_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/auth/sign_in_screen/sign_in_screen.dart';
import 'package:cosmospedia/src/presentation/screens/bottom_nav_bar_screen/navigation_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    /*
As soon as the screen opens, the app starts a timer for 2 seconds
(2000 milliseconds). Once the time is up, it calls initApp() from the
SplashCubit. This is where the app checks things like: "Is the user
logged in?" or "Is this their first time opening the app?"
*/
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 2000),
      () => context.read<SplashCubit>().initApp(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        /*
        This part acts like a GPS. It "listens" for the result from the
        SplashCubit and directs the user to the right screen:
        1. if state is SplashLoginState : Takes you to the Login screen
        2. if state is SplashBottomNavBarState: Takes you straight to the Home screen
        (if you are already logged in).
        */

        listener: (context, state) {
          switch (state) {
          //Agar state (object/instance) iss class ka instance hai, toh ye case chalao
            case SplashLoginState(): // instance . now matching instance with instance
              Navigator.pushAndRemoveUntil(
                context,
                AppRoute.slide(
                  BlocProvider(
                    create: (context) => SignInCubit(),
                    child: const SignInScreen(),
                  ),
                ),
                (Route<dynamic> route) => false,
              );
              break;

            case SplashBottomNavBarState():
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
              break;

            default:
              return;
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
              colors: [
                AppColors.splashRoyalBlueBackground,
                AppColors.splashBlueBackground,
                AppColors.splashBlueBackground,
                AppColors.splashRoyalBlueBackground,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Image.asset(
            'assets/gifs/splashScreen.gif',
            fit: BoxFit.contain,
            width: double.infinity,
          ),

          //   ShaderMask(
          //       shaderCallback:(Rect rect){
          // return const LinearGradient(
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter,
          // colors: [
          // Colors.transparent, // Top edge of GIF becomes invisible
          // Colors.black,       // Middle is fully visible
          // Colors.black,       // Middle is fully visible
          // Colors.transparent, // Bottom edge of GIF becomes invisible
          // ],
          // // These stops control the "feathering" of the edges
          // stops: [0.0, 0.1, 0.9, 1.0],
          // ).createShader(rect);
          // },
          //     // dstIn uses the alpha channel of our gradient to mask the child image
          //     blendMode: BlendMode.dstIn,
          //     child:Image.asset(
          //     'assets/gifs/splashScreen.gif',
          //     fit: BoxFit.contain,
          //   ),
          // ),
        ),
      ),
    );
  }
}

// colors:[
//   Colors.deepPurple,
//   Colors.deepPurpleAccent,
//   Colors.blueAccent,
//   Colors.blue
// ]
// colors:[
//   Colors.black,
//   Colors.deepPurple.shade900,
//   Colors.deepPurpleAccent.shade700,
//   Colors.indigoAccent.shade400,
//   Colors.indigoAccent.shade700,
//   Colors.blueAccent.shade700,
//   Colors.blueAccent.shade700,
//   Colors.blueAccent.shade700,
//   Colors.blue.shade900,
//   Colors.indigo.shade800,
//   Colors.indigo.shade900,
//   //Colors.black,
// ]
