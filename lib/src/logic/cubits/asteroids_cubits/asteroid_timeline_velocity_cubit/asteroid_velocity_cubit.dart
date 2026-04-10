import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_common_models/asteroid_close_approach_model.dart';
import 'package:meta/meta.dart';

part 'asteroid_velocity_state.dart';

class AsteroidVelocityCubit extends Cubit<AsteroidVelocityState> {
  AsteroidVelocityCubit() : super(AsteroidVelocityInitial());

  void loadVelocityData(List<CloseApproachDatum> data) async {
    //try {
      emit(AsteroidVelocityLoadingState());

      // Chota sa delay taaki loading shimmer effect dikhe (Optional)
      await Future.delayed(const Duration(milliseconds: 800));

      // if (data.isEmpty) {
      //   emit(AsteroidVelocityErrorState(errorMessage: "No velocity data found"));
      // } else {
        emit(AsteroidVelocitySuccessState(closeApproachData: data));
      //}
    // } catch (e) {
    //   emit(AsteroidVelocityErrorState(errorMessage: e.toString()));
    // }
  }
}
