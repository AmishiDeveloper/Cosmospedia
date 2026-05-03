import 'package:bloc_test/bloc_test.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_model/cme_model.dart';
import 'package:cosmospedia/src/data/network/custom_dio_exceptions.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/cme_repository/cme_repository.dart';
import 'package:cosmospedia/src/logic/cubits/cme_cubits/cme_and_cme_analysis_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCmeRepository extends Mock implements CmeRepository {}

void main() {
  late CmeAndCmeAnalysisCubit cubit;
  late MockCmeRepository mockRepo;

  setUp(() {
    mockRepo = MockCmeRepository();
    // GetIt ko mock repo ke saath register karo
    if (getIt.isRegistered<CmeRepository>()) getIt.unregister<CmeRepository>();
    getIt.registerSingleton<CmeRepository>(mockRepo);

    cubit = CmeAndCmeAnalysisCubit();
  });

  tearDown(() => cubit.close());

  final dummyCme = CmeModel(
      activityId: '1', startTime: '2026-04-21T12:00Z', note: 'Live Data');
  final dummyAnalysis = CmeAnalysisModel(
      time215: '2026-04-21T15:00Z', note: 'Live Data');

  group('fetchCmeAndAnalysisData Tests', () {
    blocTest<CmeAndCmeAnalysisCubit, CmeAndCmeAnalysisState>(
      'emits [Loading, Success] when both APIs succeed with live data',
      build: () {
        when(() => mockRepo.fetchCmeData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
            .thenAnswer((_) async => right([dummyCme]));
        when(() => mockRepo.fetchCmeAnalysisData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
            .thenAnswer((_) async => right([dummyAnalysis]));
        return cubit;
      },
      act: (cubit) => cubit.fetchCmeAndAnalysisData(startDate: '2026-03-21', endDate: '2026-04-21'),
      expect: () => [
        isA<CmeAndCmeAnalysisLoadingState>(),
        isA<CmeAndCmeAnalysisSuccessState>().having((s) => s.isDemoMode, 'isDemoMode', false),
      ],
    );

    blocTest<CmeAndCmeAnalysisCubit, CmeAndCmeAnalysisState>(
      'detects isDemoMode true when note contains "Mock"',
      build: () {
        final mockCme = CmeModel(activityId: '1', startTime: '2026-04-21T12:00Z', note: 'Mock Data');
        when(() => mockRepo.fetchCmeData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
            .thenAnswer((_) async => right([mockCme]));
        when(() => mockRepo.fetchCmeAnalysisData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
            .thenAnswer((_) async => right([]));
        return cubit;
      },
      act: (cubit) => cubit.fetchCmeAndAnalysisData(startDate: '2026-03-21', endDate: '2026-04-21'),
      expect: () => [
        isA<CmeAndCmeAnalysisLoadingState>(),
        isA<CmeAndCmeAnalysisSuccessState>().having((s) => s.isDemoMode, 'isDemoMode', true),
      ],
    );
  });

  blocTest<CmeAndCmeAnalysisCubit, CmeAndCmeAnalysisState>(
    'emits ErrorState when fetchCmeData fails',
    build: () {
      when(() => mockRepo.fetchCmeData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
          .thenAnswer((_) async => left(CustomError('CME Error', 500)));
      when(() => mockRepo.fetchCmeAnalysisData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
          .thenAnswer((_) async => right([]));
      return cubit;
    },
    act: (cubit) => cubit.fetchCmeAndAnalysisData(startDate: '2026-03-21', endDate: '2026-04-21'),
    expect: () => [
      isA<CmeAndCmeAnalysisLoadingState>(),
      isA<CmeAndCmeAnalysisErrorState>().having((e) => e.errorMessage, 'msg', 'CME Error'),
    ],
  );

  group('updateDateRange Tests', () {
    blocTest<CmeAndCmeAnalysisCubit, CmeAndCmeAnalysisState>(
      'emits isUpdating: true before calling fetch method',
      build: () {
        final initialState = CmeAndCmeAnalysisSuccessState(
          cmeData: const [],
          cmeAnalysis: const [],
          startDate: '2026-03-21',
          endDate: '2026-04-21',
          activeDate: DateTime(2026, 04, 21),
          impactProbability: 0.0,
          isUpdating: false,
          isDemoMode: false,
          calendarFirstDate: DateTime(1995, 06, 16),
          calendarLastDate: DateTime.now(),
        );

        // Pehle Success state emit karwao
        // cubit.emit(CmeAndCmeAnalysisSuccessState(
        //   cmeData: [], cmeAnalysis: [], startDate: '', endDate: '',
        //   activeDate: DateTime.now(), impactProbability: 0,
        // ));

        when(() => mockRepo.fetchCmeData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
            .thenAnswer((_) async => right([]));
        when(() => mockRepo.fetchCmeAnalysisData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
            .thenAnswer((_) async => right([]));
        return cubit..emit(initialState);//// Cubit ko Success state ke saath start karo
      },
      act: (cubit) => cubit.updateDateRange(DateTime(2026, 4, 21)),
      wait: const Duration(milliseconds: 1000),// for showing shimmer widget in calendar container
      expect: () => [
        isA<CmeAndCmeAnalysisSuccessState>().having((s) => s.isUpdating, 'isUpdating', true),
        isA<CmeAndCmeAnalysisSuccessState>().having((s) => s.isUpdating, 'isUpdating', false),
      ],
    );
  });

  group('toggleCmeExpansion Tests', () {
    blocTest<CmeAndCmeAnalysisCubit, CmeAndCmeAnalysisState>(
      'updates expanded index and toggles to null if same index clicked',
      build: () {
        final initialState = CmeAndCmeAnalysisSuccessState(
          cmeData: const [],
          cmeAnalysis: const [],
          startDate: '2026-03-21',
          endDate: '2026-04-21',
          activeDate: DateTime(2026, 04, 21),
          impactProbability: 0.0,
          isUpdating: false,
          isDemoMode: false,
          calendarFirstDate: DateTime(1995, 06, 16),
          calendarLastDate: DateTime.now(),
        );

        return CmeAndCmeAnalysisCubit()..emit(initialState);
      },
      act: (cubit) {
        cubit.toggleCmeExpansion(1); // Open index 1
        cubit.toggleCmeExpansion(1); // Close index 1
      },
      expect: () => [
        isA<CmeAndCmeAnalysisSuccessState>().having((s) => s.cmeExpansionTileExpandedIndex, 'index', 1),
        isA<CmeAndCmeAnalysisSuccessState>().having((s) => s.cmeExpansionTileExpandedIndex, 'index', null),
      ],
    );
  });

}

