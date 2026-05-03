import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/apod_repository/apod_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'apod_state.dart';

/*
Cubit, jo ki "Remote Control" hai jo is Manager ko command deta hai.
Cubit ka kaam hai State Management.
Cubit woh Remote Control hai jo user ke kehne par sabko order deta hai aur screen par dikhne wali cheezon ko badalta hai.
State matlab: Screen abhi kaisi dikh rahi hai? (Kya loading chal rahi hai? Kya data aa gaya? Ya koi error aa gaya?)
Cubit decide karta hai ki kab loader dikhana hai aur kab NASA ka photo.
Cubit jo repo data bhejta hai either ke form mein yani agr left h either ke paas toh error agr right h toh success toh usko user ko ui pe kaise dikhana h yeh kaam h cubit ka
Cubit Repository se data leta hai aur decide karta hai ki UI screen par abhi kya dikhega (Loading, Error, ya Success).
*/

class ApodCubit extends Cubit<ApodState> {
  //ApodCubit takses care of ApodState
  ApodCubit() : super(ApodInitial()) {
    // initially app khali hogi ie initial state pe hogi
    getInitialData(); //Cubit bante hi humne NASA se data mangwana shuru kar diya.
  }

  // cubit calls the repo so that whenever data is required it can be used to get it
  final _repo = getIt<ApodRepository>();
  bool isInitialFetch = true;
  static const String _storageKey = 'cached_apod_data';

  // Yeh variable pichli success state ko sambhal kar rakhega
  ApodSuccessState? lastSuccessState;

  // jisse agr date range badi ho toh data end date se start date tak hi apod img dikhaye usse zyada nahi toh start date store karne ke liye.
  String? limitStartDate;

  int retryCount = 0;

