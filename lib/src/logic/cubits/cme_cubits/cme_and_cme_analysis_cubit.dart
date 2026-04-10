import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_model/cme_model.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/cme_repository/cme_repository.dart';
import 'package:meta/meta.dart';

part 'cme_and_cme_analysis_state.dart';

class CmeAndCmeAnalysisCubit extends Cubit<CmeAndCmeAnalysisState> {

  CmeAndCmeAnalysisCubit() : super(CmeAndCmeAnalysisInitial());

  final CmeRepository _repo = getIt<CmeRepository>();

  Future<void> fetchCmeAndAnalysisData({
    required String startDate,
    required String endDate,
  }) async {
    // Agar pehle se data hai, toh loading ki jagah isUpdating bhej sakte hain
    if (state is CmeAndCmeAnalysisSuccessState) {
      emit((state as CmeAndCmeAnalysisSuccessState).copyWith(isUpdating: true));
    } else {
      emit(CmeAndCmeAnalysisLoadingState());
    }

    // Shimmer effect ke liye delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Dono APIs ko parallel mein call kar rahe hain
    final results = await Future.wait([
      _repo.fetchCmeData(startDate: startDate, endDate: endDate),
      _repo.fetchCmeAnalysisData(startDate: startDate, endDate: endDate),
    ]);

    final cmeResponse = results[0];
    final analysisResponse = results[1];

    // Handling Responses using fold
    cmeResponse.fold(
          (error) => emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
          (cmeList) {
        analysisResponse.fold(
              (error) => emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
              (analysisList) {
            if (cmeList.isEmpty && analysisList.isEmpty) {
              emit(CmeAndCmeAnalysisErrorState(errorMessage: "No data found for this range"));
            } else {
              emit(CmeAndCmeAnalysisSuccessState(
                cmeData: cmeList as List<CmeModel>,
                cmeAnalysis: analysisList as List<CmeAnalysisModel>,
                startDate: startDate,
                endDate: endDate,
                isUpdating: false,
              ));
            }
          },
        );
      },
    );
  }

  // UI par bina api call kiye data update karne ke liye (Jaise filtering)
  void updateLocalView(List<CmeModel> filteredCme) {
    if (state is CmeAndCmeAnalysisSuccessState) {
      final currentState = state as CmeAndCmeAnalysisSuccessState;
      emit(currentState.copyWith(cmeData: filteredCme));
    }
  }


  // import 'package:bloc/bloc.dart';
  // import 'package:cosmospedia/src/core/service_locator.dart';
  // import 'package:cosmospedia/src/data/repository/nasa_repo/cme_repository/cme_repository.dart';
  // import 'package:flutter/material.dart';
  // import 'package:intl/intl.dart';
  // import 'package:meta/meta.dart';
  //
  // part 'cme_state.dart';
  //
  // class CMECubit extends Cubit<CMEState> {
  // CMECubit() : super(CMEInitial()) {
  // getInitialCMEData();
  // }
  //
  // final _repo = getIt<CMERepository>();
  // CMESuccessState? lastSuccessState;
  //
  // // 1. Initial Data Fetch (Dono APIs parallel mein)
  // Future<void> getInitialCMEData() async {
  // emit(CMELoadingState());
  //
  // // NASA DONKI default 30 days range
  // String end = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // String start = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)));
  //
  // // Parallel calls for Events and Analysis
  // final results = await Future.wait([
  // _repo.fetchCmeEventsData(startDate: start, endDate: end),
  // _repo.fetchCmeAnalysisData(startDate: start, endDate: end),
  // ]);
  //
  // final eventsRes = results[0];
  // final analysisRes = results[1];
  //
  // // Dono results ko check karke state emit karna
  // eventsRes.fold(
  // (error) => emit(CMEErrorState(errorMessage: error.message)),
  // (eventsList) {
  // analysisRes.fold(
  // (error) => emit(CMEErrorState(errorMessage: error.message)),
  // (analysisList) {
  // _emitSuccess(
  // CMESuccessState(
  // cmeEvents: eventsList,
  // cmeAnalysis: analysisList,
  // startDate: DateFormat('dd-MM-yyyy').format(DateTime.parse(start)),
  // endDate: DateFormat('dd-MM-yyyy').format(DateTime.parse(end)),
  // ),
  // );
  // },
  // );
  // },
  // );
  // }
  //
  // // 2. Date Range Update (Jab user calendar se date badle)
  // Future<void> updateDateRange({required String start, required String end}) async {
  // final currentState = (state is CMESuccessState) ? state as CMESuccessState : lastSuccessState;
  // if (currentState == null) return;
  //
  // // UI par loader dikhao (isUpdating: true)
  // _emitSuccess(currentState.copyWith(isUpdating: true, start: start, end: end));
  //
  // try {
  // // API format (yyyy-MM-dd)
  // String apiStart = DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(start));
  // String apiEnd = DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(end));
  //
  // final results = await Future.wait([
  // _repo.fetchCmeEventsData(startDate: apiStart, endDate: apiEnd),
  // _repo.fetchCmeAnalysisData(startDate: apiStart, endDate: apiEnd),
  // ]);
  //
  // results[0].fold(
  // (error) => emit(CMEErrorState(errorMessage: error.message)),
  // (newEvents) {
  // results[1].fold(
  // (error) => emit(CMEErrorState(errorMessage: error.message)),
  // (newAnalysis) {
  // _emitSuccess(
  // currentState.copyWith(
  // events: newEvents,
  // analysis: newAnalysis,
  // start: start,
  // end: end,
  // isUpdating: false,
  // ),
  // );
  // },
  // );
  // },
  // );
  // } catch (e) {
  // _emitSuccess(currentState.copyWith(isUpdating: false));
  // emit(CMEErrorState(errorMessage: "Failed to update solar data."));
  // }
  // }
  //
  // // Helper method to cache last success state
  // void _emitSuccess(CMESuccessState state) {
  // lastSuccessState = state;
  // emit(state);
  // }
  // }






// // CME data fetch karne ka function (Start aur End date ke saath)
//   Future<void> fetchCmeData({String? startDate, String? endDate}) async {
//     emit(CmeAndCmeAnalysisLoadingState());
//
//     // Optional: Shimmer effect dekhne ke liye delay (jaise aapne close approach mein kiya h)
//     await Future.delayed(const Duration(milliseconds: 800));
//
//     final response = await _repo.fetchCmeData(
//         startDate: startDate,
//         endDate: endDate
//     );
//
//     response.fold(
//           (error) => emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
//           (cmeList) {
//         if (cmeList.isEmpty) {
//           emit(CmeAndCmeAnalysisErrorState(errorMessage: "No CME activity found for this range"));
//         } else {
//           emit(CmeAndCmeAnalysisSuccessState(cmeData: cmeList));
//         }
//       },
//     );
//   }
//
//   // Agar aapko list filter karni ho (jaise miss distance mein update approach tha)
//   void updateCmeView(List<CmeModel> filteredData) {
//     emit(CmeAndCmeAnalysisSuccessState(cmeData: filteredData));
//   }

}
