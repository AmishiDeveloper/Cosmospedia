import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/model/user_model/user_model.dart';
import 'package:cosmospedia/src/data/repository/auth_repo/auth_repository.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final _repo = getIt<AuthRepository>();

  void signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoadingState());
    try {
      UserModel newUser = UserModel(
        uid: "", // Ye Repo mein Auth handle kar lega
        email: email,
        name: name,
      );

      await _repo.signUp(newUser, password);
      emit(SignUpSuccessState());
    } catch (e) {
      emit(SignUpErrorState(errorMessage: e.toString()));
    }
  }

}
