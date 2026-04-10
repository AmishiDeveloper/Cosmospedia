import 'package:cosmospedia/src/core/const/endpoints/endpoints.dart';
import 'package:cosmospedia/src/data/network/data_source/space_dev/space_dev_api_service.dart';
import 'package:cosmospedia/src/data/network/dio_client.dart';

class LaunchLibraryApiService extends SpaceDevApiService{
  LaunchLibraryApiService(DioClient dioClient):super(dioClient);//getIt<DioClient>(instanceName:'launchLibraryClient'));

  // 3. Fetch Events (SNAPI v4 mein events ka alag endpoint hota hai)
  Future<dynamic> fetchEventsData({required int limit}) async {
    var response = await api.get(
      Endpoints.events, // Maan lete hain ye /events hai
      queryParameters: {
        'limit': limit,
        'ordering': '-date', // Events ke liye '-date' latest data layega
      },
    );
    return response;
  }

  // 4. Fetch Launches (Agar SNAPI se hi launches ka metadata chahiye)
  Future<dynamic> fetchLaunchesData({required int limit}) async {
    var response = await api.get(
      Endpoints.launches, // Maan lete hain ye /launches hai
      queryParameters: {
        'limit': limit,
        'ordering': '-net', //'-net' matlab latest launch date pehle
      },
    );
    return response;
  }

}