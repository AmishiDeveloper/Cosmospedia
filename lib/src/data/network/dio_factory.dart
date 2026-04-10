import 'package:cosmospedia/src/core/const/endpoints/endpoints.dart';
import 'package:dio/dio.dart';

/*DioFactory is a factory class that centralizes the creation of Dio
 instances with different base URLs, making the networking layer clean,
 reusable, and easy to scale when working with multiple APIs.*/
class DioFactory {

  /*Creates a new Dio instance
  Sets the baseUrl to NASA’s API
  Returns that Dio*/
  static Dio nasa() {
    return Dio(
      BaseOptions(
        baseUrl: Endpoints.nasaBaseUrl,
      ),
    );
  }

  /*Creates a new Dio instance
  Configured only for SpaceFlight API
  Returns it*/
  static Dio spaceFlightNewsApi() {
    return Dio(
      BaseOptions(
        baseUrl: Endpoints.spaceFlightNewsBaseUrl,
      ),
    );
  }

  /*Creates a new Dio instance
  Configured only for launchLibrary2  API
  Returns it*/
  static Dio launchLibrary() {
    return Dio(
      BaseOptions(
        baseUrl: Endpoints.spaceLaunchLibraryBaseUrl,
      ),
    );
  }
}
