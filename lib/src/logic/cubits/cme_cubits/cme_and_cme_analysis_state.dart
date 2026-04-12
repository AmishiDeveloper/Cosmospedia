part of 'cme_and_cme_analysis_cubit.dart';

@immutable
sealed class CmeAndCmeAnalysisState {}

final class CmeAndCmeAnalysisInitial extends CmeAndCmeAnalysisState {}


final class CmeAndCmeAnalysisLoadingState extends CmeAndCmeAnalysisState {}

final class CmeAndCmeAnalysisErrorState extends CmeAndCmeAnalysisState {
  final String errorMessage;
  CmeAndCmeAnalysisErrorState({required this.errorMessage});
}

final class CmeAndCmeAnalysisSuccessState extends CmeAndCmeAnalysisState {
  // Yahan CmeModel aapka model class hoga jo NASA API se map hota h
  final List<CmeModel> cmeData;
  final List<CmeAnalysisModel> cmeAnalysis;     // Tab 2: Charts ke liye
  final String startDate;
  final String endDate;
  final DateTime activeDate;
  final bool isUpdating;
  final int? cmeExpansionTileExpandedIndex; // New Variable: null matlab koi card open nahi h
  final double impactProbability;

  CmeAndCmeAnalysisSuccessState({
    required this.cmeData,required this.cmeAnalysis,
    required this.startDate,
    required this.endDate,
    required this.activeDate,
    this.isUpdating = false,
    this.cmeExpansionTileExpandedIndex,//initially null
    required this.impactProbability,
  });

  CmeAndCmeAnalysisSuccessState copyWith({
    List<CmeModel>? cmeData,
    List<CmeAnalysisModel>? cmeAnalysis,
    String? startDate,
    String? endDate,
    DateTime? activeDate, // yeh end date h jo calendar se select hui h jisse end se 30 din ke phele tak ka data dikh sake
    bool? isUpdating,
    int? cmeExpansionTileExpandedIndex,
    double? impactProbability,
    bool forceNull = false, // Null set karne ke liye
  }) {
    return CmeAndCmeAnalysisSuccessState(
      cmeData: cmeData ?? this.cmeData, // ?? se phele ye current obj ke copy with ke variables h aur ?? ke baad jo initially obj m data tha voh
      cmeAnalysis: cmeAnalysis ?? this.cmeAnalysis,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      activeDate: activeDate ?? this.activeDate,
      isUpdating: isUpdating ?? this.isUpdating,
      impactProbability: impactProbability ?? this.impactProbability,
      cmeExpansionTileExpandedIndex: forceNull
          ? null
          : (cmeExpansionTileExpandedIndex ?? this.cmeExpansionTileExpandedIndex),
    );
  }
}
