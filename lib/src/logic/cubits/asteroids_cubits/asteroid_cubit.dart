import 'package:bloc/bloc.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/repository/nasa_repo/asteroid_repository/asteroid_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'asteroid_state.dart';

/*
User Action: Calendar se 10 Feb chuna.

Cubit Action: _processDateSelection(10 Feb) chala.

Logic: 10 se 16 Feb ki list bani. AsteroidLoadingState emit hua.

API: NASA se data aaya.

Final State: AsteroidSuccessState emit hua jisme 7 dates hain aur default active date 10 Feb hai.
*/


class AsteroidCubit extends Cubit<AsteroidState> {
  AsteroidCubit() : super(AsteroidInitial()) {
    // App khulte hi Case 1: Today's date fetch hogi
    loadInitialData();
  }

  final _repo = getIt<AsteroidRepository>();

  // Last date store karne ke liye
  DateTime _lastRequestedDate = DateTime.now();


  // 1. Initial Load (Sirf Today dikhega)
  //App khulte hi yeh function DateTime.now() ko process karta hai.
  //Case 1 (Default): Kyunki start aur end date dono "Aaj" ki hain,
  // toh rangeDates mein sirf 1 item banta hai. UI par sirf aaj ki
  // date ki list dikhta hai.

  void loadInitialData() {
    _processDateSelection(DateTime.now());
  }

// 2. Calendar Selection Logic
  Future<void> pickStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    // Default initial date: Aaj ki date
    DateTime initialCalendarDate = now;

    // Agar user pehle hi koi date select kar chuka hai (Success state mein hai),
    // toh wahi date calendar mein initial dikhao.
    if (state is AsteroidSuccessState) {
      initialCalendarDate = (state as AsteroidSuccessState).activeDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialCalendarDate, // Ab ye dynamic hai
      firstDate: DateTime(1995, 6, 16),
      lastDate: now,
    );

    if (picked != null) {
      _processDateSelection(picked);
    }
  }

  // 3. Range Calculation (Case 2 & 3 handle karne ke liye)
  //End Date Calculation: Yeh start.add(Duration(days: 6))
  //karta hai (Range banane ke liye), lekin isAfter(now)
  // check karke ise "Aaj" par rok deta hai
  //List Generation: Yeh un do dates ke beech ki saari dates ki ek
  // list (rangeDates) banata hai jo horizontal bar mein dikhni hain.

  void _processDateSelection(DateTime start) {
    _lastRequestedDate = start; // Date ko yaad rakho
    emit(AsteroidLoadingState());

    //stored todays date and time to check if my end date afyer 6 days is not beyond todays date.
    final DateTime todaysDate = DateTime.now();

    // Logic: Start se 6 din aage tak, lekin 'Now' se zyada nahi
    DateTime potentialEnd = start.add(const Duration(days: 6));
    DateTime finalEnd = potentialEnd.isAfter(todaysDate)
        ? todaysDate
        : potentialEnd;

    // Horizontal List ke liye dates calculate karna
    int daysDiff = finalEnd
        .difference(start)
        .inDays + 1;
    List<DateTime> newRange = List.generate(
        daysDiff,
            (i) => start.add(Duration(days: i))
    );

    // Ab API call trigger hogi (Abhi hum Success emit kar rahe hain placeholders ke saath)
    // Asal mein fetchAsteroids() ke baad Success emit hoga
    _fetchAsteroidsData(start, finalEnd, newRange);
  }

  // Cubit ke andar ka function jo API se connect hoga
  Future<void> _fetchAsteroidsData(DateTime start, DateTime end, List<DateTime> range) async {
    // 1. Loading State dikhao
    emit(AsteroidLoadingState());

    // 2. Formatting dates for NASA (yyyy-MM-dd)
    final String startStr = DateFormat('yyyy-MM-dd').format(start);
    final String endStr = DateFormat('yyyy-MM-dd').format(end);

    // 3. Repository call karein
    final result = await _repo.fetchAsteroidFeedData(
      startDate: startStr,
      endDate: endStr,
    );

    //print("CUBIT: API Call trigger ho rahi hai..."); // Ye check karo
    // 4. Result handle karein (Fpdart fold logic)
    result.fold(
          (customError) {
        // Agar error aaye (404, No Internet, etc.)
        emit(AsteroidErrorState(errorMessage: customError.message));
      },
          (feedModel) {
        // Agar success ho (Data mil jaye)
        // NASA ka Map seedha 'asteroidData' variable mein chala jayega
        emit(AsteroidSuccessState(
          activeDate: start, // User ki selected date active rahegi
          rangeDates: range,
          asteroidData: feedModel.nearEarthObjects ?? {},
        ));
      },
    );
  }

// NAYA FUNCTION: Retry button ke liye
  void retryFetch() {
    _processDateSelection(_lastRequestedDate);
  }


  // 4. Horizontal Bar Switch (Jab user date badle)
  //Yeh tab chalta hai jab user horizontal list mein scroll karke kisi
  // dusri date par click kare.
  //Yeh API call nahi karta! Yeh bas activeDate ko update karke
  // "Success State" ko phir se emit kar deta hai taaki UI refresh
  // ho jaye aur nayi list dikhne lage.
  void changeActiveDate(DateTime newDate) {
    if (state is AsteroidSuccessState) {
      final currentState = state as AsteroidSuccessState;
      emit(AsteroidSuccessState(
        activeDate: newDate,
        rangeDates: currentState.rangeDates,
        asteroidData: currentState.asteroidData,
      ),
      );
    }
  }
}
