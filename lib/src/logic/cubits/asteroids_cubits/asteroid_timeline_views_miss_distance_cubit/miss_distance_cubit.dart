import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_common_models/asteroid_close_approach_model.dart';
import 'package:meta/meta.dart';

part 'miss_distance_state.dart';

class MissDistanceCubit extends Cubit<MissDistanceState> {
  // Initial state mein hum pehli approach (index 0) bhejenge
  MissDistanceCubit(CloseApproachDatum initialApproach) : super(MissDistanceInitial(selectedApproach: initialApproach));

  void initializeData(List<CloseApproachDatum> data) async {
    emit(MissDistanceLoadingState(selectedApproach: data.first));

    // Chota sa delay taaki loading shimmer effect dikhe (Optional)
    await Future.delayed(const Duration(milliseconds: 800));
    emit(MissDistanceSuccessState(closeApproachData: data, selectedApproach: data.first));
  }

  // Jab user dropdown se date badlega, ye function call hoga
  void updateApproach(CloseApproachDatum newApproach) {
    // Agar success state mein ho tabhi update karo
    if (state is MissDistanceSuccessState) {
      final currentData = (state as MissDistanceSuccessState).closeApproachData;

      emit(MissDistanceSuccessState(
          closeApproachData: currentData, selectedApproach: newApproach));
    }
  }
}
