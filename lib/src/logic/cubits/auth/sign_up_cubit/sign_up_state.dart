part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}
final class SignUpLoadingState extends SignUpState {}
final class SignUpSuccessState extends SignUpState {}
final class SignUpErrorState extends SignUpState {
  final String errorMessage;
  SignUpErrorState({required this.errorMessage});
}
final class SignUpTogglePasswordState extends SignUpState {}
final class SignUpToggleConfirmPasswordState extends SignUpState {}
