// import 'package:bloc/bloc.dart';
// import 'package:cosmospedia/src/core/service_locator.dart';
// import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
// import 'package:cosmospedia/src/data/model/cme_models/cme_model/cme_model.dart';
// import 'package:cosmospedia/src/data/repository/nasa_repo/cme_repository/cme_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:meta/meta.dart';
//
// part 'cme_and_cme_analysis_state.dart';

// class CmeAndCmeAnalysisCubit extends Cubit<CmeAndCmeAnalysisState> {
//
//   CmeAndCmeAnalysisCubit() : super(CmeAndCmeAnalysisInitial());
//
//   final CmeRepository _repo = getIt<CmeRepository>();
//
//   Future<void> fetchCmeAndAnalysisData({
//     required String startDate,
//     required String endDate,
//   }) async {
//     // Agar pehle se data hai, toh loading ki jagah isUpdating bhej sakte hain
//     if (state is CmeAndCmeAnalysisSuccessState) {
//       emit((state as CmeAndCmeAnalysisSuccessState).copyWith(isUpdating: true));
//     } else {
//       emit(CmeAndCmeAnalysisLoadingState());
//     }
//
//     // Shimmer effect ke liye delay
//     await Future.delayed(const Duration(milliseconds: 800));
//
//     // Dono APIs ko parallel mein call kar rahe hain
//     final results = await Future.wait([
//       _repo.fetchCmeData(startDate: startDate, endDate: endDate),
//       _repo.fetchCmeAnalysisData(startDate: startDate, endDate: endDate),
//     ]);
//
//     final cmeResponse = results[0];
//     final analysisResponse = results[1];
//
//     // Handling Responses using fold
//     cmeResponse.fold(
//           (error) =>
//           emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
//           (cmeList) {
//         analysisResponse.fold(
//               (error) =>
//               emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
//               (analysisList) {
//             if (cmeList.isEmpty && analysisList.isEmpty) {
//               emit(CmeAndCmeAnalysisErrorState(
//                   errorMessage: "No data found for this range"));
//             } else {
//               final typedCmeList = cmeList as List<CmeModel>;
//               // 🎯 Logic: Shock Arrival Time check karna
//               final totalCmes = typedCmeList.length;
//
//               final earthImpactCount = typedCmeList.where((cme) {
//                 // 1. Check karo ki analyses list null ya empty toh nahi h
//                 if (cme.cmeAnalyses == null || cme.cmeAnalyses!.isEmpty)
//                   return false;
//
//                 // 2. cmeAnalyses list ke andar 'any' analysis check karo jisme enlilList ho
//                 return cme.cmeAnalyses!.any((analysis) {
//                   return analysis.enlilList != null &&
//                       analysis.enlilList!.any((enlil) =>
//                       enlil.estimatedShockArrivalTime != null);
//                 });
//               }).length;
//
//               double probability = totalCmes > 0
//                   ? (earthImpactCount / totalCmes) * 100
//                   : 0.0;
//
//               emit(CmeAndCmeAnalysisSuccessState(
//                 cmeData: cmeList as List<CmeModel>,
//                 cmeAnalysis: analysisList as List<CmeAnalysisModel>,
//                 startDate: startDate,
//                 endDate: endDate,
//                 activeDate: DateFormat('yyyy-MM-dd').parse(endDate),
//                 isUpdating: false,
//                 impactProbability: probability,
//               ));
//             }
//           },
//         );
//       },
//     );
//   }
//
//   // UI par bina api call kiye data update karne ke liye (Jaise filtering)
//   void updateLocalView(List<CmeModel> filteredCme) {
//     if (state is CmeAndCmeAnalysisSuccessState) {
//       final currentState = state as CmeAndCmeAnalysisSuccessState;
//       emit(currentState.copyWith(cmeData: filteredCme));
//     }
//   }
//
//   void toggleCmeExpansion(int index) {
//     if (state is CmeAndCmeAnalysisSuccessState) {
//       final currentState = state as CmeAndCmeAnalysisSuccessState;
//
//       if (currentState.cmeExpansionTileExpandedIndex == index) {
//         // Agar same index click hua toh band kar do (null set karo)
//         emit(currentState.copyWith(forceNull: true));
//       } else {
//         // Naya index kholo
//         emit(currentState.copyWith(cmeExpansionTileExpandedIndex: index));
//       }
//     }
//   }
//
//   Future<void> pickEndDate(BuildContext context) async {
//     final DateTime now = DateTime.now();
//
//     // Default initial date: Aaj ki date
//     DateTime initialCalendarDate = now;
//
//     // Agar user pehle hi koi date select kar chuka hai (Success state mein hai),
//     // toh wahi date calendar mein initial dikhao.
//     if (state is CmeAndCmeAnalysisSuccessState) {
//       initialCalendarDate = (state as CmeAndCmeAnalysisSuccessState).activeDate;
//     }
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialCalendarDate, // Ab ye dynamic hai
//       firstDate: DateTime(1995, 6, 16),
//       lastDate: now,
//     );
//
//     if (picked != null) {
//       updateDateRange(picked);
//     }
//   }
//
//   Future<void> updateDateRange(DateTime selectedDate) async {
//     // Check if we are in success state to show "Calculating..."
//     if (state is CmeAndCmeAnalysisSuccessState) {
//       final currentState = state as CmeAndCmeAnalysisSuccessState;
//
//       // API hit karne se pehle isUpdating ko true emit kar do
//       emit(currentState.copyWith(isUpdating: true));
//     }
//
//     // 1. End Date wahi hogi jo user ne select ki h
//     String end = DateFormat('yyyy-MM-dd').format(selectedDate);
//
//     // 2. Start Date usse 30 din pehle ki
//     String start = DateFormat('yyyy-MM-dd').format(
//         selectedDate.subtract(const Duration(days: 30))
//     );
//
//     // 3. API hit karo naye range ke saath
//     await fetchCmeAndAnalysisData(startDate: start, endDate: end);
//   }
//
// }



