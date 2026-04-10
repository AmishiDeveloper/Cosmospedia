import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_model/cme_model.dart';
import 'package:cosmospedia/src/data/network/custom_dio_exceptions.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/cme_api_service/cme_api_service.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class CmeRepository {
  final CmeApiService _cmeApiService;

  CmeRepository(this._cmeApiService);

  // 1. Fetch CME Events (Tab 1 ke liye)
  FutureResult<List<CmeModel>> fetchCmeData({
    String? startDate,
    String? endDate,
  }) async {
    try {
      var response = await _cmeApiService.fetchCmeData(
        start: startDate,
        end: endDate,
      );

      if (response.data != null) {
        // NASA DONKI API aksar List return karti hai directly
        final List<dynamic> rawData = response.data;
        final List<CmeModel> models = rawData
            .map((json) => CmeModel.fromJson(json))
            .toList();

        return right(models);
      } else {
        return left(CustomError("No CME events found", 204));
      }
    } on DioException catch (e) {
      String customException = CustomDioExceptions.fromDioException(e).toString();
      return left(CustomError(customException, e.response?.statusCode));
    } catch (e) {
      return left(CustomError("CME Events Data Format Error: ${e.toString()}", 500));
    }
  }

  // 2. Fetch CME Analysis (Tab 2 ke liye)
  FutureResult<List<CmeAnalysisModel>> fetchCmeAnalysisData({
    String? startDate,
    String? endDate,
  }) async {
    try {
      var response = await _cmeApiService.fetchCmeAnalysisData(
        start: startDate,
        end: endDate,
        mostAccurateOnly: true, // Jaisa humne discuss kiya tha
      );

      if (response.data != null) {
        final List<dynamic> rawData = response.data;
        final List<CmeAnalysisModel> models = rawData
            .map((json) => CmeAnalysisModel.fromJson(json))
            .toList();

        return right(models);
      } else {
        return left(CustomError("No CME Analysis reports found", 204));
      }
    } on DioException catch (e) {
      String customException = CustomDioExceptions.fromDioException(e).toString();
      return left(CustomError(customException, e.response?.statusCode));
    } catch (e) {
      return left(CustomError("CME Analysis Data Format Error: ${e.toString()}", 500));
    }
  }

}