import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_feed_model.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_lookup_model.dart';
import 'package:cosmospedia/src/data/network/custom_dio_exceptions.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/asteroid_api_service/asteroid_api_service.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class AsteroidRepository {
  final AsteroidApiService _asteroidApiService;

  AsteroidRepository(this._asteroidApiService);

  FutureResult<AsteroidFeedModel> fetchAsteroidFeedData({
    String? startDate,
    String? endDate,
  }) async {
    try {
      var response = await _asteroidApiService.fetchAsteroidData(
        start: startDate,
        end: endDate,
      );

      if (response.data != null) {
        // Sab sahi hai, parse karo
        // Direct factory method use karein parsing ke liye
        final AsteroidFeedModel model = AsteroidFeedModel.fromJson(
          response.data,
        );
        return right(model);
      } else {
        // Server ne 'OK' toh bola, par data gayab hai!
        // Ye ek Logic Error hai, isliye manually 'left' return karna padta hai.
        return left(CustomError("No data found", 204));
      }
    } on DioException catch (e) {
      String customException = CustomDioExceptions.fromDioException(e).toString();
      CustomError error = CustomError(customException, e.response?.statusCode);
      // error is packed on the left and returned
      return left(error);
    } catch (e) {
      // Agar parsing fail ho jaye (Model error)
      return left(CustomError("Data Format Error: ${e.toString()}", 500));
    }
  }

  FutureResult<AsteroidLookUpModel> fetchAsteroidLookupData({
    required String asteroidId,
  }) async {
    try {
      var response = await _asteroidApiService.fetchAsteroidLookupData(asteroidId: asteroidId);

      if (response.data != null) {
        // Sab sahi hai, parse karo
        // Direct factory method use karein parsing ke liye
        final AsteroidLookUpModel model = AsteroidLookUpModel.fromJson(response.data);
        return right(model);
      } else {
        // Server ne 'OK' toh bola, par data gayab hai!
        // Ye ek Logic Error hai, isliye manually 'left' return karna padta hai.
        return left(CustomError("No data found", 204));
      }
    } on DioException catch (e) {
      String customException = CustomDioExceptions.fromDioException(e).toString();
      CustomError error = CustomError(customException, e.response?.statusCode);
      // error is packed on the left and returned
      return left(error);
    } catch (e) {
      // Agar parsing fail ho jaye (Model error)
      return left(CustomError("Data Format Error: ${e.toString()}", 500));
    }
  }
}
