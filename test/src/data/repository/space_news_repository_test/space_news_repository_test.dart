// import 'package:cosmospedia/src/data/model/space_news_models/space_event_model.dart' as events;
// import 'package:cosmospedia/src/data/model/space_news_models/space_launches_model.dart' as launches;
// import 'package:cosmospedia/src/data/model/space_news_models/space_news_missions_model.dart' as news_missions;
// import 'package:cosmospedia/src/data/network/data_source/space_dev/space_news/launch_library_api_service/launch_library_api_service.dart';
// import 'package:cosmospedia/src/data/network/data_source/space_dev/space_news/space_flight_news_api_service/space_flight_news_api_service.dart';
// import 'package:cosmospedia/src/data/repository/space_dev_repo/space_news_repo/space_news_repository.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
//
// class MockSpaceFlightNewsApi extends Mock implements SpaceFlightNewsApiService {}
// class MockLaunchLibraryApi extends Mock implements LaunchLibraryApiService {}
//
// void main() {
//   late SpaceNewsRepository repository;
//   late MockSpaceFlightNewsApi mockNewsApi;
//   late MockLaunchLibraryApi mockLaunchApi;
//
//   setUp(() {
//     mockNewsApi = MockSpaceFlightNewsApi();
//     mockLaunchApi = MockLaunchLibraryApi();
//     repository = SpaceNewsRepository(mockNewsApi, mockLaunchApi);
//   });
//   group('Individual API Fetch Tests', () {
//
//     //Success: Data mil gaya aur sahi se parse hua.
//     test('fetchNewsArticles returns Right list on success', () async {
//       final mockData = {"results": [{"id": 1, "title": "News", "image_url": "url", "published_at": "2026-04-21T12:00Z"}]};
//       when(() => mockNewsApi.fetchNewsArticlesData(limit: 50))
//           .thenAnswer((_) async => Response(data: mockData, requestOptions: RequestOptions(path: '')));
//
//       final result = await repository.fetchNewsArticles(limit: 50);
//       expect(result.isRight(), true);
//     });
//
//     //Empty (204): Response aaya par data null tha.
//     test('fetchEvents returns Left(204) when data is null', () async {
//       when(() => mockLaunchApi.fetchEventsData(limit: 50))
//           .thenAnswer((_) async => Response(data: null, requestOptions: RequestOptions(path: '')));
//
//       final result = await repository.fetchEvents(limit: 50);
//       result.fold((l) => expect(l.code, 204), (r) => fail("Should be error"));
//     });
//
//     //Dio Error: API crash ho gayi.
//     test('fetchLaunches returns Left on DioException', () async {
//       when(() => mockLaunchApi.fetchLaunchesData(limit: 50)).thenThrow(
//           DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionTimeout)
//       );
//
//       final result = await repository.fetchLaunches(limit: 50);
//       expect(result.isLeft(), true);
//     });
//   });
//}
import 'package:cosmospedia/src/data/network/data_source/space_dev/space_news/launch_library_api_service/launch_library_api_service.dart';
import 'package:cosmospedia/src/data/network/data_source/space_dev/space_news/space_flight_news_api_service/space_flight_news_api_service.dart';
import 'package:cosmospedia/src/data/repository/space_dev_repo/space_news_repo/space_news_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSpaceFlightNewsApi extends Mock implements SpaceFlightNewsApiService {}

class MockLaunchLibraryApi extends Mock implements LaunchLibraryApiService {}

