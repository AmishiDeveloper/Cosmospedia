import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void initApp() async {
    /*1.Firebase automatically persists the user's login state on the
    device. Even if the user closes and reopens the app,
    FirebaseAuth.instance.currentUser will remain valid until they
    explicitly log out.
    2.If the user's token expires or is revoked, Firebase will '
    'return null, and your app will safely redirect them back to '
     'the Login screen.*/

    // 1. Check if a user is already signed in via Firebase
    final user = FirebaseAuth.instance.currentUser;
    // 2. Decide which screen to go to
    if(user !=null){
      // Session exists!
      emit(SplashBottomNavBarState());
    }
    else{
      // No session, user needs to sign in
      emit(SplashLoginState());
    }
  }
}
