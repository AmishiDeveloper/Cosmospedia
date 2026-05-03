import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/model/user_model/user_model.dart';
import 'package:cosmospedia/src/data/repository/auth_repo/auth_repository.dart';
import 'package:meta/meta.dart';
part 'user_account_state.dart';

class UserAccountCubit extends Cubit<UserAccountState> {
  UserAccountCubit() : super(UserAccountInitial());

  final _repo = getIt<AuthRepository>();

// Screen khulte hi data fetch karo
  Future<void> fetchUserData() async {
    emit(UserAccountLoading());
    try {
      final user = await _repo.getUserProfile();
      emit(UserAccountLoaded(user: user));
    } catch (e) {
      emit(UserAccountError(errorMessage: e.toString()));
    }
  }

  // Name update logic
  Future<void> updateName(String newName) async {
    //emit(UserAccountLoading());
    try {
      await _repo.updateProfileField('name', newName);
      // await fetchUserData(); // Update ke baad fresh data fetch karo

      // Refresh data silently
      final user = await _repo.getUserProfile();
      emit(UserAccountLoaded(user: user,message:"Name updated successfully!" ));
      //emit(UserAccountUpdateSuccess("Name updated successfully!"));
    } catch (e) {
      emit(UserAccountError(errorMessage: e.toString()));
    }
  }

  // Name update logic
  Future<void> updateDesignation(String newDesignation) async {
    //emit(UserAccountLoading());
    try {
      // 1. Firebase update karo
      await _repo.updateProfileField('designation', newDesignation);
      //await fetchUserData(); // Update ke baad fresh data fetch karo

      // 2. Bina screen freeze kiye data refresh karo
      final user = await _repo.getUserProfile();
      emit(UserAccountLoaded(user: user,message: "Designation updated successfully!"));
      //emit(UserAccountUpdateSuccess("Designation updated successfully!"));
    } catch (e) {
      emit(UserAccountError(errorMessage: e.toString()));
    }
  }

  // Password update logic
  Future<void> changePassword(String newPassword) async {
    emit(UserAccountLoading());
    try {
      await _repo.updatePassword(newPassword);
      // Password change ke baad wapas loaded state mein aana zaroori hai
      final user = await _repo.getUserProfile();
      emit(UserAccountLoaded(user: user,message: "Password changed successfully!"));
      //emit(UserAccountUpdateSuccess("Password changed successfully!"));
    } catch (e) {
      emit(UserAccountError(errorMessage: e.toString()));
    }
  }

  Future<void> logOut() async {
    emit(UserAccountLoading());
    try {
      await _repo.logOut();
      emit(UserAccountLogoutSuccess());
    } catch (e) {
      emit(UserAccountError(errorMessage: e.toString()));
    }
  }

}
