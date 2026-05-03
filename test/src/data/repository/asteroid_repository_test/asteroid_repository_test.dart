import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_feed_model.dart';
import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_lookup_model.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/asteroid_api_service/asteroid_api_service.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/asteroid_repository/asteroid_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. ApiService ko mock karo
class MockAsteroidApiService extends Mock implements AsteroidApiService {}

void main() {
  late AsteroidRepository repository;
  late MockAsteroidApiService mockApiService;

  setUp(() {
    mockApiService = MockAsteroidApiService();
    repository = AsteroidRepository(mockApiService);
  });

  group('AsteroidRepository - fetchAsteroidFeedData', () {
    final tStartDate = "2026-04-20";
    final tEndDate = "2026-04-21";

    test('Success: should return Right(AsteroidFeedModel) when API call is successful', () async {
      // Arrange
      final mockData = {
        "near_earth_objects": {},
        "element_count": 0,
      };
      when(() => mockApiService.fetchAsteroidData(start: tStartDate, end: tEndDate))
          .thenAnswer((_) async => Response(
        data: mockData,
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
      ));

      // Act
      final result = await repository.fetchAsteroidFeedData(startDate: tStartDate, endDate: tEndDate);

      // Assert
      expect(result.isRight(), true);
      result.fold((l) => null, (r) => expect(r, isA<AsteroidFeedModel>()));
      verify(() => mockApiService.fetchAsteroidData(start: tStartDate, end: tEndDate)).called(1);
    });

    test('Error: should return Left(CustomError) when DioException occurs', () async {
      // Arrange
      when(() => mockApiService.fetchAsteroidData(start: tStartDate, end: tEndDate)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(requestOptions: RequestOptions(path: ''), statusCode: 404),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act
      final result = await repository.fetchAsteroidFeedData(startDate: tStartDate, endDate: tEndDate);

      // Assert
      expect(result.isLeft(), true);
      result.fold((l) => expect(l.code, 404), (r) => null);
    });
  });

  group('AsteroidRepository - fetchAsteroidLookupData', () {
    const tAsteroidId = "3542519";

    test('Success: should return Right(AsteroidLookUpModel) when ID is valid', () async {
      // Arrange
      final mockData = {"id": tAsteroidId, "name": "433 Eros"};
      when(() => mockApiService.fetchAsteroidLookupData(asteroidId: tAsteroidId))
          .thenAnswer((_) async => Response(
        data: mockData,
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
      ));

      // Act
      final result = await repository.fetchAsteroidLookupData(asteroidId: tAsteroidId);

      // Assert
      expect(result.isRight(), true);
      result.fold((l) => null, (r) => expect(r, isA<AsteroidLookUpModel>()));
    });

    test('Error: should return Left(CustomError) when data is null (204 No Content)', () async {
      // Arrange
      when(() => mockApiService.fetchAsteroidLookupData(asteroidId: tAsteroidId))
          .thenAnswer((_) async => Response(
        data: null, // Logic check for null data
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
      ));

      // Act
      final result = await repository.fetchAsteroidLookupData(asteroidId: tAsteroidId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((l) {
        expect(l.message, "No data found");
        expect(l.code, 204);
      }, (r) => null);
    });
  });
}