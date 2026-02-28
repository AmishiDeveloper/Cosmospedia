part of 'asteroid_detail_cubit.dart';

@immutable
sealed class AsteroidDetailState {}

final class AsteroidDetailInitial extends AsteroidDetailState {}

final class AsteroidDetailLoadingState extends AsteroidDetailState {}

final class AsteroidDetailErrorState extends AsteroidDetailState {
  final String errorMessage;
  AsteroidDetailErrorState({required this.errorMessage});
}

final class AsteroidDetailSuccessState extends AsteroidDetailState {
  final AsteroidLookUpModel lookupModel;

  AsteroidDetailSuccessState({required this.lookupModel});
}

