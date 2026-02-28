import 'dart:ui';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Show zar dialog
Future<void> showCustomCosmosDialog( //Future<void>: Dialog hamesha ek Future value return karta hai kyunki app intezar karta hai ki user ise kab band karega.
    BuildContext context,
    {required Widget child,
     bool cancellable = false,
  //Color backgroundColor = Colors.white,
  //Color? borderColor,
     double blurAmount = 10.0,}
    ) async {
  /* summmary of showGeneralDialog

  Duration	Kitni der tak animation chalegi (Speed).
  pageBuilder	Kya dikhana hai (The Widget).
  transitionBuilder	Kaise dikhana hai (The Motion).
  easeOutBack	Thoda sa "Bounce" effect dene ke liye.
  */

  showGeneralDialog(
    context: context,
    barrierDismissible: cancellable,//barrierDismissible takes bool value if its true then when user clicks outside the barrier on empty space the dialog will be closed
    barrierColor: AppColors.black.withOpacity(0.5),// when dialog opens then then what should the background color be it is that color. Ideally it should be dark so that the focus is on the dialog itself
    transitionDuration: const Duration(milliseconds: 500),// time the dialog takes to come on the screen and when it goes from the screen
    pageBuilder: (context,anim1,anim2) => // it tells what widget to show on the screen ie on the background color
      // when animation starts then then this function tells that  _CustomCosmosDialo Widget has to be build
      // anim1 aur anim2 Flutter ke built-in objects hain jo animation ki state (0.0 se 1.0 tak) ko handle karte hain.
    _CustomCosmosDialog(
          cancellable: cancellable,
          blurAmount: blurAmount,
          //backgroundColor: backgroundColor,
          //borderColor: borderColor,
          child: child,
        ),
    transitionBuilder: (context,animation,secondaryAnimation,child){//this is the most imp part because from pageBuilder we know that
      // _CustomCosmosDialog widget has to be build but how will that widget
      // be rendered / shown  means kaise animate hoke aayega? voh yeh decide karta h
      // child in the parameter is the dialog itself
      // the dialog is wrapped within the nimation widget ScaleTrsnsition
      // which causes the dialog to first be small then enlarge in size then rendered on screen
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,// this line tells that animation speed transitionDuratiion(500ms) ke according ho
          curve: Curves.easeOutBack, // Style of animation "Bounce" effect provided . this actually causes the dialog to be first greater than its actual size then back to its normal size as a result bounce affect is seen
        ),
        //animation,
        child: child,
      );
    }
  );
}

/// Custom zar dialog
class _CustomCosmosDialog extends StatelessWidget {  // ui widget that decides the look of the dialog
  final Widget child;
  final bool cancellable;
  final double blurAmount;
  //final Color backgroundColor;
  //final Color? borderColor;

  const _CustomCosmosDialog({
    required this.child,
    this.cancellable = false,
    //this.backgroundColor = Colors.white,
    //this.borderColor,
    this.blurAmount = 10.0,
  });


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: cancellable, // canPop decides if user using phones Hardware Back Button can close the dialog. If cancellable is false, then back button does not close the dialog.
      onPopInvokedWithResult: (didPop, result){
        // this functions didPop checks canPop if canPop=true then dialog closes and didPop becomes true
        if(didPop){ // didPop means is dialog closed? if didPop=true then dialog is already closed
          // if pop successful
          return;//debugPrint('Dialog closed successfully with result: $result');
        }
        // didPop= false means system back not allowed
        debugPrint('System back is blocked. Use dialog buttons to close dialog');
      },
      child: BackdropFilter( //(The Blur Effect)
        filter:ImageFilter.blur(sigmaX: blurAmount,sigmaY: blurAmount),
          /* this line is used to give glass effect that is the previous/background screen (galaxy background,textfields)
          is blurred but still visible. the more the sigmaX and sigmaY value the more blur the background becomes
           */
        child: Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),// this line ensures that the dialog is not at the corners a little far from there
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(15.r),
          // ),
          child: Container(
            decoration: BoxDecoration( // frosted glass box
              color: AppColors.surfaceLight.withOpacity(0.25), //textSecondaryDark //color + withOpacity(0.25): Yeh "Semi-transparent" color hi blur ke saath milkar Frosted Glass effect deta hai.
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(
                color: AppColors.surfaceLight.withOpacity(0.3),
                width: 1.5,
              ),
            ),
              // boxShadow: [
              //   BoxShadow(
              //     color: borderColor ?? AppColors.textSecondaryLight,
              //     //context.appColor.primary,
              //     blurRadius: 8,
              //     offset: const Offset(2, 2),
              //   ),
              // ],
            padding: EdgeInsets.all(20.w),
            child: SingleChildScrollView(
              child:child,
            ),
          ),
        ),
      ),
    );
  }
}
