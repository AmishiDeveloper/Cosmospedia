import 'package:cosmospedia/src/data/network/data_source/api_service.dart';
import 'package:cosmospedia/src/data/network/dio_client.dart';

class SpaceDevApiService extends ApiService{
  SpaceDevApiService(DioClient dioClient):super(dioClient);//getIt<DioClient>(instanceName:'nasaClient')
}