// NEW OLD LOGIC
// import 'package:bloc/bloc.dart';
// import 'package:cosmospedia/src/core/service_locator.dart';
// import 'package:cosmospedia/src/data/model/cme_models/cme_analysis_model/cme_analysis_model.dart';
// import 'package:cosmospedia/src/data/model/cme_models/cme_model/cme_model.dart';
// import 'package:cosmospedia/src/data/repository/nasa_repo/cme_repository/cme_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:meta/meta.dart';
//
// part 'cme_and_cme_analysis_state.dart';
//
// class CmeAndCmeAnalysisCubit extends Cubit<CmeAndCmeAnalysisState> {
//   CmeAndCmeAnalysisCubit() : super(CmeAndCmeAnalysisInitial());
//
//   final CmeRepository _repo = getIt<CmeRepository>();
//
//   Future<void> fetchCmeAndAnalysisData({
//     required String startDate,
//     required String endDate,
//   }) async {
//     if (state is CmeAndCmeAnalysisSuccessState) {
//       emit((state as CmeAndCmeAnalysisSuccessState).copyWith(isUpdating: true));
//     } else {
//       emit(CmeAndCmeAnalysisLoadingState());
//     }
//
//     final results = await Future.wait([
//       _repo.fetchCmeData(startDate: startDate, endDate: endDate),
//       _repo.fetchCmeAnalysisData(startDate: startDate, endDate: endDate),
//     ]);
//
//     results[0].fold(
//           (error) => emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
//           (cmeList) {
//         results[1].fold(
//               (error) => emit(CmeAndCmeAnalysisErrorState(errorMessage: error.message)),
//               (analysisList) {
//             final List<CmeModel> typedCmeList = List<CmeModel>.from(cmeList);
//             final List<CmeAnalysisModel> typedAnalysisList = List<CmeAnalysisModel>.from(analysisList);
//
//             // 🎯 FIX: Sirf tabhi Demo Mode maano jab Repository ne "MOCK" Note bheja ho
//             // Agar real API khali list [] bhej rahi hai, toh use empty live data hi dikhao!
//             bool isMockData = typedCmeList.any((e) => e.note?.contains("Mock") ?? false);
//
//             List<CmeModel> finalCme = typedCmeList;
//             List<CmeAnalysisModel> finalAnalysis = typedAnalysisList;
//
//             if (isMockData) {
//               // Sirf Demo mode mein filtering karein
//               finalCme = _filterCmeByDate(typedCmeList, startDate, endDate);
//               finalAnalysis = _filterAnalysisByDate(typedAnalysisList, startDate, endDate);
//             }
//
//             double probability = _calculateProbability(finalCme);
//
//             emit(CmeAndCmeAnalysisSuccessState(
//               cmeData: finalCme,
//               cmeAnalysis: finalAnalysis,
//               startDate: startDate,
//               endDate: endDate,
//               activeDate: DateFormat('yyyy-MM-dd').parse(endDate),
//               isUpdating: false,
//               impactProbability: probability,
//               isDemoMode: isMockData, // 🎯 Live data hai toh false rahega
//               calendarFirstDate: isMockData ? DateTime(2025, 4, 16) : DateTime(1995, 6, 16),
//               calendarLastDate: isMockData ? DateTime(2026, 4, 16) : DateTime.now(),
//               message: isMockData ? "Showing Demo CME Data." : null,
//             ));
//           },
//         );
//       },
//     );
//   }
//
//   // CME Filter
//   List<CmeModel> _filterCmeByDate(List<CmeModel> allData, String start, String end) {
//     DateTime startDt = DateFormat('yyyy-MM-dd').parse(start);
//     DateTime endDt = DateFormat('yyyy-MM-dd').parse(end);
//
//     return allData.where((cme) {
//       if (cme.startTime == null) return false;
//       DateTime? cmeTime = DateTime.tryParse(cme.startTime!.replaceAll('Z', ''));
//       if (cmeTime == null) return false;
//       return cmeTime.isAfter(startDt.subtract(const Duration(seconds: 1))) &&
//           cmeTime.isBefore(endDt.add(const Duration(days: 1)));
//     }).toList();
//   }
//
//   //  CME Analysis Filter (Fixed Version)
//   List<CmeAnalysisModel> _filterAnalysisByDate(List<CmeAnalysisModel> allData, String start, String end) {
//     DateTime startDt = DateFormat('yyyy-MM-dd').parse(start);
//     DateTime endDt = DateFormat('yyyy-MM-dd').parse(end);
//
//     return allData.where((analysis) {
//       final String? timeStr = analysis.time215?.toString();
//       if (timeStr == null) return false;
//
//       DateTime? analysisTime = DateTime.tryParse(timeStr.replaceAll('Z', ''));
//       if (analysisTime == null) return false;
//
//       return analysisTime.isAfter(startDt.subtract(const Duration(seconds: 1))) &&
//           analysisTime.isBefore(endDt.add(const Duration(days: 1)));
//     }).toList();
//   }
//
//   double _calculateProbability(List<CmeModel> list) {
//     if (list.isEmpty) return 0.0;
//     final earthImpactCount = list.where((cme) {
//       if (cme.cmeAnalyses == null || cme.cmeAnalyses!.isEmpty) return false;
//       return cme.cmeAnalyses!.any((analysis) =>
//       analysis.enlilList?.any((enlil) => enlil.estimatedShockArrivalTime != null) ?? false);
//     }).length;
//     return (earthImpactCount / list.length) * 100;
//   }
//
//   Future<void> updateDateRange(DateTime selectedDate) async {
//     String end = DateFormat('yyyy-MM-dd').format(selectedDate);
//     String start = DateFormat('yyyy-MM-dd').format(selectedDate.subtract(const Duration(days: 30)));
//     await fetchCmeAndAnalysisData(startDate: start, endDate: end);
//   }
//
//   Future<void> pickEndDate(BuildContext context) async {
//     if (state is! CmeAndCmeAnalysisSuccessState) return;
//     final currentState = state as CmeAndCmeAnalysisSuccessState;
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: currentState.activeDate,
//       firstDate: currentState.calendarFirstDate,
//       lastDate: currentState.calendarLastDate,
//     );
//     if (picked != null) updateDateRange(picked);
//   }
//
//   void toggleCmeExpansion(int index) {
//     if (state is CmeAndCmeAnalysisSuccessState) {
//       final currentState = state as CmeAndCmeAnalysisSuccessState;
//       if (currentState.cmeExpansionTileExpandedIndex == index) {
//         emit(currentState.copyWith(forceNull: true));
//       } else {
//         emit(currentState.copyWith(cmeExpansionTileExpandedIndex: index));
//       }
//     }
//   }
// }



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