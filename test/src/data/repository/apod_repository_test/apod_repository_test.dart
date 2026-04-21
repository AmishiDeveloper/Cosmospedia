import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/data/network/data_source/nasa/apod_api_service/apod_api_service.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/apod_repository/apod_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

// 1. Nakli ApiService
class MockApodApiService extends Mock implements ApodApiService {}

void main() {
  late ApodRepository apodRepository;
  late MockApodApiService mockApiService;

  setUp(() {
    mockApiService = MockApodApiService();
    apodRepository = ApodRepository(mockApiService);
  });

  group('ApodRepository Tests', () {

    // Success Case 1: Jab NASA ki api success toh ho lekin null data aaye usmein
    test('fetchApodList returns Left when API sends null data', () async {
      // Arrange: Response 200 hai par data null hai
      final response = Response(data: null, requestOptions: RequestOptions(path: '')); // api se aaya response

      when(() => mockApiService.fetchApodData()).thenAnswer((_) async => response);


      // Act
      final result = await apodRepository.fetchApodList();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
            (error) => expect(error.message, contains("NASA didn't send any data")),
            (right) => fail('Should be Left'),
      );
    });


    // Success Case 2: Jab NASA humein images ki LIST bhejta hai
    test('fetchApodList returns Right(List<ApodModel>) when API sends a List', () async {
      // Arrange: Nakli JSON data taiyar kiya
      final mockData = [
        {'title': 'Moon', 'url': 'moon.jpg', 'date': '2023-01-01', 'explanation': 'Desc'},
        {'title': 'Sun', 'url': 'sun.jpg', 'date': '2023-01-02', 'explanation': 'Desc'},
      ];
      final response = Response(
        data: mockData,
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockApiService.fetchApodData(count: 2))
          .thenAnswer((_) async => response);

      // Act
      final result = await apodRepository.fetchApodList(count: 2);

      // Assert
      // Iska matlab: "Check karo ki result Right side wala hai (Success)"
      expect(result.isRight(), true);

      // Right side ka data nikal kar check kiya
      result.fold(
            (left) => fail('Should not be Left'),
            (right) {
          expect(right, isA<List<ApodModel>>());
          expect(right.length, 2);
          expect(right[0].title, 'Moon');
        },
      );
    });

    // Success Case 3: Jab NASA ko koi date nahi bhej jati tab voh (Map) bhejta hai
    test('fetchApodList returns Right(List) even when API sends a single Map', () async {
      final mockData = {'title': 'Mars', 'url': 'mars.jpg', 'date': '2023-01-03', 'explanation': 'Desc'};
      final response = Response(data: mockData, requestOptions: RequestOptions(path: ''));

      when(() => mockApiService.fetchApodData())
          .thenAnswer((_) async => response);

      // Act
      final result = await apodRepository.fetchApodList();

      // Assert
      expect(result.isRight(), true);
      result.fold(
            (l) => fail('Should be Right'),
            (r) => expect(r.length, 1), // Code ne Map ko List mein wrap kar diya hoga
      );
    });

    // Error Case 1: Jab Internet chala jaye (DioException)
    test('fetchApodList returns Left(CustomError) on DioException', () async {
      // Arrange: Exception simulate kiya
      when(() => mockApiService.fetchApodData(count: 2))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      // Act
      final result = await apodRepository.fetchApodList(count: 2);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
            (error) {
          expect(error.message, contains('Connection timed out'));
        },
            (r) => fail('Should be Left'),
      );
    });


    // Error Case 2: Jab NASA Data toh bheje but voh na hi null ho na hi List<ApodModel> ho nahi hi Map<String,dynamic> ho

    test('fetchApodList returns Left when data is neither null nor List nor Map', () async {
      // Arrange: NASA ne galti se sirf ek String bhej di
      final response = Response(data: "Something went wrong", requestOptions: RequestOptions(path: ''));
      when(() => mockApiService.fetchApodData()).thenAnswer((_) async => response);

      // Act
      final result = await apodRepository.fetchApodList(); // jab humara code repo m yeh code ko trigger karega toh humara apiservice ka method call hoga jiska response m something went wrong aaya toh yhn se upar ki tarf ja raha h flow. phir jab response aa gay toh hum neeche aaye jhn hum batae h ki hume error expect ki hai

      // Assert
      expect(result.isLeft(), true);
      result.fold(
            (error) => expect(error.message, contains("Unexpected data format")),
            (right) => fail('Should be Left'),
      );
    });

    // Error Case 3: Jab NASA Specific Status Codes (500, 403, 429) BHEJE
    test('fetchApodList returns specific message for 500 status code', () async {
      // Arrange: DioException with 500 status code
      when(() => mockApiService.fetchApodData()).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      // Act
      final result = await apodRepository.fetchApodList();

      // Assert
      result.fold(
            (error) => expect(error.message, contains("temporarily struggling")),
            (right) => fail('Should be Left'),
      );
    });

    // Error Case 4: Jab NASA se kuch alg error aaye jo mention nahi h mtlb kuch anjaan error/ generic error aayi
    test('fetchApodList returns Left on unexpected parsing error', () async {
      // Arrange: Data format sahi hai par required fields missing hain (Model crash karega)
      final response = Response(data: ['data'], requestOptions: RequestOptions(path: '')); // should be [{}] map inside list but we are giving ['']
      when(() => mockApiService.fetchApodData()).thenAnswer((_) async => response);

      // Act
      final result = await apodRepository.fetchApodList();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
            (error) => expect(error.message, contains("Unexpected Error")),
            (right) => fail('Should be Left'),
      );
    });

  });
}