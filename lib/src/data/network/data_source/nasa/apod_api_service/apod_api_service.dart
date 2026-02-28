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
  Future<dynamic> fetchApodData({int? count, String? start, String? end}) async {

    // 'get' method is defined in the DioClient class now cant directly use get method because the ApiService class does not extend the DioClient Class
    // only creates a reference of DioClient class which gets initialized by the NasaApiService class when through its constructor super i.e ApiService constructor is called and
    // DioClient reference api becomes an object as it gets instantiated. Had the ApiService class extended the DioClient class and then when NasaApiService class extended the
    // ApiService class then the ApodApiService that extended the NasaApiService class would be able to use the get method directly since child class can use parent class
    // properties but since DioCient is not extended and its reference is created api.get() has to be used

    var response= await api.get(
      Endpoints.apod,
      queryParameters: {
        'api_key': Endpoints.nasaApiKey,
        if (count != null) 'count': count,
        if (start != null) 'start_date': start,
        if (end != null) 'end_date': end,
      },
    );
    return response; // this response in json format is give to the repository that will call this fetchApodData() method. here ApodRepository calls this function
  }
}
