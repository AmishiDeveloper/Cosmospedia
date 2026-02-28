part of 'asteroid_cubit.dart';

@immutable
sealed class AsteroidState {}

final class AsteroidInitial extends AsteroidState {}

final class AsteroidLoadingState extends AsteroidState {}

final class AsteroidErrorState extends AsteroidState {
  final String errorMessage;
  AsteroidErrorState({required this.errorMessage});
}

final class AsteroidSuccessState extends AsteroidState {
  final DateTime activeDate;        // Jo date horizontal bar mein select hai
  final List<DateTime> rangeDates;  // Horizontal bar ki list (1 se 7 din)
  final Map<String, List<dynamic>> asteroidData; // Date-wise data { '2026-02-23': [...] }

  AsteroidSuccessState({
    required this.activeDate,
    required this.rangeDates,
    required this.asteroidData,
  });

}

