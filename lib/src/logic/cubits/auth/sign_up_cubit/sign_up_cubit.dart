import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  bool isPasswordVisible= false;

  void togglePassword(bool passwordVisible){
    isPasswordVisible= !passwordVisible;
    emit(SignUpTogglePasswordState());
  }

  bool isConfirmPasswordVisible= false;

  void toggleConfirmPassword(bool confirmPasswordVisible){
    isConfirmPasswordVisible= !confirmPasswordVisible;
    emit(SignUpToggleConfirmPasswordState());
  }
}
