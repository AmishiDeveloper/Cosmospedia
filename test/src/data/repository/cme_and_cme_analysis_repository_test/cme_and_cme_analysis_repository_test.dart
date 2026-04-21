import 'dart:convert';
import 'package:cosmospedia/src/data/network/data_source/nasa/cme_api_service/cme_api_service.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/cme_repository/cme_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCmeApiService extends Mock implements CmeApiService {}

void main() {
  late CmeRepository cmeRepository;
  late MockCmeApiService mockApiService;

  setUp(() {
    TestWidgetsFlutterBinding
        .ensureInitialized(); // rootBundle ke liye zaroori hai
    mockApiService = MockCmeApiService();
    cmeRepository = CmeRepository(mockApiService);
  });

  // Helper function mock data simulate karne ke liye
  const mockCmeJson = '''[
  {
    "activityID": "2024-01-01-CME-001",
  "catalog": "M2M_CATALOG",
  "startTime": "2024-01-01T12:00Z",
  "sourceLocation": "N10W20",
  "activeRegionNum": null,
  "note": "Test note",
  "cmeAnalyses": [
{
  "isMostAccurate": true,
  "speed": 1703,
  "type": "C",
  "halfAngle": 67,
  "latitude": 10.0,
  "longitude": -20.0,
  "time21_5": "2024-01-01T14:00Z"
}
  ]
}
  ]'''; //''' '''' for multi-line string


  const mockAnalysisJson = '[{"time21_5":"2026-03-31T23:09Z","latitude":76,"longitude":82,"halfAngle":58,"speed":2035,"type":"O","isMostAccurate":true,"associatedCMEID":"2025-12-31-CME-001","note":"Mock Analysis: Solar storm impact prediction."}]';

  ///---fetchCmeData() Tests

  group('fetchCmeData Tests', () {
    // Case 1: Success (NASA Server working)
    test('returns Right(List<CmeModel>) when API call is successful', () async {
      final response = Response(
        data: jsonDecode(mockCmeJson),
        requestOptions: RequestOptions(path: ''),
      );
      when(() =>
          mockApiService.fetchCmeData(
          start: any(named: 'start'), end: any(named: 'end')))
          .thenAnswer((_) async => response);

      final result = await cmeRepository.fetchCmeData();

      expect(result.isRight(), true);
      result.fold((l) => fail('Should be Right'), (r) => expect(r.length, 1));
    });

    // Case 2: Success but Empty Data (204)
    test('returns Left(CustomError) when API returns null data', () async {
      final response = Response(
          data: null, requestOptions: RequestOptions(path: ''));
      when(() =>
          mockApiService.fetchCmeData(
          start: any(named: 'start'), end: any(named: 'end')))
          .thenAnswer((_) async => response);

      final result = await cmeRepository.fetchCmeData();

      expect(result.isLeft(), true);
      result.fold((l) => expect(l.message, contains("No CME events found")), (
          r) => fail('Should be Left'));
    });

    // Case 3: FALLBACK (NASA Server 503/Refused) -> Should load Mock Data
    test(
        'returns Right(Mock Data) when API throws connection error (Fallback)', () async {
      // API ko fail karo
      when(() =>
          mockApiService.fetchCmeData(
          start: any(named: 'start'), end: any(named: 'end')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: "Connection refused",
        type: DioExceptionType.connectionError,
      ));

      // Assets Mocking: rootBundle ko mock data bhejte hue
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        'flutter/assets',
            (message) async =>
            // Check karo ki message (file path) sahi hai ya nahi
            Uint8List
                .fromList(utf8.encode(mockCmeJson))
                .buffer
                .asByteData(),
      );

      final result = await cmeRepository.fetchCmeData();

      expect(result.isRight(), true);
      result.fold((l) => fail('Fallback failed: ${l.message}'), (r) =>
          expect(r.length, 1));
    });
  });

  // ERROR CASE 2: agr nasa ke reponse m keys badl jaye eg :latitude ki jgh lat
  test('returns Left when NASA sends malformed JSON (Parsing Error)', () async {

    // Direct Map bhejne ki jagah ganda JSON string bhejo jo decode hone par phate
    final malformedJson = [{"invalid": 123}]; // Model ise parse nahi kar payega
    final response = Response(
        data: malformedJson, requestOptions: RequestOptions(path: ''));

    when(() =>
        mockApiService.fetchCmeData(
        start: any(named: 'start'), end: any(named: 'end')))
        .thenAnswer((_) async => response);

    final result = await cmeRepository.fetchCmeData();

    expect(result.isLeft(), true);
    result.fold(
          (l) => expect(l.message, anyOf(contains('subtype'), contains('null'))),
      // Agar aapne catch block mein ye message rakha hai
          (r) => fail('Should be Left'),
    );
  });


  ///---fetchCmeAnalysisData Tests

  group('fetchCmeAnalysisData Tests', () {
    // Case 1: Success
    test(
        'returns Right(List<CmeAnalysisModel>) when API call is successful', () async {
      final response = Response(
        data: jsonDecode(mockAnalysisJson),
        requestOptions: RequestOptions(path: ''),
      );
      when(() =>
          mockApiService.fetchCmeAnalysisData(
            start: any(named: 'start'),
            end: any(named: 'end'),
            mostAccurateOnly: any(named: 'mostAccurateOnly'),
          )).thenAnswer((_) async => response);

      final result = await cmeRepository.fetchCmeAnalysisData();

      expect(result.isRight(), true);
      result.fold((l) => fail('Should be Right'), (r) => expect(r.length, 1));
    });

    // Case 2: Analysis Fallback to Mock
    test('returns Mock Analysis Data when NASA server times out', () async {
      when(() =>
          mockApiService.fetchCmeAnalysisData(
            start: any(named: 'start'),
            end: any(named: 'end'),
            mostAccurateOnly: true,
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        'flutter/assets',
            (message) async =>
            Uint8List
                .fromList(utf8.encode(mockAnalysisJson))
                .buffer
                .asByteData(),
      );

      final result = await cmeRepository.fetchCmeAnalysisData();

      expect(result.isRight(), true);
    });
  });


  ///---Mock Loading Functions Tests

  // Asset file se json file for mock data missing ho
  //group('Mock Data Functions Error Handling', () {

  //   // Case: Agar asset file hi delete ho jaye ya path galat ho (Error case)
  //   test('returns Left when asset file is missing', () async {
  //     // Mock messenger ko null return karwao (File not found simulate karne ke liye)
  //     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
  //         .setMockMessageHandler(
  //       'flutter/assets',
  //           (message) async {
  //             throw Exception("Asset not found");
  //           },
  //     );
  //
  //     // 2. NASA ko fail karo taaki fallback chale. fallback trigger hote hi loadCmeMockData ko trigger karega
  //     when(() =>
  //         mockApiService.fetchCmeData(
  //         start: any(named: 'start'), end: any(named: 'end')))
  //         .thenThrow(Exception("refused"));
  //
  //     final result = await cmeRepository.fetchCmeData();
  //
  //     expect(result.isLeft(), true);
  //     result.fold(
  //             (l) => expect(l.message, contains("Failed to load Demo Data")),
  //             (r) => fail('Should have returned Left because asset is missing'));
  //   });
  // });

  // // assets m json file toh ho lekin uss json ke andar ka syntax galt ho eg- comma missing etc
  // test('returns Left when Mock Asset JSON is invalid', () async {
  //   when(() =>
  //       mockApiService.fetchCmeData(
  //       start: any(named: 'start'), end: any(named: 'end')))
  //       .thenThrow(Exception("refused"));
  //
  //   // Mocking invalid JSON string
  //   TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
  //       .setMockMessageHandler(
  //     'flutter/assets',
  //         (message) async =>
  //         Uint8List
  //             .fromList(utf8.encode('{"invalid_json":}'))
  //             .buffer
  //             .asByteData(),
  //   );
  //
  //   final result = await cmeRepository.fetchCmeData();
  //
  //   expect(result.isLeft(), true);
  //   // result.fold(
  //   //       (l) => expect(l.message, contains("Failed to load Demo Data")),
  //   //       (r) => fail('Should fail due to invalid JSON'),
  //   // );
  // });

  // tearDown(() {
  //   // Mock message handler ko clear karo
  //   TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
  //     'flutter/assets',
  //     null,
  //   );
  // });

  //}
  ///--- _getErrorMessage Test (specific Error Message Handler). iss function ka kaamDioException ko insaan ki bhasha mein badalna.

  // Generic Unknown Exception (No Fallback)
  test('verify _getErrorMessage handles DioException correctly', () async {
    when(() => mockApiService.fetchCmeData(start: any(named: 'start'), end: any(named: 'end')))
        .thenThrow(DioException(
      requestOptions: RequestOptions(path: ''),
      type: DioExceptionType.badResponse,
      response: Response(statusCode: 404, requestOptions: RequestOptions(path: '')),
    ));

    final result = await cmeRepository.fetchCmeData();

    expect(result.isLeft(), true);
    // Yahan check karo ki kya CustomDioExceptions ne apna kaam kiya
    result.fold(
          (l) => expect(l.code, 404),
          (r) => fail('Should return 404 error'),
    );
  });


}