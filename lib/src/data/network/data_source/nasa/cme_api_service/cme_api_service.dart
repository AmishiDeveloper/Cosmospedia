import 'package:cosmospedia/src/core/const/endpoints/endpoints.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/nasa_api_service.dart';
import 'package:cosmospedia/src/data/network/dio_client.dart';

class CmeApiService extends NasaApiService{
  CmeApiService(DioClient dioClient):super(dioClient);


  //CME Events API: Suraj par kab explosions huye
  Future<dynamic> fetchCmeData({String? start, String? end}) async{

    var response=  await api.get(
      Endpoints.cme,
      queryParameters: {
        'api_key': Endpoints.nasaApiKey,
        if (start != null) 'startDate': start,
        if (end != null) 'endDate': end,
      },
    );
    return response;
  }

  //CME Analysis API: Un explosions ki speed/direction kya thi
  Future<dynamic> fetchCmeAnalysisData({
    String? start,
    String? end,
    bool mostAccurateOnly = true,
  }) async{

    var response=  await api.get(
      Endpoints.cmeAnalysis,
      queryParameters: {
        'api_key': Endpoints.nasaApiKey,
        if (start != null) 'startDate': start,
        if (end != null) 'endDate': end,
        'mostAccurateOnly': mostAccurateOnly,
      },
    );
    return response;
  }

}