  // getInitialData with cache but updated code to solve infinite snackbars problem
  // getInitialData function ko isse replace karein
  Future<void> getInitialData({String? yesterdayDate}) async {
    isInitialFetch = retryCount == 0;
    if (isInitialFetch) emit(ApodLoadingState());

    String currentUIFormat = yesterdayDate ?? DateFormat('dd-MM-yyyy').format(DateTime.now());
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(currentUIFormat);
    String currentAPIFormat = DateFormat('yyyy-MM-dd').format(parsedDate);

    final cachedState = await _loadFromLocal();

    final carouselResponse = await _repo.fetchApodList(count: 5);
    final todayApodResponse = await _repo.fetchApodList(
      startDate: currentAPIFormat,
      endDate: currentAPIFormat,
    );

    List<ApodModel> carouselList = [];
    carouselResponse.fold((error) {
      if (cachedState != null) carouselList = cachedState.apodCarouselImageList;
    }, (list) => carouselList = list);

    await todayApodResponse.fold(
          (error) async {
        //  FIX 1: Sirf tabhi "Unstable" bolo jab sach mein Socket/Timeout ho
        bool isNetworkError = error.message.toLowerCase().contains("socket") ||
            error.message.toLowerCase().contains("host lookup") ||
            error.message.toLowerCase().contains("timeout");

        bool isServerError = error.code == 503 || error.message.contains("503");

        if ((isNetworkError || isServerError) && cachedState != null) {
          String displayMsg = isServerError
              ? "NASA Server is busy. Showing last saved data."
              : "Connection unstable. Showing last saved data.";

          // Success emit karke yahin se RETURN ho jao, niche mat jaao
          _emitSuccess(cachedState.copyWith(message: displayMsg, isUpdating: false));
          return;
        }

        //  FIX 2: Retry sirf tab jab na cache ho na fallback
        if ((isServerError || error.message.contains("timeout")) && retryCount < 1) {
          retryCount++;
          await Future.delayed(const Duration(seconds: 2));
          return getInitialData(yesterdayDate: yesterdayDate);
        }

        // Final Error tabhi jab sab fail ho jaye
        emit(ApodErrorState(errorMessage: error.message));

        if (error.code == 400 && yesterdayDate == null) {
          String yesterday = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 1)));
          getInitialData(yesterdayDate: yesterday);
        }
      },
          (todayList) {
        retryCount = 0;
        isInitialFetch = false;

        if (todayList.isEmpty && yesterdayDate == null) {
          String yesterday = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 1)));
          return getInitialData(yesterdayDate: yesterday);
        }

        _emitSuccess(
          ApodSuccessState(
            apodCarouselImageList: carouselList,
            apodImageList: todayList,
            startDate: currentUIFormat,
            endDate: currentUIFormat,
            message: (yesterdayDate != null) ? "Today's APOD not yet ready. Showing latest." : null,
          ),
        );
      },
    );
  }

  //  3: _emitSuccess mein "Silent Reset" ensure karein
  void _emitSuccess(ApodSuccessState successState) {
    // Agar current state already Success hai aur message null hai,
    // toh dubara message mat bhejo jab tak data na badle.
    if (state is ApodSuccessState) {
      final oldState = state as ApodSuccessState;
      if (oldState.message == successState.message && successState.message != null) {
        return; // Stop the loop right here!
      }
    }

    lastSuccessState = successState;
    _saveToLocal(successState);
    emit(successState);

    // Message ko dikhane ke baad turant clear karo taaki loop break ho jaye
    if (successState.message != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!isClosed && state is ApodSuccessState) {
          // Bina message ke wahi state dubara emit karo
          emit((state as ApodSuccessState).copyWith(message: null));
        }
      });
    }
  }


  Future<void> manualRefresh() async {
    retryCount = 0; //  Counter reset taaki naya moka mile
    await getInitialData();
  }

  void updateCarouselIndex(int newIndex) {
    // Pehle check karo: Kya abhi hum Success state mein hain?
    if (state is ApodSuccessState) {
      // 'state' keyword se humein current success state mil gayi
      final currentState = state as ApodSuccessState;

      //Kyun: Jab user Carousel ko ungli se slide karta hai, toh niche
      // wale dots (indicator) ko badalna padta hai.
      // Logic: Hum poori state ko nahi chhedte, bas index badal dete
      // hain. copyWith ka matlab hai: "Baki sab wahi rakho, bas index
      // naya wala daal do."
      _emitSuccess(
        currentState.copyWith(index: newIndex),
      ); // currentState is SuccessState
    }
  }

  // with cache
  Future<void> updateDateRange({
    String? updatedStart,
    String? updatedEnd,
    bool isFallback = false,
  }) async {
    isInitialFetch = false;

    // 1. SAFETY: Current ya Cached state nikalna
    final currentState = (state is ApodSuccessState)
        ? state as ApodSuccessState
        : lastSuccessState;

    if (currentState == null) return;

    final String updatedStartDateString =
        updatedStart ?? currentState.startDate;
    final String updatedEndDateString = updatedEnd ?? currentState.endDate;

    if (updatedStartDateString.isEmpty || updatedEndDateString.isEmpty) return;

    DateTime startDt = DateFormat('dd-MM-yyyy').parse(updatedStartDateString);
    DateTime endDt = DateFormat('dd-MM-yyyy').parse(updatedEndDateString);

    // 2. Validation: Start date end se badi nahi honi chahiye
    if (startDt.isAfter(endDt)) {
      emit(
        ApodErrorState(
          errorMessage: "Invalid Range: Start cannot be after End",
        ),
      );
      return;
    }

    // 3. UI Update: Purane data ke upar loading indicator (isUpdating) dikhao
    _emitSuccess(
      currentState.copyWith(
        start: updatedStartDateString,
        end: updatedEndDateString,
        isUpdating: true,
      ),
    );

    try {
      String apiStart = DateFormat('yyyy-MM-dd').format(startDt);
      String apiEnd = DateFormat('yyyy-MM-dd').format(endDt);

      final response = await _repo.fetchApodList(
        startDate: apiStart,
        endDate: apiEnd,
      );

      await response.fold(
        (error) async {
          // ---  NEW CACHE/OFFLINE LOGIC START ---
          // Agar Internet Issue hai (Socket, Timeout, 503)
          if (error.message.contains("socket") ||
              error.message.contains("timeout") ||
              error.message.contains("503") ||
              error.message.contains("Host lookup")) {
            // User ko Error screen par mat bhejo (hijack mat karo)
            // Bas loader band karo aur purana state hi rakho with a message
            _emitSuccess(
              currentState.copyWith(
                isUpdating: false,
                message:
                    "Offline: Could not update range. Showing last saved data.",
              ),
            );

            // Snackbar ke liye error bhej do
            emit(ApodErrorState(errorMessage: "No internet connection."));
            return;
          }
          // ---  NEW CACHE/OFFLINE LOGIC END ---

          // Error aane par loader band karo
          _emitSuccess(currentState.copyWith(isUpdating: false));

          // Fallback Logic (NASA 400 error)
          if ((error.message.contains("not available") || error.code == 400) &&
              !isFallback) {
            String yesterday = DateFormat(
              'dd-MM-yyyy',
            ).format(DateTime.now().subtract(const Duration(days: 1)));

            emit(
              ApodErrorState(
                errorMessage: "Data not available. Falling back...",
              ),
            );

            await updateDateRange(
              updatedStart: yesterday,
              updatedEnd: yesterday,
              isFallback: true,
            );
          } else {
            emit(ApodErrorState(errorMessage: error.message));
          }
        },
        (newList) {
          // SUCCESS: Naya data mil gaya, emitSuccess ise auto-save kar lega
          _emitSuccess(
            currentState.copyWith(
              apodImageList: newList.reversed.toList(),
              start: updatedStartDateString,
              end: updatedEndDateString,
              isUpdating: false,
            ),
          );
        },
      );
    } catch (e) {
      _emitSuccess(currentState.copyWith(isUpdating: false));
      emit(ApodErrorState(errorMessage: "Something went wrong."));
    }
  }

  // Cubit ke andar:
  Future<void> loadMoreData() async {
    if (state is! ApodSuccessState) return;
    final currentState = state as ApodSuccessState;

    // Agar pehle se load ho raha hai, toh dubara call mat karo
    if (currentState.isLoadMoreImages) return;

    // 1995 ki limit check
    DateTime currentStart = DateFormat(
      'dd-MM-yyyy',
    ).parse(currentState.startDate);
    if (currentStart.isBefore(DateTime(1995, 06, 17)))
      return; // 16 June se pehle nahi jana

    // 1. LIMIT CHECK: Agar hum pehle hi limitStartDate tak pahunch gaye hain, toh STOP
    if (limitStartDate != null && currentState.startDate == limitStartDate) {
      return;
    }

    // 1. Loader dikhao (isLoadMore: true)
    emit(currentState.copyWith(isLoadMoreImages: true));
    // 2. Next Batch Dates Calculate Karein
    // currentState.startDate hamari sabse purani date hai jo abhi grid mein hai
    DateTime currentOldest = DateFormat(
      'dd-MM-yyyy',
    ).parse(currentState.startDate);
    DateTime limitDt = DateFormat(
      'dd-MM-yyyy',
    ).parse(limitStartDate ?? currentState.startDate);

    DateTime nextEnd = currentOldest.subtract(
      const Duration(days: 1),
    ); // Agla batch ek din pehle se shuru hoga
    DateTime nextStart = nextEnd.subtract(
      const Duration(days: 15),
    ); // 15 din piche
    // 1995 ki limit check
    if (nextStart.isBefore(limitDt)) {
      nextStart = limitDt; //DateTime(1995, 06, 16);
    }

    // Agar bacha hua data range ke bahar hai
    if (nextEnd.isBefore(limitDt)) {
      emit(currentState.copyWith(isLoadMoreImages: false));
      return;
    }

    // 3. API Call
    final response = await _repo.fetchApodList(
      startDate: DateFormat('yyyy-MM-dd').format(nextStart),
      endDate: DateFormat('yyyy-MM-dd').format(nextEnd),
    );

    response.fold(
      (error) {
        //Bas loader band kar do taaki user ko infinite loading na dikhe
        _emitSuccess(currentState.copyWith(isLoadMoreImages: false));

        // Agar internet nahi hai toh ek chota sa message
        if (error.message.contains("socket")) {
          emit(ApodErrorState(errorMessage: "No internet to load more images."));
        }
      },
      (newList) {
        // NASA bhejta hai: [1 Feb, 2 Feb, 3 Feb]
        // Humein chahiye Descending: [3 Feb, 2 Feb, 1 Feb]
        final reversedNewData = newList.reversed.toList();

        // Purane data mein Naya data niche jod do. Purani list + Nayi list (reversed taaki descending order rahe)
        final combinedList = List<ApodModel>.from(currentState.apodImageList)
          ..addAll(reversedNewData);

        _emitSuccess(
          currentState.copyWith(
            apodImageList: combinedList,
            start: DateFormat('dd-MM-yyyy').format(nextStart),
            isLoadMoreImages: false,
          ),
        );
      },
    );
  }

  // ApodCubit ke andar add karein
  Future<void> retryCarousel() async {
    if (state is! ApodSuccessState) return;
    final currentState = state as ApodSuccessState;

    // Carousel fetch karo
    final response = await _repo.fetchApodList(count: 5);

    response.fold(
      (error) => null,
      // Fail hua toh kuch mat karo, UI already error dikha rahi hogi
      (newList) {
        _emitSuccess(currentState.copyWith(apodCarouselImageList: newList));
      },
    );
  }

  Future<void> _saveToLocal(ApodSuccessState successState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // State ko String (JSON) bana kar save kar diya
      await prefs.setString(_storageKey, jsonEncode(successState.toJson()));
      debugPrint(" APOD Data Saved to Local Storage");
    } catch (e) {
      debugPrint(" Error saving cache: $e");
    }
  }

  //  Local Storage se wapas load karne ke liye
  Future<ApodSuccessState?> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedDataString = prefs.getString(_storageKey);

      if (cachedDataString != null) {
        // String ko wapas Map aur phir State mein badla
        final Map<String, dynamic> jsonData = jsonDecode(cachedDataString);
        return ApodSuccessState.fromJson(jsonData);
      }
    } catch (e) {
      debugPrint(" Error loading cache: $e");
    }
    return null;
  }
}
