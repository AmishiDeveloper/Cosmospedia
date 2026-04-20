import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_lookup_model.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/asteroid_repository/asteroid_repository.dart';
import 'package:meta/meta.dart';

part 'asteroid_detail_state.dart';

class AsteroidDetailCubit extends Cubit<AsteroidDetailState> {
  AsteroidDetailCubit() : super(AsteroidDetailInitial());

  final _repo = getIt<AsteroidRepository>();

  // feed api se mili hui asteroid id yhn bhejni h
  Future<void> fetchAsteroidLookupData({required String asteroidId}) async{

    emit(AsteroidDetailLoadingState());

    final response = await _repo.fetchAsteroidLookupData(asteroidId: asteroidId);
    response.fold((error){
      emit(AsteroidDetailErrorState(errorMessage: error.message));
    }, (lookupModel){
      emit(AsteroidDetailSuccessState(lookupModel: lookupModel));
    });
   }

}
