import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'navigation_bar_state.dart';

class NavigationBarCubit extends Cubit<NavigationBarState> {
  NavigationBarCubit() : super(const NavigationBarUpdateIndexState(index: 0));

  /* note instead of- NavigationBarCubit() : super(NavigationBarInitial());
  NavigationBarCubit() : super(const NavigationBarUpdateIndexState(index: 0));
  this line is called this is because if initial state was being
  emitted then as app starts initial state is visible but our screen
  demands an index from starting i.e index 0 so that it can show the
  home screen.
  if intial state is kept then we have to use an extra check like
  if(state is NavigationBarInitial)
  */

  //int index=0;
  /* no need to keep this line int index=0. cubits aim is to
  store the data inside state. when we do
  emit(NavigationBarUpdateIndexState(index: index)) then index goes
  inside the state. by keeping the index variable in cubit class will
  be double work and cause mismatch*/

  void updateIndex (int newIndex){
    debugPrint("index of the bottom nav is: $newIndex");
    emit(NavigationBarUpdateIndexState(index: newIndex));
  }

}
