import 'package:cosmospedia/src/core/const/endpoints/endpoints.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/nasa_api_service.dart';
import 'package:cosmospedia/src/data/network/dio_client.dart';

class AsteroidApiService extends NasaApiService{

  AsteroidApiService(DioClient dioClient):super(dioClient);

  Future<dynamic> fetchAsteroidData({String? start, String? end}) async{

    var response=  await api.get(
        Endpoints.asteroidFeed,
      queryParameters: {
        'api_key': Endpoints.nasaApiKey,
        if (start != null) 'start_date': start,
        if (end != null) 'end_date': end,
      },
    );
    return response;
  }

  Future<dynamic> fetchAsteroidLookupData({required String asteroidId}) async{

    var response=  await api.get(
      '${Endpoints.asteroidLookup}/$asteroidId',
      queryParameters: {
        'api_key': Endpoints.nasaApiKey,
      },
    );
    return response;
  }

}