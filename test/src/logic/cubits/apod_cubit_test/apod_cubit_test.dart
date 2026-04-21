import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/core/utils/response_type_def.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/apod_repository/apod_repository.dart';
import 'package:cosmospedia/src/logic/cubits/apod_cubit/apod_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApodRepository extends Mock implements ApodRepository {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ApodCubit apodCubit;
  late MockApodRepository mockRepo;

  setUp(() {
    mockRepo = MockApodRepository();

    // GetIt setup
    if (getIt.isRegistered<ApodRepository>()) {
      getIt.unregister<ApodRepository>();
    }
    getIt.registerSingleton<ApodRepository>(mockRepo);

    // 2. DEFAULT MOCKING: Cubit constructor ke liye
    // Taaki jab 'new ApodCubit()' ho, toh ye null return na kare
    when(() => mockRepo.fetchApodList(count: any(named: 'count')))
        .thenAnswer((_) async => right([]));
    when(() => mockRepo.fetchApodList(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate')
    )).thenAnswer((_) async => right([]));


    // SharedPreferences Mock (Internal logic ke liye)
    SharedPreferences.setMockInitialValues({});

    // Note: Cubit constructor mein hi getInitialData call karta hai,
    // isliye test ke andar hum ise manually dobara bula sakte hain ya seedha test shuru kar sakte hain.
    apodCubit = ApodCubit();
  });

  tearDown(() => apodCubit.close());

  /// ----getInitialData()

  // getInitialData Success case 1: (Sab kuch sahi chala)
  blocTest<ApodCubit, ApodState>(
    'emits [Loading, Success] when NASA\'s both API calls succeed',
    build: () {
      // Carousel ke liye 5 images
      when(() => mockRepo.fetchApodList(count: 5)).thenAnswer((_) async => right([]));
      // Aaj ki image ke liye call
      when(() => mockRepo.fetchApodList(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
          .thenAnswer((_) async => right([ApodModel(title: 'NASA Today\'s Pic' , url: 'url', date: DateTime.parse('2026-04-21'), explanation: 'desc')]));
      return apodCubit;
    },
    act: (cubit) => cubit.getInitialData(),
    expect: () => [
      isA<ApodLoadingState>(),
      isA<ApodSuccessState>(),
    ],
  );

  // getInitialData Success case 2: Api fail ho gayi kyunki nasa down tha (503) but cache data available tha toh user ko success state m voh dikhaya
  blocTest<ApodCubit, ApodState>(
    'emits [Loading, Success] with cached data and message when NASA sever is busy (503)',
    build: () {

      // 1. SharedPreferences mein nakli cache data bharo
      final mockCache = ApodSuccessState(
          apodCarouselImageList: [],
          apodImageList: [],
          startDate: '01-01-2026',
          endDate: '01-01-2026'
      );
      SharedPreferences.setMockInitialValues({//Ye Flutter testing ka ek special function hai. Ye SharedPreferences ko bolta hai:asli database mat dhoondho, main tumhe ek nakli (Mock) memory de raha hoon, ise use karo
        //key: string(map)

        'cached_apod_data': jsonEncode(mockCache.toJson()), //'cached_apod_data': this is my _storageKey in my cubit jis key ko use karke data store karvaya tha. ab Cubit isi naam se data dhoondhne jayega.
      }); //mockCache aapka ek ApodSuccessState ka object hai (jisne data hold kiya hai).
      // mockCache m jo data h use toJson() use karke Map mein badal raha hai.
      // map pe jsonEncode use karke ek lambi String (JSON) bana deta hai.
      // isko string m isliye convert kiya Kyunki SharedPreferences sirf Strings, Ints, etc. save kar sakta hai, poora ka poora Object nahi.

      // 2. Repo ko bolo 503 error phekne ko
      // a. Carousel fail ho gaya
      when(() => mockRepo.fetchApodList(count: 5)).thenAnswer((_) async => left(CustomError('NASA Service Currently Unavailable', 503)));
      // b. Today's API bhi fail ho gayi
      when(() => mockRepo.fetchApodList(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
          .thenAnswer((_) async => left(CustomError('NASA Service Currently Unavailable', 503)));

      // Note: Yahan manual mock injection (SharedPreferences) ki zaroorat pad sakti hai
      // agar humne pehle se cache save kiya ho.
      return apodCubit;
    },
    act: (cubit) => cubit.getInitialData(),
    expect: () => [
      isA<ApodLoadingState>(),
      // Agar cache milta hai, toh wo state emit hogi jisme message hoga. yani // Yahan state Success hogi par uske andar "Server is busy" wala message hoga
      isA<ApodSuccessState>().having((s) => s.message, 'msg', contains('Server is busy')),
    ],
  );

  // // _emitSuccess aur Message Loop Fix
  // test('verify that message is cleared (set to null) after 0.5 seconds  in _emitSuccess when triggered via getInitialData', () async {
  //   final successWithMsg = ApodSuccessState( // api fail hui but cache data dikhane ke liye success state emit ki
  //     apodCarouselImageList: [],
  //     apodImageList: [],
  //     startDate: '01-01-2024',
  //     endDate: '01-01-2024',
  //     message: 'NASA Server busy showing cached data',
  //   );
  //
  //   // Act: Message wali state bheji
  //   apodCubit.emit(successWithMsg);
  //
  //   // 3. Double check: Kya emit hote hi message aaya?
  //   expect((apodCubit.state as ApodSuccessState).message, 'NASA Server busy showing cached data');
  //
  //   // Wait for the delayed reset in _emitSuccess
  //   //await Future.delayed(const Duration(seconds: 1));// msg clear hone ka wait kiya
  //
  //   // 4. Sabse important: Cubit ke andar 500ms ka delay hai.
  //   // Hum 1.2 seconds wait karenge taaki koi shak na rahe.
  //   // Hum 'await' ko ek loop mein daal dete hain jo event queue ko clear karega.
  //   await Future.delayed(const Duration(milliseconds: 500));
  //
  //
  //   // Assert: Check karo ki message apne aap null ho gaya ya nahi
  //   expect((apodCubit.state as ApodSuccessState).message, isNull,reason: "Message should have been cleared by Cubit's internal timer");
  //
  // });

  // getInitialData Error case 1: The "Loop" & "Fallback" Logic. NASA 400 Error (Fallback to Yesterday). NASA Server gives 400 error means todays apod not available yet. toh aise mein kal ki date ki apod dikhegi
  blocTest<ApodCubit, ApodState>(
    'falls back to yesterday when today\'s date (today apod not available) and returns 400 error',
    build: () {
      when(() => mockRepo.fetchApodList(count: 5)).thenAnswer((_) async => right([]));

      // 1st call: Today -> returns 400
      when(() => mockRepo.fetchApodList(
        startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      )).thenAnswer((_) async => left(CustomError("Date must be between...", 400)));

      // 2nd call: Yesterday -> returns Success
      String yesterday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
      when(() => mockRepo.fetchApodList(startDate: yesterday, endDate: yesterday))
          .thenAnswer((_) async => right([ApodModel(title: 'Yesterday Pic', url: 'url', date: DateTime.now().subtract(const Duration(days: 1)), explanation: 'desc')]));

      return apodCubit;
    },
    act: (cubit) => cubit.getInitialData(),
    expect: () => [
      isA<ApodLoadingState>(),// Pehli koshish
      isA<ApodErrorState>(),//// Error aaya (400)
      isA<ApodLoadingState>(),// Fallback (Yesterday) shuru hua
      // Result mein Success aayega with yesterday's message
      isA<ApodSuccessState>().having((s) => s.message, 'msg', contains('not yet ready')),
    ],
  );

  // getInitialData Success  case 3: NASA did not send error code 400 instead response was 200 but still Empty List as response was received so Fallback to yesterday and get that apod
  blocTest<ApodCubit, ApodState>(
    'Retries with yesterday\'s date when today returns an empty list [] (means nasa did not send 400 error it sent 200 but still list was empty)',
    build: () {
      // 1. Carousel setup
      when(() => mockRepo.fetchApodList(count: 5)).thenAnswer((_) async => right([]));

      // 2. FIRST CALL (Today): Returns empty list []
      // Humne dates ko specifically mock kiya taaki order sahi rahe
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      when(() => mockRepo.fetchApodList(startDate: today, endDate: today))
          .thenAnswer((_) async => right([]));

      // 3. SECOND CALL (Yesterday): Returns actual data
      String yesterday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
      when(() => mockRepo.fetchApodList(startDate: yesterday, endDate: yesterday))
          .thenAnswer((_) async => right([
        ApodModel(title: 'Yesterday Pic', url: '', date: DateTime.now().subtract(const Duration(days: 1)), explanation: '')
      ]));

      return apodCubit;
    },
    act: (cubit) => cubit.getInitialData(),
    expect: () => [
      isA<ApodLoadingState>(),//// Pehla call (Today)

      isA<ApodLoadingState>(), // Doosra call (Yesterday fallback)

      // Yahan check karo: Success state aayi aur message mein "Showing latest" ya "not available" hai
      isA<ApodSuccessState>().having(
              (s) => s.message,
          'message',
          contains("Today's APOD not yet ready") // Aapke code ka message
      ),
    ],
  );

  //--- load more data

    blocTest<ApodCubit, ApodState>(
        'adds more images in REVERSED order and updates the list length',
        build: () {
          // Boundary check se bachne ke liye limitStartDate ko null rakho ya door ki date do
          apodCubit.limitStartDate = "01-01-1990";


          // 1. Maan lo pehle se list mein ek image hai (Latest wali)
          final existingModel = ApodModel(title: 'Old', url: '', date: DateTime.now(), explanation: '');

          // 1. Initial State emit karo
          apodCubit.emit(ApodSuccessState(
            apodCarouselImageList: [],
            apodImageList: [existingModel],
            startDate: '21-04-2026',
            endDate: '21-04-2026',
          ));

          // 2. NASA ne 2 nayi images bheji (Purani dates wali)
          // NASA bhejta hai: [Puraani Date, Usse thodi kam Puraani Date]
          final newModel1 = ApodModel(title: 'Oldest', url: '', date: DateTime.now(), explanation: '');
          final newModel2 = ApodModel(title: 'less Oldest', url: '', date: DateTime.now(), explanation: '');

          when(() => mockRepo.fetchApodList(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate')
          )).thenAnswer((_) async => right([newModel1, newModel2]));

          return apodCubit;
        },
        act: (cubit) => cubit.loadMoreData(),
        expect: () => [
          // Check 1: Pehle loader on hona chahiye
          isA<ApodSuccessState>().having((s) => s.isLoadMoreImages, 'loading', true),

          // Check 2: Final state check
          isA<ApodSuccessState>()
              .having((s) => s.apodImageList.length, 'length', 3) // 1 purani + 2 nayi
              .having((s) => s.isLoadMoreImages, 'loading', false)
          // Sabse Important: Check karo ki 'Oldest' wali image last mein gayi ya nahi (Reversed logic)
              .having((s) => s.apodImageList.last.title, 'order check', 'Oldest'),
        ],
        // verify: (_) {
        //   // Ye verify karo ki API call sahi dates ke liye gayi thi ya nahi
        //   verify(() => mockRepo.fetchApodList(startDate: any(named: 'startDate'), endDate: any(named: 'endDate'))).called(1);
        // }
    );


  // -- manual refresh logic (yeh tab kaam aata h jab ser 1 st time sign karta h toh ek baar m api hit nahi ho pati toh 2 sec ka wait karke phir api hit kar dete h)
  test('manualRefresh resets retryCount and calls getInitialData', () async {
    apodCubit.retryCount = 1; // Maan lo pehle api ek baar fail ho chuki hai toh retry ab 0 se 1 ho gaya h

    when(() => mockRepo.fetchApodList(count: any(named: 'count')))
        .thenAnswer((_) async => right([]));
    when(() => mockRepo.fetchApodList(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
        .thenAnswer((_) async => right([]));

    await apodCubit.manualRefresh();

    expect(apodCubit.retryCount, 0); // Reset hona chahiye // check karna ki vapis retry 0 hua ki nahi
  });


  /// -----updateDateRange() cases

  //updateDateRange Error case 1: Invalid Range (Start > End)
  blocTest<ApodCubit, ApodState>(
    'emits ApodErrorState when start date is after end date',
    build: () {
      // Ye zaroori hai kyunki updateDateRange purani state dhoondhta hai
      apodCubit.emit(ApodSuccessState(
          apodCarouselImageList: [], apodImageList: [],
          startDate: '01-01-2024', endDate: '01-01-2024'
      ));
      return apodCubit;
    },
    act: (cubit) => cubit.updateDateRange(updatedStart: '10-01-2024', updatedEnd: '01-01-2024'),
    expect: () => [
      isA<ApodErrorState>().having((e) => e.errorMessage, 'msg', contains('Invalid Range')),
    ],
  );

  //updateDateRange Success case 1: Range Update Successfully
  blocTest<ApodCubit, ApodState>(
    'emits isUpdating=true then false with Success state when range is updated successfully',
    build: () {
      // Current state success honi chahiye pehle
      apodCubit.emit(ApodSuccessState(
          apodCarouselImageList: [],
          apodImageList: [],
          startDate: '01-01-2024',
          endDate: '01-01-2024'
      ));

      when(() => mockRepo.fetchApodList(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
          .thenAnswer((_) async => right([]));
      return apodCubit;
    },
    act: (cubit) => cubit.updateDateRange(updatedStart: '01-01-2024', updatedEnd: '05-01-2024'),
    expect: () => [
      // Pehle loading indicator on hoga purane data ke upar
      isA<ApodSuccessState>().having((s) => s.isUpdating, 'loading', true),
      // Phir naya data aayega aur loader off
      isA<ApodSuccessState>().having((s) => s.isUpdating, 'loading', false),
    ],
  );


}