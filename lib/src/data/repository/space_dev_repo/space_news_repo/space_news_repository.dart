import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_event_model.dart' as events;
import 'package:cosmospedia/src/data/model/space_news_models/space_launches_model.dart' as launches;
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_news_missions_model.dart' as news_missions;
import 'package:cosmospedia/src/data/network/custom_dio_exceptions.dart';
import 'package:cosmospedia/src/data/network/data_source/space_dev/space_news/launch_library_api_service/launch_library_api_service.dart';
import 'package:cosmospedia/src/data/network/data_source/space_dev/space_news/space_flight_news_api_service/space_flight_news_api_service.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class SpaceNewsRepository{

  final SpaceFlightNewsApiService _spaceFlightNewsApiService;
  final LaunchLibraryApiService _launchLibraryApiService;

  SpaceNewsRepository(this._spaceFlightNewsApiService,this._launchLibraryApiService);


  FutureResult<List<SpaceContent>> fetchCombinedFeed({
    int limit=50,
    DateTime? targetDate, //Global calendar
  }) async {
    try {
      // 1. Parallel calls to api
      final results = await Future.wait([
        fetchNewsArticles(limit:limit),
        fetchMissions(limit:limit),
        fetchEvents(limit:limit),
        fetchLaunches(limit:limit),
      ]);

      // 2. Teeno lists ko ek master list mein merge karo
      List<SpaceContent> combinedList = [];

      // // 2. Debugging loop
      // for (int i = 0; i < results.length; i++) {
      //   results[i].fold(
      //         (error) => print("REPO ERROR in API #$i: ${error.message}"),
      //         (data) {
      //       print("REPO SUCCESS: API #$i gave ${data.length} items");
      //       combinedList.addAll(data);
      //     },
      //   );
      // }

      ///when debugging not needed uncomment this and comment the above code
      for (var list in results) {
        // list yahan 'Either<CustomError, List<SpaceContent>>' hai . 'list' ke andar ka 'data' nikal kar add karna hai
        list.fold(
            (error)=> print("REPO ERROR: ${error.message}"),
            (data) {
          print("REPO SUCCESS: Got ${data.length} items of type ${data.isEmpty ? '?' : data[0].typeValue}");
              combinedList.addAll(data);
            }
        );
      }

      if (combinedList.isEmpty) {
        print("REPO: Combined list is EMPTY!");
        return left(CustomError("No data found from any source", 404));
      }
      print("REPO: Total items before sort: ${combinedList.length}");

      // --- NAYA LOGIC START ---

      final now = DateTime.now();

      // --- LOGIC A: AGAR AAJ KI DATE HAI (DEFAULT VIEW) ---
      if (targetDate == null || _isSameDay(targetDate, now)) {
        // 1. Upcoming Slider (Future Data) - Max 16 Near Future First
        final upcoming = combinedList
            .where((item) => item.publishedAtDate.isAfter(now))
            .toList();
        // NEAR FUTURE FIRST: Ascending order (2024 -> 2025 -> 2035)
        upcoming.sort((a, b) => a.publishedAtDate.compareTo(b.publishedAtDate));
        final limitedUpcoming = upcoming.take(16).toList();

        // 2. Recent Highlights (Past/Today) - 10 per category latest first to past data
        final pastData = combinedList.where((item) => !item.publishedAtDate.isAfter(now)).toList();

        final news = pastData.where((e) => e.typeValue == 'news').take(10).toList();
        final launches = pastData.where((e) => e.typeValue == 'launches').take(10).toList();
        final events = pastData.where((e) => e.typeValue == 'events').take(10).toList();
        final missions = pastData.where((e) => e.typeValue == 'missions').take(10).toList();

        List<SpaceContent> recentHighlights = [...news, ...launches, ...events, ...missions];
        // LATEST PAST FIRST: Descending order (Today -> Yesterday -> Last Week)
        recentHighlights.sort((a, b) => b.publishedAtDate.compareTo(a.publishedAtDate));

        // Slider + Recent List merge karke bhej rahe hain
        return right([...limitedUpcoming, ...recentHighlights]);
      }

      // --- LOGIC B: AGAR CALENDAR SE PURANI DATE SELECT KI HAI ---
      else {
        // Sirf wahi data dikhao jo us specific date ka ho (No Slider)
        final filteredByDate = combinedList
            .where((item) => _isSameDay(item.publishedAtDate, targetDate))
            .toList();

        filteredByDate.sort((a, b) => b.publishedAtDate.compareTo(a.publishedAtDate));
        return right(filteredByDate);
      }

    } catch (e) {
      print("REPO FATAL ERROR: $e");
      return left(
        CustomError("News Feed Merging Error: ${e.toString()}", 500),
      );
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

///old logic
  // ALL CHIP: Charo APIs ka data fetch karke merge aur sort karega.
  // FutureResult<List<SpaceContent>> fetchCombinedFeed({
  //  int limit=50,
  // }) async {
  //   try {
  //     // 1. Parallel calls to api
  //     final results = await Future.wait([
  //       fetchNewsArticles(limit:limit),
  //       fetchMissions(limit:limit),
  //       fetchEvents(limit:limit),
  //       fetchLaunches(limit:limit),
  //     ]);
  //
  //     // 2. Teeno lists ko ek master list mein merge karo
  //     List<SpaceContent> combinedList = [];
  //
  //     // 2. Debugging loop
  //     for (int i = 0; i < results.length; i++) {
  //       results[i].fold(
  //             (error) => print("REPO ERROR in API #$i: ${error.message}"),
  //             (data) {
  //           print("REPO SUCCESS: API #$i gave ${data.length} items");
  //           combinedList.addAll(data);
  //         },
  //       );
  //     }
  //
  //     ///when debugging not needed uncomment this and comment the above code
  //     // for (var list in results) {
  //     //   // list yahan 'Either<CustomError, List<SpaceContent>>' hai . 'list' ke andar ka 'data' nikal kar add karna hai
  //     //   list.fold(
  //     //       (error)=> print("REPO ERROR: ${error.message}"),
  //     //       (data) {
  //     //     print("REPO SUCCESS: Got ${data.length} items of type ${data.isEmpty ? '?' : data[0].typeValue}");
  //     //         combinedList.addAll(data);
  //     //       }
  //     //   );
  //     // }
  //
  //     if (combinedList.isEmpty) {
  //       print("REPO: Combined list is EMPTY!");
  //       return left(CustomError("No data found from any source", 404));
  //     }
  //     print("REPO: Total items before sort: ${combinedList.length}");
  //
  //    // --- NAYA LOGIC START ---
  //
  //     final now = DateTime.now();
  //     // A. UPCOMING (Future Data) - Slider ke liye
  //     // Logic: Jo aaj ke baad hai, usey Soonest First (asc) sort karke top 16 lo
  //     final upcoming = combinedList
  //         .where((item) => item.publishedAtDate.isAfter(now))
  //         .toList();
  //     upcoming.sort((a, b) => a.publishedAtDate.compareTo(b.publishedAtDate)); // Soonest first
  //     final limitedUpcoming = upcoming.take(16).toList();
  //
  //     // B. RECENT HIGHLIGHTS (Past/Today Data) - 10 per category
  //     // Pehle data ko filter karo jo future ka nahi hai
  //     final pastData = combinedList.where((item) => !item.publishedAtDate.isAfter(now)).toList();
  //
  //     final news = pastData.where((e) => e.typeValue == 'news').take(10).toList();
  //     final launches = pastData.where((e) => e.typeValue == 'launches').take(10).toList();
  //     final events = pastData.where((e) => e.typeValue == 'events').take(10).toList();
  //     final missions = pastData.where((e) => e.typeValue == 'missions').take(10).toList();
  //
  //     // In 40 items ko mix karke "Latest First" sort karo
  //     List<SpaceContent> recentHighlights = [...news, ...launches, ...events, ...missions];
  //     recentHighlights.sort((a, b) => b.publishedAtDate.compareTo(a.publishedAtDate));
  //
  //     // C. FINAL MERGE
  //     // UI ko ek single list milegi jisme pehle 16 Future items honge, phir Past items
  //     final finalSortedList = [...limitedUpcoming, ...recentHighlights];
  //
  //     print("REPO: Final List Created. total Upcoming: ${limitedUpcoming.length}");
  //
  //     print("RECENT highlights: ${recentHighlights.length} where, News=${news.length}, Launch=${launches.length}, Event=${events.length}, Mission=${missions.length}");
  //
  //     return right(finalSortedList);
  //
  //     //old logic
  //     // // 3. Date ke hisaab se Sorting (Latest first) using Interface getter
  //     // combinedList.sort((a, b) => b.publishedAtDate.compareTo(a.publishedAtDate));
  //     //
  //     // return right(combinedList);
  //   } catch (e) {
  //     print("REPO FATAL ERROR: $e");
  //     return left(
  //       CustomError("News Feed Merging Error: ${e.toString()}", 500),
  //     );
  //   }
  // }

    // fetch news articles api


    FutureResult<List<SpaceContent>> fetchNewsArticles({required int limit}) async {
    try {
      var response = await _spaceFlightNewsApiService.fetchNewsArticlesData(limit:limit);

      if (response.data != null) {
        // Sab sahi hai, parse karo
        // Direct factory method use karein parsing ke liye
        final news_missions.SpaceNewsMissionsModel model = news_missions.SpaceNewsMissionsModel.fromJson(
          response.data,
        );
        // Safe Mapping:
        // 1. Check if results is null
        // 2. Filter out non-Result types (safety first)
        // 3. Convert to List<SpaceContent>
        final List<SpaceContent> contentList = (model.results ?? [])
            .whereType<news_missions.Result>() // Sirf wahi items uthao jo Result type ke hain (null safety)
            //.map((e) => e as SpaceContent) // Forcefully cast karne ki jagah mapping
            .toList();


        // 2. Ab is model ke andar se sirf 'results' (List) bahar nikaal kar return karo
        // Taaki hum ise Launches aur Events ke saath merge kar sakein
        return right(contentList);
      } else {
        // Server ne 'OK' toh bola, par data gayab hai!
        // Ye ek Logic Error hai, isliye manually 'left' return karna padta hai.
        return left(CustomError("No news found", 204));
      }
    } on DioException catch (e) {
      String customException = CustomDioExceptions.fromDioException(e).toString();
      CustomError error = CustomError(customException, e.response?.statusCode);
      // error is packed on the left and returned
      return left(error);
    } catch (e) {
      // Agar parsing fail ho jaye (Model error)
      return left(CustomError("Data Format Error: ${e.toString()}", 500));
     }
  }


  // fetch missions api
  FutureResult<List<SpaceContent>> fetchMissions({required int limit}) async {
    try {
      var response = await _spaceFlightNewsApiService.fetchMissionsData(limit:limit);

      if (response.data != null) {
        // Sab sahi hai, parse karo
        // Direct factory method use karein parsing ke liye
        final news_missions.SpaceNewsMissionsModel model = news_missions.SpaceNewsMissionsModel.fromJson(
          response.data,
        );
        // Safe Mapping:
        // 1. Check if results is null
        // 2. Filter out non-Result types (safety first)
        // 3. Convert to List<SpaceContent>
        final List<SpaceContent> contentList = (model.results ?? [])
            .whereType<news_missions.Result>() // Sirf wahi items uthao jo Result type ke hain (null safety)
            .map((e) {
              return MissionWrapper(e);
            }).toList();


        // 2. Ab is model ke andar se sirf 'results' (List) bahar nikaal kar return karo
        // Taaki hum ise Launches aur Events ke saath merge kar sakein
        return right(contentList);
      } else {
        // Server ne 'OK' toh bola, par data gayab hai!
        // Ye ek Logic Error hai, isliye manually 'left' return karna padta hai.
        return left(CustomError("No missions found", 204));
      }
    } on DioException catch (e) {
      String customException = CustomDioExceptions.fromDioException(e).toString();
      CustomError error = CustomError(customException, e.response?.statusCode);
      // error is packed on the left and returned
      return left(error);
    } catch (e) {
      // Agar parsing fail ho jaye (Model error)
      return left(CustomError("Data Format Error: ${e.toString()}", 500));
    }
  }

  // events
  FutureResult<List<SpaceContent>> fetchEvents({required int limit}) async {
    try {
      var response = await _launchLibraryApiService.fetchEventsData(limit:limit);

      if (response.data != null) {
        // Sab sahi hai, parse karo
        // Direct factory method use karein parsing ke liye
        final events.SpaceEventsModel model = events.SpaceEventsModel.fromJson(response.data);
        // Safe Mapping to interface:
        // 1. Check if results is null
        // 2. Filter out non-Result types (safety first)
        // 3. Convert to List<SpaceContent>
        final List<SpaceContent> contentList = (model.results ?? [])
            .whereType<events.Result>() // Sirf wahi items uthao jo Result type ke hain (null safety)
            .map((e) => e as SpaceContent) // Forcefully cast karne ki jagah mapping
            .toList();


        // 2. Ab is model ke andar se sirf 'results' (List) bahar nikaal kar return karo
        // Taaki hum ise Launches aur Events ke saath merge kar sakein
        return right(contentList);
      } else {
        // Server ne 'OK' toh bola, par data gayab hai!
        // Ye ek Logic Error hai, isliye manually 'left' return karna padta hai.
        return left(CustomError("No events found", 204));
      }
    } on DioException catch (e) {
      String customException = CustomDioExceptions.fromDioException(e).toString();
      CustomError error = CustomError(customException, e.response?.statusCode);
      // error is packed on the left and returned
      return left(error);
    } catch (e) {
      // Agar parsing fail ho jaye (Model error)
      return left(CustomError("Data Format Error: ${e.toString()}", 500));
    }
  }

  //launches
// events
  FutureResult<List<SpaceContent>> fetchLaunches({required int limit}) async {
    try {
      var response = await _launchLibraryApiService.fetchLaunchesData(limit:limit);

      if (response.data != null) {
        // Sab sahi hai, parse karo
        // Direct factory method use karein parsing ke liye
        final launches.SpaceLaunchesModel model = launches.SpaceLaunchesModel.fromJson(response.data);
        // Safe Mapping to interface:
        // 1. Check if results is null
        // 2. Filter out non-Result types (safety first)
        // 3. Convert to List<SpaceContent>
        final List<SpaceContent> contentList = (model.results ?? [])
            .whereType<launches.Result>() // Sirf wahi items uthao jo Result type ke hain (null safety)
            .map((e) => e as SpaceContent) // Forcefully cast karne ki jagah mapping
            .toList();


        // 2. Ab is model ke andar se sirf 'results' (List) bahar nikaal kar return karo
        // Taaki hum ise Launches aur Events ke saath merge kar sakein
        return right(contentList);
      } else {
        // Server ne 'OK' toh bola, par data gayab hai!
        // Ye ek Logic Error hai, isliye manually 'left' return karna padta hai.
        return left(CustomError("No launches found", 204));
      }
    } on DioException catch (e) {
      String customException = CustomDioExceptions.fromDioException(e).toString();
      CustomError error = CustomError(customException, e.response?.statusCode);
      // error is packed on the left and returned
      return left(error);
    } catch (e) {
      // Agar parsing fail ho jaye (Model error)
      return left(CustomError("Data Format Error: ${e.toString()}", 500));
    }
  }

}

class MissionWrapper implements SpaceContent {
  final news_missions.Result original;
  MissionWrapper(this.original);

  @override String get idValue => original.idValue;
  @override String get titleValue => original.titleValue;
  @override String get imageUrlValue => original.imageUrlValue;
  @override String get newsSiteValue => original.newsSiteValue;
  @override String get summaryValue => original.summaryValue;
  @override DateTime get publishedAtDate => original.publishedAtDate;
  @override DateTime get updatedAtDate => original.updatedAtDate;
  @override String get formattedDate => original.formattedDate;
  // --- Yahan humne News ko Missions mein badal diya ---
  @override String get typeValue => "missions";
}