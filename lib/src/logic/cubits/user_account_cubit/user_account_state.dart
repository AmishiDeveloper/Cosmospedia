part of 'user_account_cubit.dart';

@immutable
sealed class UserAccountState {}

final class UserAccountInitial extends UserAccountState {}

final class UserAccountLoading extends UserAccountState {}

final class UserAccountLoaded extends UserAccountState {
  final UserModel user;
  final String? message;
  UserAccountLoaded({required this.user,this.message});
}

final class UserAccountLogoutSuccess extends UserAccountState {}

final class UserAccountUpdateSuccess extends UserAccountState {
  final String message;
  UserAccountUpdateSuccess(this.message);
}

final class UserAccountError extends UserAccountState {
  final String errorMessage;
  UserAccountError({required this.errorMessage});
}

// final class UserAccountTogglePasswordState extends UserAccountState {}
// final class UserAccountToggleConfirmPasswordState extends UserAccountState {}