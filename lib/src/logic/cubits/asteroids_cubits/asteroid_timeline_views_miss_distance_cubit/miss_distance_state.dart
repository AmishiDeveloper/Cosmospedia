part of 'miss_distance_cubit.dart';

@immutable
sealed class MissDistanceState {
  final CloseApproachDatum selectedApproach;

  const MissDistanceState({required this.selectedApproach});
}

final class MissDistanceInitial extends MissDistanceState {
  const MissDistanceInitial({required super.selectedApproach});
}

final class MissDistanceLoadingState extends MissDistanceState {
  MissDistanceLoadingState({required super.selectedApproach});
}

final class MissDistanceSuccessState extends MissDistanceState {
  final List<CloseApproachDatum> closeApproachData;

  MissDistanceSuccessState({
    required this.closeApproachData,
    required super.selectedApproach,
  });
}
