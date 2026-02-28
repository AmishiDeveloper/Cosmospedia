import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/apod_repository/apod_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
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

  final _repo = getIt<ApodRepository>(); // cubit calls the repo so that whenever data is required it can be used to get it
  bool isInitialFetch = true;
  // Yeh variable pichli success state ko sambhal kar rakhega
  ApodSuccessState? lastSuccessState;
  String? limitStartDate; // jisse agr date range badi ho toh data end date se start date tak hi apod img dikhaye usse zyada nahi toh start date store karne ke liye.

  // 1. Carousel ke liye (Screen load hote hi call karein)
  Future<void> getInitialData({String? yesterdayDate}) async {
    isInitialFetch = true;

    //getting data for the first time
    emit(ApodLoadingState()); // while data is being fetched from the api the shimmer is seen

    // Dono API calls parallel mein fetch karein (Better Performance)
    // Agar yesterdayDate pass ki gayi hai (fallback ke liye), toh use lo, warna DateTime.now()
    String currentUIFormat = yesterdayDate ?? DateFormat('dd-MM-yyyy').format(DateTime.now());

    // API ke liye yyyy-MM-dd format
    String currentAPIFormat = DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(currentUIFormat));

    final carouselResponse = await _repo.fetchApodList(count: 5); // api to show imgs in carousel
    final todayApodResponse = await _repo.fetchApodList(
      startDate: currentAPIFormat,
      endDate: currentAPIFormat); // todays apod to show in feature card

    // Dono results ko check karke ek hi baar Success emit karein
    /*Repository Either (Left/Right) bhejti thi? fold ka kaam hai use kholna.

    Left (Error): Agar error aaya, toh UI ko ApodErrorState bhej do.

    Right (Success): Agar data mil gaya, toh ApodSuccessState bhej do jisme
    saari images aur dates pack hongi.*/

    carouselResponse.fold(
      (error) => emit(ApodErrorState(errorMessage: error.message)),
      (carouselList) {
        todayApodResponse.fold(
          (error) {
            //emit(ApodErrorState(errorMessage: error.message));
            // Sirf ek baar fallback karein (infinite loop se bachne ke liye)
            if (error.code == 400 && yesterdayDate==null) {
              String yesterday = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 1)));
              getInitialData(yesterdayDate: yesterday);
            } else {
              emit(ApodErrorState(errorMessage: error.message));
            }
          },
          (todayList) {
            _emitSuccess(
              ApodSuccessState(
                apodCarouselImageList: carouselList,
                apodImageList: todayList,
                startDate: currentUIFormat,
                endDate: currentUIFormat,
              ),
            );
          },
        );
      },
    );
  }

  // Carousel Index Update
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

  // Date Range Update (Sirf neeche wali list ke liye)
  Future<void> updateDateRange({
    String? updatedStart,
    String? updatedEnd,
    bool isFallback = false
  }) async {
   // if (state is ApodSuccessState) {
      isInitialFetch = false; // Ab ye initial fetch nahi hai

      if (updatedStart != null) {
        limitStartDate = updatedStart; // Limit set ho gayi jitne apod img chahiye grid view mein
      }

      // 1. Check ki state valid hai ya nahi (Safety Check)
      final currentState = (state is ApodSuccessState) ? state as ApodSuccessState : lastSuccessState;
      if (currentState == null) return;

      // Agar start null hai toh purani wali start date use karo, agar end null hai toh purani wali end date use karo
      final String updatedStartDateString =
          updatedStart ??
          currentState
              .startDate; // if user selects new date ie user selects a new date using FROM date textfield, the new value is used otherwise todays(old) date is used
      final String updatedEndDateString =
          updatedEnd ??
          currentState
              .endDate; // if user selects new date ie user selects a new date using TO date textfield, the new value is used otherwise todays(old) date is used

      // Agar dates empty hain toh aage mat badhein mtlb agr aaj ki date bhi nahi h
      if (updatedStartDateString.isEmpty || updatedEndDateString.isEmpty) return;


      // converting to datetime to check ki from and to ki range sahi h aisa toh nahi from date badi ho end date se  .
      DateTime startDt = DateFormat('dd-MM-yyyy').parse(updatedStartDateString);
      DateTime endDt = DateFormat('dd-MM-yyyy').parse(updatedEndDateString);

      //Start Date End Date se badi nahi honi chahiye
      if (startDt.isAfter(endDt)) {
        emit(ApodErrorState(
            errorMessage: "Invalid Date Range: Start date cannot be after End date"));
        return; // Yahan se return ho jao taaki API call na ho
      }


      //NASA APOD ki shuruat se pehle ki date nahi honi chahiye
      DateTime nasaStartDate = DateTime(1995, 06, 16);
      if (startDt.isBefore(nasaStartDate)) {
        emit(ApodErrorState(
            errorMessage: "NASA's APOD collection starts from June 16, 1995."));
        return;
      }

      // 1. Nayi dates ke saath state emit karo (Isse UI update ho jayegi) aur Loader dikhane ke liye 'isUpdating: true' karo
      _emitSuccess(
        currentState.copyWith(
          start: updatedStartDateString,
          end: updatedEndDateString,
          isUpdating: true,
        ),
      );
      // rest all parameters are same of the ApodSuccessState like :-\
      //             apodCarouselImageList: same old list with 5 values,
      //             apodImageList: todays apod img when app loads for first time
      //             else if doing this for 2nd or third time then list of apod imgs
      //             in that range,
      //             startDate: this changes to updatedStartDateString,
      //             endDate: updatedEndDateString,
      //            // currentCarouselIndex: same old index,

      try {
        String apiStart = DateFormat('yyyy-MM-dd').format(startDt); // updating the date format of the updated date to match the format of date for ui then formatting it to match the date format of api i.e yyyy-mm-dd
        String apiEnd = DateFormat('yyyy-MM-dd').format(endDt);

        debugPrint("API CALLING: Start: $apiStart, End: $apiEnd");

        // 2. API hit karo nayi dates ke saath
        final response = await _repo.fetchApodList(
          startDate: apiStart,
          endDate: apiEnd);
        response.fold(
          (error) async {
            // Error aane par Loader band karo taaki UI stuck na rahe
            _emitSuccess(currentState.copyWith(isUpdating: false));

            // Case A: Data Not Available (Fallback)
            if ((error.message.contains("Date must be between")||error.message.contains("not available")||error.code == 400) && !isFallback) {
              String yesterday = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 1)));

              emit(
                ApodErrorState(
                  errorMessage:error.message,//"Data not available. Checking previous dates..."
                      //"Today's APOD not available. Falling back to yesterday.",
                ),
              );
              // Error dikhane ke turant baad wapas Success state pe aa jao
              // taaki UI ko purana data mil sake
              //emit(currentState.copyWith(isUpdating: false));
              // Khud ko hi yesterday ki date ke sath call karo
              // Re-syncing the state to show the last good data while we fetch fallback
              await updateDateRange(
                updatedStart: yesterday,
                updatedEnd: yesterday,
                  isFallback: true
              );
            } else {
              emit(ApodErrorState(errorMessage: error.message));
              //_emitSuccess(currentState.copyWith(isUpdating: false));
            }
          },
          (newList) {
            _emitSuccess(
              currentState.copyWith(
                apodImageList: newList.reversed.toList(),
                // bas apod img list update karo baki sab same rahega yani carousel imgs , carouel index, etc
                start: updatedStartDateString,
                end: updatedEndDateString,
                isUpdating: false, //Yahan loader band hoga
              ),
            );
          },
        );
      } catch (e) {
        _emitSuccess(currentState.copyWith(isUpdating: false));
        emit(ApodErrorState(errorMessage: "Something went wrong. Please try again."));
      }
  }


  // Cubit ke andar:
  Future<void> loadMoreData() async {
    if (state is! ApodSuccessState) return;
    final currentState = state as ApodSuccessState;

    // Agar pehle se load ho raha hai, toh dubara call mat karo
    if (currentState.isLoadMoreImages) return;

    // 1995 ki limit check
    DateTime currentStart = DateFormat('dd-MM-yyyy').parse(currentState.startDate);
    if (currentStart.isBefore(DateTime(1995, 06, 17))) return; // 16 June se pehle nahi jana

    // 1. LIMIT CHECK: Agar hum pehle hi limitStartDate tak pahunch gaye hain, toh STOP
    if (limitStartDate != null && currentState.startDate == limitStartDate) {
      return;
    }

    // 1. Loader dikhao (isLoadMore: true)
    emit(currentState.copyWith(isLoadMoreImages: true));

    //await Future.delayed(const Duration(seconds: 2));

    // 2. Next Batch Dates Calculate Karein
    // currentState.startDate hamari sabse purani date hai jo abhi grid mein hai
    DateTime currentOldest = DateFormat('dd-MM-yyyy').parse(currentState.startDate);
    DateTime limitDt = DateFormat('dd-MM-yyyy').parse(limitStartDate ?? currentState.startDate);

    DateTime nextEnd = currentOldest.subtract(const Duration(days: 1)); // Agla batch ek din pehle se shuru hoga
    DateTime nextStart = nextEnd.subtract(const Duration(days: 15)); // 15 din piche
    // 1995 ki limit check
    if (nextStart.isBefore(limitDt)) {
      nextStart = limitDt;//DateTime(1995, 06, 16);
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
          (error) => _emitSuccess(currentState.copyWith(isLoadMoreImages: false)),
          (newList) {

            // NASA bhejta hai: [1 Feb, 2 Feb, 3 Feb]
            // Humein chahiye Descending: [3 Feb, 2 Feb, 1 Feb]
            final reversedNewData = newList.reversed.toList();

            // Purane data mein Naya data niche jod do. Purani list + Nayi list (reversed taaki descending order rahe)
        final combinedList = List<ApodModel>.from(currentState.apodImageList)
          ..addAll(reversedNewData);

        _emitSuccess(currentState.copyWith(
          apodImageList: combinedList,
          start: DateFormat('dd-MM-yyyy').format(nextStart),
          isLoadMoreImages: false,
        ));
      },
    );
  }

  // Helper method jo state emit bhi karega aur cache bhi karega
  void _emitSuccess(ApodSuccessState state) {
    lastSuccessState = state; // Cache update
    emit(state);              // UI ko inform karo
  }

}
