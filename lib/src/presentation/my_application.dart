import 'package:cosmospedia/src/logic/cubits/bottom_nav_bar/navigation_bar_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/bottom_nav_bar_screen/navigation_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return
      // MultiBlocProvider(
      // providers: [
      //   BlocProvider(
      //     create: (_) => SplashCubit(),
      //   ),
      // ],
      // child:
      LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ScreenUtilInit(
              designSize: Size(constraints.maxWidth, constraints.maxHeight),
              splitScreenMode: true,
              minTextAdapt: true,
              ensureScreenSize: true,
              builder: (BuildContext context, Widget? child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: ThemeMode.system,
                  title: 'CosmosPedia',
                  home: SafeArea(
                    child: //SplashScreen(),
                    // BlocProvider(
                    //   create:(context)=>SignInCubit(),
                    //   child:SignInScreen(),
                    // ),
                    BlocProvider(
                      create:(context)=>NavigationBarCubit(),
                      child:NavigationBarScreen(),
                    ),
                  ),
                );
              },
            );
          }
      //),//;
    );
  }
}