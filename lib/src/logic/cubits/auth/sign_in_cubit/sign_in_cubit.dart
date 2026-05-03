import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/repository/auth_repo/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  // Repo ko getIt se uthaya
  final  _repo = getIt<AuthRepository>();

  // --- Sign In Logic ---
  Future<void> signIn({required String email, required String password}) async {
    emit(SignInLoadingState());
    try {
      await _repo.signIn(email, password);
      emit(SignInSuccessState());
    } catch (e) {
      emit(SignInErrorState(errorMessage: e.toString()));
    }
  }

  // --- Forgot Password Logic ---
  Future<void> resetPassword({required String email}) async {
    // Iske liye aap ek alag loading state bhi bana sakte ho agar zaroorat ho
    try {
      await _repo.sendPasswordResetEmail(email);
      // Success snackbar hum UI level par dikhayenge
    } catch (e) {
      emit(SignInErrorState(errorMessage: e.toString()));
    }
  }

}
