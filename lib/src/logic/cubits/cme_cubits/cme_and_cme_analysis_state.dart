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
  final bool isUpdating;

  CmeAndCmeAnalysisSuccessState({
    required this.cmeData,required this.cmeAnalysis,
    required this.startDate,
    required this.endDate,
    this.isUpdating = false,
  });

  CmeAndCmeAnalysisSuccessState copyWith({
    List<CmeModel>? cmeData,
    List<CmeAnalysisModel>? cmeAnalysis,
    String? startDate,
    String? endDate,
    bool? isUpdating,
  }) {
    return CmeAndCmeAnalysisSuccessState(
      cmeData: cmeData ?? this.cmeData, // ?? se phele ye current obj ke copy with ke variables h aur ?? ke baad jo initially obj m data tha voh
      cmeAnalysis: cmeAnalysis ?? this.cmeAnalysis,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}
