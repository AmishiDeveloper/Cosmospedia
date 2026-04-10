part of 'asteroid_velocity_cubit.dart';

@immutable
sealed class AsteroidVelocityState {}

final class AsteroidVelocityInitial extends AsteroidVelocityState {}

final class AsteroidVelocityLoadingState extends AsteroidVelocityState {}

final class AsteroidVelocitySuccessState extends AsteroidVelocityState {
  final List<CloseApproachDatum> closeApproachData;
  AsteroidVelocitySuccessState({required this.closeApproachData});
}
