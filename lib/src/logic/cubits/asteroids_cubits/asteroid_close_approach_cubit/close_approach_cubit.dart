import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_common_models/asteroid_close_approach_model.dart';
import 'package:meta/meta.dart';

part 'close_approach_state.dart';

class CloseApproachCubit extends Cubit<CloseApproachState> {
  CloseApproachCubit() : super(CloseApproachInitial());

  void loadCloseApproachData(List<CloseApproachDatum> data) async {
    //try {
    emit(CloseApproachLoadingState());

    // Chota sa delay taaki loading shimmer effect dikhe (Optional)
    await Future.delayed(const Duration(milliseconds: 800));

    // if (data.isEmpty) {
    //   emit(AsteroidVelocityErrorState(errorMessage: "No velocity data found"));
    // } else {
    emit(CloseApproachSuccessState(closeApproachData: data));
    //}
    // } catch (e) {
    //   emit(AsteroidVelocityErrorState(errorMessage: e.toString()));
    // }
  }

}
