import 'package:bloc_test/bloc_test.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:cosmospedia/src/data/repository/space_dev_repo/space_news_repo/space_news_repository.dart';
import 'package:cosmospedia/src/logic/cubits/space_news_cubit/space_news_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSpaceNewsRepository extends Mock implements SpaceNewsRepository {}

void main() {
  late MockSpaceNewsRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    if (getIt.isRegistered<SpaceNewsRepository>()) {
      getIt.unregister<SpaceNewsRepository>();
    }
    mockRepo = MockSpaceNewsRepository();
    getIt.registerSingleton<SpaceNewsRepository>(mockRepo);
  });

  group('SpaceNewsCubit Tests', () {

    void mockInitialLoadSuccess() {
      when(() => mockRepo.fetchCombinedFeed(
        limit: any(named: 'limit'),
        targetDate: any(named: 'targetDate'),
      )).thenAnswer((_) async => right(<SpaceContent>[]));
    }

    blocTest<SpaceNewsCubit, SpaceNewsState>(
      'Success: loadData fetches combined feed and emits SuccessState',
      build: () {
        mockInitialLoadSuccess();
        return SpaceNewsCubit();
      },
      act: (cubit) => cubit.loadData(category: 'All', date: DateTime.now()),
      expect: () => [
        //  Logic: Constructor (Loading -> Success) + Act (Success)
        // Manual act wala Loading skip ho raha hai test mein instant response ki wajah se
        isA<SpaceNewsLoadingState>(),
        isA<SpaceNewsSuccessState>(),
        isA<SpaceNewsSuccessState>(),
      ],
    );

    blocTest<SpaceNewsCubit, SpaceNewsState>(
      'Success: getSpecificCategory switches to News and emits SuccessState',
      build: () {
        mockInitialLoadSuccess();
        when(() => mockRepo.fetchNewsArticles(limit: any(named: 'limit')))
            .thenAnswer((_) async => right(<SpaceContent>[]));
        return SpaceNewsCubit();
      },
      act: (cubit) => cubit.getSpecificCategory('News'),
      expect: () => [
        isA<SpaceNewsLoadingState>(),
        isA<SpaceNewsSuccessState>(),
        isA<SpaceNewsSuccessState>(),
      ],
    );

    blocTest<SpaceNewsCubit, SpaceNewsState>(
      'Error: emits ErrorState when repository fails',
      build: () {
        mockInitialLoadSuccess();
        when(() => mockRepo.fetchCombinedFeed(
          limit: any(named: 'limit'),
          targetDate: any(named: 'targetDate'),
        )).thenAnswer((_) async => left(CustomError("Network Failed", 500)));
        return SpaceNewsCubit();
      },
      act: (cubit) => cubit.loadData(category: 'All', date: DateTime.now()),
      expect: () => [
        isA<SpaceNewsLoadingState>(),
        isA<SpaceNewsErrorState>(),
        isA<SpaceNewsErrorState>(),
      ],
    );

    blocTest<SpaceNewsCubit, SpaceNewsState>(
      'Action: resetToToday should fetch data for current date',
      build: () {
        mockInitialLoadSuccess();
        return SpaceNewsCubit();
      },
      act: (cubit) => cubit.resetToToday(),
      verify: (_) {
        verify(() => mockRepo.fetchCombinedFeed(
          limit: any(named: 'limit'),
          targetDate: any(named: 'targetDate'),
        )).called(2);
      },
    );
  });
}