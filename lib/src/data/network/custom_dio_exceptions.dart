import 'package:dio/dio.dart';
//CustomDioExceptions is a centralized error-handling class that converts
//low-level DioException and HTTP status codes into clean,
    //user-friendly error messages for the UI.
//Dio throws DioException
//         ↓
// CustomDioExceptions catches it
//         ↓
// Maps error type / status code
//         ↓
// Produces clean message
//         ↓
// UI shows message

class CustomDioExceptions implements Exception {
  late String message;

  //This is a named constructor
  // It takes only DioException
  // Converts Dio’s error → my app’s error
  CustomDioExceptions.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel://User leaves screen, API call is aborted
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout://Internet slow, Server not reachable
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout: //Server took too long to send data
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse: //Server responded ,But status code is 4xx or 5xx
        message = _handleStatusError(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout://Request body could not be sent in time
        message = "Send timeout in connection with API server";
        break;
      case DioExceptionType.unknown://No internet, DNS failure, Socket exception
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleStatusError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:         //Some APIs return:{ "message": "Invalid API key" }.If message exists → show it ,If not → show safe default
        return error["message"] ?? 'Bad request';
      case 401:
        return error["message"] ?? 'Unauthorized';
      case 403:
        return error["message"] ?? 'Forbidden';
      case 404:
        return error["message"] ?? 'Not Found';
      case 422:
        return error["message"] ?? 'Can not proceed with the data provided.';
      case 406:
        return error["message"] ?? 'Input Mismatched';
      case 500:
        return error["message"] ?? 'Internal server error';
      case 502:
        return error["message"] ?? 'Bad gateway';
      default:
        return error["message"] ?? 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