void main() {
  late SpaceNewsRepository repository;
  late MockSpaceFlightNewsApi mockNewsApi;
  late MockLaunchLibraryApi mockLaunchApi;

  setUp(() {
    mockNewsApi = MockSpaceFlightNewsApi();
    mockLaunchApi = MockLaunchLibraryApi();
    repository = SpaceNewsRepository(mockNewsApi, mockLaunchApi);
  });

  Response mockResponse(dynamic data) {
    return Response(
      data: data,
      requestOptions: RequestOptions(path: ''),
    );
  }

  group('SpaceNewsRepository - Individual API Tests', () {
    const int testLimit = 150;

    test('fetchNewsArticles returns Right list on success', () async {
      final mockData = {
        "results": [
          {
            "id": 1,
            "title": "News",
            "image_url": "url",
            "published_at": "2026-04-21T12:00Z",
          },
        ],
      };
      when(
        () => mockNewsApi.fetchNewsArticlesData(limit: testLimit),
      ).thenAnswer((_) async => mockResponse(mockData));

      final result = await repository.fetchNewsArticles(limit: testLimit);
      expect(result.isRight(), true);
    });

    test(
      'fetchMissions returns Right MissionWrapper list on success',
      () async {
        final mockData = {
          "results": [
            {
              "id": 10,
              "title": "Mission",
              "image_url": "url",
              "published_at": "2026-04-21T12:00Z",
            },
          ],
        };
        when(
          () => mockNewsApi.fetchMissionsData(limit: testLimit),
        ).thenAnswer((_) async => mockResponse(mockData));

        final result = await repository.fetchMissions(limit: testLimit);
        expect(result.isRight(), true);
        result.fold((l) => null, (r) => expect(r.first.typeValue, "missions"));
      },
    );

    test('fetchEvents returns Left(204) when data is null', () async {
      when(
        () => mockLaunchApi.fetchEventsData(limit: testLimit),
      ).thenAnswer((_) async => mockResponse(null));

      final result = await repository.fetchEvents(limit: testLimit);
      result.fold((l) => expect(l.code, 204), (r) => fail("Should be error"));
    });

    test('fetchLaunches returns Left on DioException', () async {
      when(() => mockLaunchApi.fetchLaunchesData(limit: testLimit)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.fetchLaunches(limit: testLimit);
      expect(result.isLeft(), true);
    });
  });

  group('SpaceNewsRepository - fetchCombinedFeed (Main Logic)', () {
    const int repoLimit = 150;

    test('filters out data older than 7 days and merges correctly', () async {
      final now = DateTime.now();
      final futureDate = now.add(const Duration(days: 5)).toIso8601String();
      final freshDate = now.subtract(const Duration(days: 1)).toIso8601String();
      final oldDate = now.subtract(const Duration(days: 10)).toIso8601String();


      final mockNews = {
        "results": [
          {
            "id": 1, // Integer ID
            "title": "Fresh",
            "published_at": freshDate,
            "image_url": "url",
            "news_site": "NASA",
            "summary": "Summary",
          },
          {
            "id": 2, // Integer ID
            "title": "Old",
            "published_at": oldDate,
            "image_url": "url",
            "news_site": "ESA",
            "summary": "Summary",
          },
        ],
      };

      final mockLaunch = {
        "results": [
          {
            "id": 3, // Integer ID
            "name": "Upcoming",
            "net": futureDate,
            "image_url": "url",
            "status": {"name": "Go"},
            "launch_service_provider": {"name": "SpaceX"},
            "mission": {"name": "Moon Mission"},
          },
        ],
      };

      when(
        () => mockNewsApi.fetchNewsArticlesData(limit: repoLimit),
      ).thenAnswer((_) async => mockResponse(mockNews));
      when(
        () => mockNewsApi.fetchMissionsData(limit: repoLimit),
      ).thenAnswer((_) async => mockResponse({"results": []}));
      when(
        () => mockLaunchApi.fetchEventsData(limit: repoLimit),
      ).thenAnswer((_) async => mockResponse({"results": []}));
      when(
        () => mockLaunchApi.fetchLaunchesData(limit: repoLimit),
      ).thenAnswer((_) async => mockResponse(mockLaunch));

      final result = await repository.fetchCombinedFeed(limit: repoLimit);

      expect(result.isRight(), true);
      result.fold((l) => fail("Error: ${l.message}"), (feed) {
        final titles = feed.map((e) => e.titleValue).toList();
        print("Titles found in feed: $titles");

        expect(
          titles.contains("Fresh"),
          true,
          reason: "Recent highlights missing 'Fresh'",
        );
        expect(
          titles.contains("Upcoming"),
          true,
          reason: "Slider highlights missing 'Upcoming'",
        );
        expect(
          titles.contains("Old"),
          false,
          reason: "Old news should have been filtered out",
        );
      });
    });

    group('Fatal Errors', () {
      test('returns Left(404) when all sources are empty', () async {
        final empty = {"results": []};
        when(
          () => mockNewsApi.fetchNewsArticlesData(limit: any(named: 'limit')),
        ).thenAnswer((_) async => mockResponse(empty));
        when(
          () => mockNewsApi.fetchMissionsData(limit: any(named: 'limit')),
        ).thenAnswer((_) async => mockResponse(empty));
        when(
          () => mockLaunchApi.fetchEventsData(limit: any(named: 'limit')),
        ).thenAnswer((_) async => mockResponse(empty));
        when(
          () => mockLaunchApi.fetchLaunchesData(limit: any(named: 'limit')),
        ).thenAnswer((_) async => mockResponse(empty));

        final result = await repository.fetchCombinedFeed();
        result.fold((l) => expect(l.code, 404), (r) => fail("Should fail"));
      });

      test(
        'returns No data found from any source when APIs fail but are caught by inner try-catch',
        () async {

          when(
            () => mockNewsApi.fetchNewsArticlesData(limit: any(named: 'limit')),
          ).thenThrow(Exception("Boom!"));
          when(
            () => mockNewsApi.fetchMissionsData(limit: any(named: 'limit')),
          ).thenAnswer((_) async => mockResponse({"results": []}));
          when(
            () => mockLaunchApi.fetchEventsData(limit: any(named: 'limit')),
          ).thenAnswer((_) async => mockResponse({"results": []}));
          when(
            () => mockLaunchApi.fetchLaunchesData(limit: any(named: 'limit')),
          ).thenAnswer((_) async => mockResponse({"results": []}));

          final result = await repository.fetchCombinedFeed();
          result.fold(
            (l) => expect(l.message, "No data found from any source"),
            (r) => fail("Should fail"),
          );
        },
      );
    });
  });
}
