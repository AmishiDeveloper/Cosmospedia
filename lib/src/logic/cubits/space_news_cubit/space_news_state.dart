part of 'space_news_cubit.dart';

@immutable
sealed class SpaceNewsState {}

final class SpaceNewsInitial extends SpaceNewsState {}

final class SpaceNewsLoadingState extends SpaceNewsState {
  final String loadingCategory; // Add this
  SpaceNewsLoadingState({this.loadingCategory = 'All'});
}

final class SpaceNewsErrorState extends SpaceNewsState {
  final String errorMessage;
  SpaceNewsErrorState({required this.errorMessage});
}

// old logic
// final class SpaceNewsSuccessState extends SpaceNewsState {
//   final DateTime activeDate;
//   final List<SpaceContent> combinedFeed;
//   final String activeCategory; // 'All', 'News', 'Missions', 'Events', 'Launches'
//
//   SpaceNewsSuccessState({
//     required this.activeDate,
//     required this.combinedFeed,
//     this.activeCategory = 'All',
//   });
// }

final class SpaceNewsSuccessState extends SpaceNewsState {
  final DateTime activeDate;
  final List<SpaceContent> combinedFeed;
  final String activeCategory;
  final bool isDefaultDate; // True agar 'Today' hai, False agar Calendar se select ki hai

  SpaceNewsSuccessState({
    required this.activeDate,
    required this.combinedFeed,
    required this.activeCategory,
    this.isDefaultDate = true,
  });

  // Helper for UI to check if we are on 'Today'
  bool get isToday =>
      activeDate.day == DateTime.now().day &&
          activeDate.month == DateTime.now().month &&
          activeDate.year == DateTime.now().year;
}


