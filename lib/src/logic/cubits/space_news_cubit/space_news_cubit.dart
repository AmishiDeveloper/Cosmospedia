import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:cosmospedia/src/data/repository/space_dev_repo/space_news_repo/space_news_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'space_news_state.dart';

/// new logic
class SpaceNewsCubit extends Cubit<SpaceNewsState> {
  SpaceNewsCubit() : super(SpaceNewsInitial()) {
    // Initial load: All category, Today's date
    loadData(category: 'All', date: DateTime.now());
  }

  final _repo = getIt<SpaceNewsRepository>();

// --- MAIN DATA LOADER ---
// Ye function handle karega: Initial Load, Category Switch, aur Calendar Selection

  Future<void> loadData(
      {required String category, required DateTime date}) async {
    emit(SpaceNewsLoadingState(loadingCategory: category));

    dynamic result;
    bool isToday = _isSameDay(date, DateTime.now());

    // NAYA LOGIC: Agar user ne purani date select ki hai,
    // toh Repository ko query parameters ke saath hit karna hoga (Upcoming empty aayega)
    if (category == 'All') {
      result = await _repo.fetchCombinedFeed(
          limit: 50,
        targetDate: date,
      ); // Repository handle karega logic
    } else {
      switch (category) {
        case 'News':
          result = await _repo.fetchNewsArticles(limit: 50);
          break;
        case 'Missions':
          result = await _repo.fetchMissions(limit: 50);
          break;
        case 'Events':
          result = await _repo.fetchEvents(limit: 50);
          break;
        case 'Launches':
          result = await _repo.fetchLaunches(limit: 50);
          break;
      }
    }

    result.fold(
          (error) => emit(SpaceNewsErrorState(errorMessage: error.message)),
          (feed) {
        // Naya Filter Logic: Agar user ne Calendar se koi specific date select ki hai,
        // toh hum feed ko us date ke hisaab se filter karenge.
        List<SpaceContent> finalFeed = feed;

        // Category filter logic:
        // Agar 'All' hai, toh Repo ne filter kar diya hai.
        // Lekin agar specific category (News etc) hai, toh humein yahan filter karna hoga.

        if (category != 'All' && !isToday) {
        //if (!isToday) {
          finalFeed =
              feed
                  .where((item) => _isSameDay(item.publishedAtDate, date))
                  .toList();
        }

        emit(
          SpaceNewsSuccessState(
            combinedFeed: finalFeed,
            activeCategory: category,
            activeDate: date,
            isDefaultDate: isToday,
          ),
        );
      },
    );
  }

//Date comparison bina time ke
  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  // 2. Chip selection
  // Specific Categories (News, Missions, Events, Launches)
  // Jab user specific chip par click karega (e.g., News only)

  void getSpecificCategory(String category) {
    DateTime currentDate = DateTime.now();
    if (state is SpaceNewsSuccessState) {
      currentDate = (state as SpaceNewsSuccessState).activeDate;
    }
    loadData(category: category, date: currentDate);
  }

  // reset to today

  void resetToToday() {
    String currentCat = 'All';
    if (state is SpaceNewsSuccessState) {
      currentCat = (state as SpaceNewsSuccessState).activeCategory;
    }
    loadData(category: currentCat, date: DateTime.now());
  }

  //2. Calendar Selection Logic

  Future<void> pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    String currentCat = 'All';

    // Agar user pehle hi koi date select kar chuka hai (Success state mein hai),
    // toh wahi date calendar mein initial dikhao.

    if (state is SpaceNewsSuccessState) {
      initialDate = (state as SpaceNewsSuccessState).activeDate;
      currentCat = (state as SpaceNewsSuccessState).activeCategory;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // Ab ye dynamic hai
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now().add(
          const Duration(days: 365)), // Future dates allowed for launches
    );

    if (picked != null) {
      loadData(category: currentCat, date: picked);
    }
  }
}

/// old logic
// class SpaceNewsCubit extends Cubit<SpaceNewsState> {
//   SpaceNewsCubit() : super(SpaceNewsInitial()){
//     getCombinedFeed();
//   }
//
//   final _repo = getIt<SpaceNewsRepository>();
//
//   // 1. Unified Feed (Default: All Chip)
//   // Yeh function repository ke combined feed ko call karta hai
//   // jisme news, events aur launches sab merged aur sorted hote hain.
//   Future<void> getCombinedFeed({int limit = 10}) async {
//     emit(SpaceNewsLoadingState());
//
//     final result = await _repo.fetchCombinedFeed(limit: limit);
//
//     result.fold(
//           (error) => emit(SpaceNewsErrorState(errorMessage: error.message)),
//           (feed) => emit(SpaceNewsSuccessState(
//         combinedFeed: feed,
//         activeCategory: 'All',
//             activeDate: DateTime.now(),
//       ),
//           ),
//     );
//   }
//
//   // 2. Specific Categories (News, Missions, Events, Launches)
//   // Jab user specific chip par click karega (e.g., News only)
//   // toh hum repository ke private functions (jo ab public ya specific wrapper honi chahiye)
//   // ko call kar sakte hain.
//   Future<void> getSpecificCategory(String category) async {
//     if (category == 'All') {
//       getCombinedFeed();
//       return;
//     }
//
//     emit(SpaceNewsLoadingState());
//
//     // Yahan hum decide karenge ki kaunsa repository method call karna hai
//     // Note: Aapko Repository mein in functions ko public karna hoga ya wrapper banana hoga
//     // Abhi ke liye main repository logic ke according example de raha hoon.
//
//     dynamic result;
//
//     switch (category) {
//       case 'News':
//         result = await _repo.fetchNewsArticles(limit: 10);
//         break;
//       case 'Missions':
//         result = await _repo.fetchEvents(limit: 10);
//         break;
//       case 'Events':
//         result = await _repo.fetchEvents(limit: 10);
//         break;
//       case 'Launches':
//         result = await _repo.fetchLaunches(limit: 10);
//         break;
//       default:
//         getCombinedFeed();
//         return;
//     }
//
//     result.fold(
//           (error) => emit(SpaceNewsErrorState(errorMessage: error.message)),
//           (feed) => emit(SpaceNewsSuccessState(
//         combinedFeed: feed,
//         activeCategory: category,
//             activeDate: DateTime.now(),
//       ),
//           ),
//     );
//   }
//
//   // 3. Retry Logic
//   // Agar error aaye toh user refresh kar sake
//   void refreshFeed() {
//     if (state is SpaceNewsSuccessState) {
//       getSpecificCategory((state as SpaceNewsSuccessState).activeCategory);
//     } else {
//       getCombinedFeed();
//     }
//   }
//
//   // 2. Calendar Selection Logic
//   Future<void> pickDate(BuildContext context) async {
//     final DateTime now = DateTime.now();
//
//     // Default initial date: Aaj ki date
//     DateTime initialCalendarDate = now;
//
//     // Agar user pehle hi koi date select kar chuka hai (Success state mein hai),
//     // toh wahi date calendar mein initial dikhao.
//     if (state is SpaceNewsSuccessState) {
//       initialCalendarDate = (state as SpaceNewsSuccessState).activeDate;
//     }
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialCalendarDate, // Ab ye dynamic hai
//       firstDate: DateTime(1995, 6, 16),
//       lastDate: now,
//     );
//
//     // if (picked != null) {
//     //   _processDateSelection(picked);
//     // }
//   }
//
// }


