import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/data/network/custom_dio_exceptions.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/apod_api_service/apod_api_service.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart'; //Yeh sabse cool library hai. Iski wajah se hum Either (Left or Right) ka use kar paate hain. Matlab: "Ya toh error aayega (Left) ya data aayega (Right)".

/* ApodApiService jo json response return karti hai voh repository catch
karti hai phir use model mein convert karti h.

Model= template
ApiService= Messenger
Repository is the manager that decides how to handle the data and if
error has occurred then what to do.

Is file ka kaam hai ApiService se raw data (JSON) mangwana, use Model
mein convert karwana, aur agar internet chala jaye ya NASA ka server
down ho, toh use "Left" (Error) mein wrap karke UI ko batana.

Cleaner Logic: ApiService sirf data laati hai. Use nahi pata ki data List hai ya Map. Repository woh dimaag lagati hai.

Either (Right/Left) Pattern: Isse UI ko pata chal jata hai: "Agar Right aaya hai toh screen par images dikhao, agar Left aaya hai toh error message dikhao."

Exception Handling: UI ko Dio errors ya status codes se matlab nahi hota. Repository unhe "Insaan ki bhasha" mein convert karti hai.

Repository woh Manager hai jo ApiService se (JSON) mangwata hai, use saaf karke Model mein badalta hai, aur agar raste mein koi musibat aaye toh use handle karta hai.

End mein repository ek either return karti hai jo yah toh left yani error ya toh right yani ki success or model return karti h

*/


class ApodRepository {

  final ApodApiService _apodApiService;

  ApodRepository(this._apodApiService);

  /// Fetch apod data
  // // FutureResult: Iska matlab hai ki result do cheezon mein se ek hoga: CustomError ya List<ApodModel>.
  // FutureResult<List<ApodModel>> fetchApodList(
  //     {int? count, String? startDate, String? endDate}) async {
  //
  //   //try { ... } on DioException catch (e) { ... }
  //   //Internet se data mangwana khatarnak ho sakta hai. try matlab "Koshish karo", aur agar crash ho (jaise internet band ho), toh catch use sambhaal lega taaki app band na ho.
  //
  //   try {
  //     var response = await _apodApiService.fetchApodData(
  //       count: count,
  //       start: startDate,
  //       end: endDate,
  //     );
  //
  //     //Data Conversion (JSON to Model)
  //     //NASA kabhi ek image bhejta hai (Map) aur kabhi 5 images (List of map).
  //     final data = response.data;
  //
  //     /*
  //     If data is List: Matlab bahut saari images hain. Har ek json ko uthao aur ApodModel.fromJson
  //     ke machine mein daal kar Model bana do.
  //     */
  //     if (data is List) {
  //       final List<ApodModel> models = data.map((json) => ApodModel.fromJson(json)).toList();
  //       return right(models);
  //     }
  //     else { //Else: Matlab sirf ek image aayi hai. Use bhi list mein daal kar bhej do taaki UI ko hamesha list hi mile.
  //       final ApodModel model = ApodModel.fromJson(data);
  //       return right([model]);
  //     }
  //     // final model = apodModelFromJson(response.toString());
  //     // return right(model);
  //
  //
  //     /*Agar error aaya (jaise 404 ya No Internet), toh hum ganda sa technical error nahi dikhayenge.
  //     CustomDioExceptions class will convert the error into easy language (jaise 'No Internet')"*/
  //   } on DioException catch (e) {
  //     String customException = CustomDioExceptions
  //         .fromDioException(e)
  //         .toString();
  //     CustomError error = CustomError(customException, e.response?.statusCode);
  //     // error is packed on the left and returned
  //     return left(error);
  //   }
  // }

  FutureResult<List<ApodModel>> fetchApodList({
    int? count,
    String? startDate,
    String? endDate,
  }) async {
    try {
      var response = await _apodApiService.fetchApodData(
        count: count,
        start: startDate,
        end: endDate,
      );

      final data = response.data;

      if (data == null) {
        return left(CustomError("NASA didn't send any data. Please try again.", 404));
      }

      //2. 1. Sabse pehle List check karo (Range calls ke liye).List Parsing (Jab multiple images aati hain)
      if (data is List) {
        final List<ApodModel> models = data
            .map((json) => ApodModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return right(models);
      }

      //3. Phir Map check karo (Single date calls ke liye).Map Parsing (Jab single image aati hai)
      if (data is Map<String, dynamic>) { //  Direct Map check
        final model = ApodModel.fromJson(data);
        return right([model]);
      }

      // Agar upar ke dono cases fail ho jayein toh ye return hona chahiye
      return left(CustomError("Received Unexpected data format from NASA", 500));

    } on DioException catch (e) {
      String customMsg;// = CustomDioExceptions.fromDioException(e).toString();
      int? statusCode = e.response?.statusCode;

      if (statusCode == 500) {
        customMsg = "NASA's APOD service is temporarily struggling.";
      }
      else if (statusCode == 503 || statusCode == 504) {
        customMsg = "NASA's APOD service is currently overloaded. Please try again in a bit.";
      } else if (statusCode == 403 || statusCode == 429) {
        customMsg = "NASA API limit reached. Try again later.";
      } else if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        customMsg = "NASA server took too long to respond. Connection timed out.";
      } else if (e.message?.toLowerCase().contains('socket') ?? false) {
        customMsg = "No internet connection. Check your network.";
      } else if (e.response?.data is String && (e.response?.data as String).toLowerCase().contains("<html")) {
        customMsg = "NASA server is busy or the date range is too large. Try a shorter range.";
      } else {
        // Agar upar ka kuch match nahi hua, toh purana generic handler use karo
        customMsg = CustomDioExceptions.fromDioException(e).toString();
      }
      return left(CustomError(customMsg, statusCode));

    } catch (e) {
      // Kisi bhi aur anjaan error ke liye ye catch block zaroori hai
      return left(CustomError("Unexpected Error: ${e.toString()}", 500));
    }
  }
}