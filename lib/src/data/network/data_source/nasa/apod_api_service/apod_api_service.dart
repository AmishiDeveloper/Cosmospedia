/*NASA ke server par ja kar Data request dene ka kaam ye file karti
hai.

Api Service is used to hit the api means send the data request to the server and receive the data response from the server

ApodApiService NASA ke server par ja kar "Order" yani ki data request jo user ko chahiye h dekar aata hai aur jo bhi data milta hai (acha ya bura) use wapas le aata hai user tak.
*/


// NasaApiService ko extend karke specific endpoints likhein
import 'package:cosmospedia/src/core/const/endpoints/endpoints.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/nasa_api_service.dart';
import 'package:cosmospedia/src/data/network/dio_client.dart';//ek "Base Service" banayi hui hai (NasaApiService) jisme internet se connect hone ka basic setup (Dio ya Http) pehle se hai. Hum use reuse kar rahe hain.

//apod related apis
class ApodApiService extends NasaApiService {

  // Constructor zaroori hai taaki super class (NasaApiService) initialize ho sake
  ApodApiService(DioClient dioClient):super(dioClient);

  //Future<dynamic>: Iska matlab hai ki ye kaam "Future" mein poora hoga (internet slow ho sakta hai ya kaam karne mein time lag sakta h), tab tak app ko wait karna padega.
  // fetch apod data
  Future<dynamic> fetchApodData({
    int? count,
    String? start,
    String? end,
  }) async {

    // 'get' method is defined in the DioClient class now cant directly use get method because the ApiService class does not extend the DioClient Class
    // only creates a reference of DioClient class which gets initialized by the NasaApiService class when through its constructor super i.e ApiService constructor is called and
    // DioClient reference api becomes an object as it gets instantiated. Had the ApiService class extended the DioClient class and then when NasaApiService class extended the
    // ApiService class then the ApodApiService that extended the NasaApiService class would be able to use the get method directly since child class can use parent class
    // properties but since DioCient is not extended and its reference is created api.get() has to be used

    Map<String, dynamic> queryParams = {};

    // CASE 1: Carousel / Random request
    if (count != null) {
      // 15 items so that after local shuffle random apod are shown
      queryParams['per_page'] = 15;
    }
    // CASE 2: Single Date (Same Start & End)
    else if (start != null && end != null && start == end) {
      queryParams['before'] = end;
      queryParams['after'] = start;
      queryParams['per_page'] = 1;
    }
    // CASE 3: Date Range
    else if (start != null && end != null) {
      DateTime startDt = DateTime.parse(start);
      DateTime endDt = DateTime.parse(end);

      // Calculate exact number of days
      int totalDays = endDt.difference(startDt).inDays + 1;

      queryParams['before'] = end;
      queryParams['after'] = start;
      queryParams['per_page'] = totalDays; // Utne hi items maango jitne din hain!
    }


    var response= await api.get(
      Endpoints.apod,
      // queryParameters: {
      //   if (count != null) 'count': count,
      //   if (start != null) 'start_date': start,
      //   if (end != null) 'end_date': end,
      //   'api_key': "DEMO_KEY",//Endpoints.nasaApiKey,
      // },
      queryParameters: queryParams,
    );
    return response; // this response in json format is give to the repository that will call this fetchApodData() method. here ApodRepository calls this function
  }
}
