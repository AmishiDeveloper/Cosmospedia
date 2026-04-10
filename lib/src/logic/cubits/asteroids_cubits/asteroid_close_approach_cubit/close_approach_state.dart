part of 'close_approach_cubit.dart';

@immutable
sealed class CloseApproachState {}

final class CloseApproachInitial extends CloseApproachState {}

final class CloseApproachLoadingState extends CloseApproachState {}

final class CloseApproachSuccessState extends CloseApproachState {
  final List<CloseApproachDatum> closeApproachData;
  CloseApproachSuccessState({required this.closeApproachData});
}
