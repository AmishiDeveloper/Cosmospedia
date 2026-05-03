import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
import 'package:cosmospedia/src/data/model/cme_models/cme_model/cme_model.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/cme_repository/cme_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
part 'cme_and_cme_analysis_state.dart';

class CmeAndCmeAnalysisCubit extends Cubit<CmeAndCmeAnalysisState> {
  CmeAndCmeAnalysisCubit() : super(CmeAndCmeAnalysisInitial());

  final CmeRepository _repo = getIt<CmeRepository>();

  Future<void> fetchCmeAndAnalysisData({
    required String startDate,
    required String endDate,
  }) async {
    if (state is CmeAndCmeAnalysisSuccessState) {
      emit((state as CmeAndCmeAnalysisSuccessState).copyWith(isUpdating: true));
    } else {
      emit(CmeAndCmeAnalysisLoadingState());
    }

    final results = await Future.wait([
      _repo.fetchCmeData(startDate: startDate, endDate: endDate),
      _repo.fetchCmeAnalysisData(startDate: startDate, endDate: endDate),
    ]);

    results[0].fold(
          (error) => emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
          (cmeList) {
        results[1].fold(
              (error) => emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
              (analysisList) {
            final List<CmeModel> typedCmeList = List<CmeModel>.from(cmeList);
            final List<CmeAnalysisModel> typedAnalysisList = List<CmeAnalysisModel>.from(analysisList);

            //  FIX 1: Detect Mock data strictly by "Mock" keyword in Note
            // Agar API se real data aa raha hai toh ye 'false' hoga
            bool isMockData = typedCmeList.any((e) => e.note?.contains("Mock") ?? false) ||
                typedAnalysisList.any((e) => e.note?.contains("Mock") ?? false);

            List<CmeModel> finalCme = typedCmeList;
            List<CmeAnalysisModel> finalAnalysis = typedAnalysisList;

            //  FIX 2: Local Filtering SIRF Mock Data ke liye chale
            // Live data ko filter mat karo, kyunki NASA ne already range filter kar ke bheja hai
            if (isMockData) {
              finalCme = _filterCmeByDate(typedCmeList, startDate, endDate);
              finalAnalysis = _filterAnalysisByDate(typedAnalysisList, startDate, endDate);
            }

            double probability = _calculateProbability(finalCme);

            emit(CmeAndCmeAnalysisSuccessState(
              cmeData: finalCme,
              cmeAnalysis: finalAnalysis,
              startDate: startDate,
              endDate: endDate,
              activeDate: DateFormat('yyyy-MM-dd').parse(endDate),
              isUpdating: false,
              impactProbability: probability,
              isDemoMode: isMockData,
              calendarFirstDate: isMockData ? DateTime(2025, 4, 16) : DateTime(1995, 6, 16),
              calendarLastDate: isMockData ? DateTime(2026, 4, 16) : DateTime.now(),
              //message: isMockData ? "NASA Server offline. Showing Demo Data." : null,
            ));
          },
        );
      },
    );
  }

  // Filtering methods as they are (Used only for Mock mode)
  List<CmeModel> _filterCmeByDate(List<CmeModel> allData, String start, String end) {
    DateTime startDt = DateFormat('yyyy-MM-dd').parse(start);
    DateTime endDt = DateFormat('yyyy-MM-dd').parse(end);
    return allData.where((cme) {
      if (cme.startTime == null) return false;
      DateTime? cmeTime = DateTime.tryParse(cme.startTime!.replaceAll('Z', ''));
      if (cmeTime == null) return false;
      return cmeTime.isAfter(startDt.subtract(const Duration(seconds: 1))) &&
          cmeTime.isBefore(endDt.add(const Duration(days: 1)));
    }).toList();
  }

  List<CmeAnalysisModel> _filterAnalysisByDate(List<CmeAnalysisModel> allData, String start, String end) {
    DateTime startDt = DateFormat('yyyy-MM-dd').parse(start);
    DateTime endDt = DateFormat('yyyy-MM-dd').parse(end);
    return allData.where((analysis) {
      final String? timeStr = analysis.time215?.toString();
      if (timeStr == null) return false;
      DateTime? analysisTime = DateTime.tryParse(timeStr.replaceAll('Z', ''));
      if (analysisTime == null) return false;
      return analysisTime.isAfter(startDt.subtract(const Duration(seconds: 1))) &&
          analysisTime.isBefore(endDt.add(const Duration(days: 1)));
    }).toList();
  }

  double _calculateProbability(List<CmeModel> list) {
    if (list.isEmpty) return 0.0;
    final earthImpactCount = list.where((cme) {
      if (cme.cmeAnalyses == null || cme.cmeAnalyses!.isEmpty) return false;
      return cme.cmeAnalyses!.any((analysis) =>
      analysis.enlilList?.any((enlil) => enlil.estimatedShockArrivalTime != null) ?? false);
    }).length;
    return (earthImpactCount / list.length) * 100;
  }

  Future<void> updateDateRange(DateTime selectedDate) async {
    String end = DateFormat('yyyy-MM-dd').format(selectedDate);
    String start = DateFormat('yyyy-MM-dd').format(selectedDate.subtract(const Duration(days: 30)));
    await fetchCmeAndAnalysisData(startDate: start, endDate: end);
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (state is! CmeAndCmeAnalysisSuccessState) return;
    final currentState = state as CmeAndCmeAnalysisSuccessState;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentState.activeDate,
      firstDate: currentState.calendarFirstDate,
      lastDate: currentState.calendarLastDate,
    );
    if (picked != null) updateDateRange(picked);
  }

  void toggleCmeExpansion(int index) {
    if (state is CmeAndCmeAnalysisSuccessState) {
      final currentState = state as CmeAndCmeAnalysisSuccessState;
      if (currentState.cmeExpansionTileExpandedIndex == index) {
        emit(currentState.copyWith(forceNull: true));
      } else {
        emit(currentState.copyWith(cmeExpansionTileExpandedIndex: index));
      }
    }
  }
}