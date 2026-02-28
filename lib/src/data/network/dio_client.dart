import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// DioCient is Dio wrapper for all API requests
/// DioClient is your app’s single, centralized network layer.
// It wraps Dio, configures it once, logs requests, and exposes clean HTTP methods so the rest of your app never worries about networking details.
class DioClient {

  /*_dio is private
   This ensures:
   no one modifies Dio config directly
   all calls go through DioClient*/
  final Dio _dio;

  /*Constructor of DioClient
  You are injecting Dio from outside (via Service Locator).*/
  DioClient(this._dio) {
    _dio
      //..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = const Duration(seconds: 60) //tells how long to wait to connect
      ..options.receiveTimeout = const Duration(seconds: 60) //tells how long to wait for data
      ..options.responseType = ResponseType.json //auto-decode JSON
      ..options.contentType = Headers.jsonContentType //send JSON by default
      ..interceptors.add(
        PrettyDioLogger(    //This prints:request URL, headers,body,response body
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          compact: true,
        ),
      );
  }

  /// send GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow; //Errors passed upward (handled later in repo)
    }
  }

  /// send POST request
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// send PUT request
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// send DELETE request
  Future<dynamic> delete(  //DELETE returns dynamic because Some APIs return empty body Some return JSON
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// send DOWNLOAD request
  Future<dynamic> download(  //Used for:images,PDFs,videos,datasets
    String url,
    dynamic savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
