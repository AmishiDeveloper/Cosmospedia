part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}
final class SignInLoadingState extends SignInState {}
final class SignInErrorState extends SignInState {
  final String errorMessage;
  SignInErrorState({required this.errorMessage});
}
final class SignInSuccessState extends SignInState {}
final class TogglePasswordState extends SignInState {}
