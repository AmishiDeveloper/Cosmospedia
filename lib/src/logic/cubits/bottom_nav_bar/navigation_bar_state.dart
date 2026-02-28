part of 'navigation_bar_cubit.dart';

@immutable
sealed class NavigationBarState {
  const NavigationBarState();
}

final class NavigationBarInitial extends NavigationBarState {}
final class NavigationBarUpdateIndexState extends NavigationBarState {
  /*
  In dart there is a rule that for the child claas constructor to be const
  the parent constructor should also be const. here the parent class is :-
  NavigationBarState and its child class is NavigationBarUpdateIndexState.
  But since there is no constructor in parent class so it uses default constructor
  which by default is not const so const cant be used in child class as well.
  However we make a const non- parameterised constructor in parent class and not use default constructor
  due to this we can use const keyword
  */

  final int index;
  const NavigationBarUpdateIndexState({required this.index});
}
