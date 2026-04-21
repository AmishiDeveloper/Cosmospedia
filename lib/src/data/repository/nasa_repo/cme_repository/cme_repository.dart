import 'dart:convert';
import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_model/cme_model.dart';
import 'package:cosmospedia/src/data/network/custom_dio_exceptions.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/cme_api_service/cme_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
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
    }
    // on DioException catch (e) {
    //   String customException = CustomDioExceptions.fromDioException(e).toString();
    //   return left(CustomError(customException, e.response?.statusCode));
    // }
    catch (e) {
      //return left(CustomError("CME Events Data Format Error: ${e.toString()}", 500));


      // FALLBACK LOGIC: Agar NASA ka server down hai
      if (_shouldFallback(e)) {
        print(" Connection refused detected! Switching to Mock Data...");
        return await _loadCmeMockData();
      }

      // 2. Agar fallback nahi hua, toh asli StatusCode nikalo
      int statusCode = 500; // Default error code
      if (e is DioException) {
        statusCode = e.response?.statusCode ?? 500;
      }

      // 3. Error message nikal kar Right format mein bhej do
      String errorMessage = _getErrorMessage(e);
      return left(CustomError(errorMessage, statusCode));

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
    }
    //on DioException catch (e) {
    //   String customException = CustomDioExceptions.fromDioException(e).toString();
    //   return left(CustomError(customException, e.response?.statusCode));
    // }
    catch (e) {
      //return left(CustomError("CME Analysis Data Format Error: ${e.toString()}", 500));

      //  FALLBACK LOGIC: Agar NASA ka server down hai
      if (_shouldFallback(e)) {
        print(" Connection refused detected! Switching to Mock Data of Analysis...");
    return await _loadCmeAnalysisMockData();
    }

    // Baaki errors ke liye normal handling
    String errorMessage = _getErrorMessage(e);
    return left(CustomError(errorMessage, 500));

    }
  }

}

// Check karna ki kya error NASA server outage se related hai
bool _shouldFallback(Object e) {
  String err = e.toString().toLowerCase();
  return err.contains("503") ||
      err.contains("refused") ||
      err.contains("timeout") ||
      err.contains("failure") ||
      err.contains("upstream") ||
      err.contains("disconnect");
}

// Generic error message extractor
String _getErrorMessage(Object e) {
  if (e is DioException) {
    return CustomDioExceptions.fromDioException(e).toString();
  }
  return e.toString();
}

// 📂 Local JSON load karne ka logic (Tab 1 ke liye)
FutureResult<List<CmeModel>> _loadCmeMockData() async {
  try {
    print(" Loading CME Mock Data from assets...");
    final String response = await rootBundle.loadString('assets/data/cme_demo_data.json');
    final List<dynamic> data = json.decode(response);
    final List<CmeModel> models = data.map((json) => CmeModel.fromJson(json)).toList();
    return right(models);
  } catch (e) {
    return left(CustomError("Failed to load Demo Data: ${e.toString()}", 500));
  }
}

// 📂 Analysis Mock Data load karne ka logic
FutureResult<List<CmeAnalysisModel>> _loadCmeAnalysisMockData() async {
  try {
    print(" Loading CME Analysis Mock Data...");
    final String response = await rootBundle.loadString('assets/data/cme_analysis_demo_data.json');
    final List<dynamic> data = json.decode(response);

    final List<CmeAnalysisModel> models = data
        .map((json) => CmeAnalysisModel.fromJson(json))
        .toList();

    return right(models);
  } catch (e) {
    return left(CustomError("Failed to load Analysis Demo Data", 500));
  }
}