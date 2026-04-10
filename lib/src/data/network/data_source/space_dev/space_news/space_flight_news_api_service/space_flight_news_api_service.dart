import 'package:cosmospedia/src/core/const/endpoints/endpoints.dart';
import 'package:cosmospedia/src/data/network/data_source/space_dev/space_dev_api_service.dart';
import 'package:cosmospedia/src/data/network/dio_client.dart';

class SpaceFlightNewsApiService extends SpaceDevApiService{
  SpaceFlightNewsApiService(DioClient dioClient):super(dioClient);//getIt<DioClient>(instanceName:'spaceFlightNewsClient'));

// 1. Fetch News Articles
  Future<dynamic> fetchNewsArticlesData({required int limit}) async {
    var response = await api.get(
      Endpoints.newsArticles, // Maan lete hain ye /articles hai
      queryParameters: {
        'limit': limit,
        'ordering': '-published_at', // '-' ka matlab Latest First
      },
    );
    return response;
  }

  // 2. Fetch Missions (SpaceFlight News mein aksar ye 'blogs' ya 'reports' hote hain)
  // Agar aapka specific missions endpoint hai toh wo use karein
  Future<dynamic> fetchMissionsData({required int limit}) async {
    var response = await api.get(
      Endpoints.missions, // Missions ka data aksar Blogs endpoint se milta hai SNAPI mein
      queryParameters: {
        'limit': limit,
        'ordering': '-published_at', // '-' ka matlab Latest First
      },
    );
    return response;
  }
}