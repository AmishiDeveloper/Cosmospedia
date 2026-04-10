import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  //emit(SignInErrorState(errorMessage: "Invalid Credentials"));
  bool isPasswordVisible=false;

 void togglePassword(bool pwdVisible){
   isPasswordVisible=!pwdVisible;
   emit(TogglePasswordState());
 }

 // only for checking do not use this remove this func later
 // void init(){ // yeh sign in button par call ho raha h
 //   emit(SignInSuccessState());
 // }
}
