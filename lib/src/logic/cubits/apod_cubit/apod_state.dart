part of 'apod_cubit.dart';

/*
state tells what mood/state the ui is in currently
*/

// sealed is a keyword that is used to fix the boundary of the class
// here ApodState is a sealed class meaning the boundary of this class is
// fixed and no other states can exist other than the ones that already extend it
@immutable
sealed class ApodState {}


final class ApodInitial extends ApodState {} //Kyun: Jab app pehli baar khulti hai aur abhi tak humne NASA ko call bhi nahi kiya hota, tab screen "Khali" hoti hai. Yeh wahi state hai.

final class ApodLoadingState extends ApodState {}//Jab Cubit NASA se data mangwa raha hota hai, tab hum UI ko ye state bhejte hain taaki woh screen par shimmer widget /Spinning Circle (Loader) dikha sake.

final class ApodErrorState extends ApodState {// this state is used when there is some kind of mishap as in internet not available, nasa server down . along with emitting this state a message is also shown to the user depicting the problem that occurred
  final String errorMessage;
  ApodErrorState({required this.errorMessage});
}

final class ApodSuccessState extends ApodState { // this state is used when the data from the nasa has already appeared now how to show it in the ui is the concern
  final List<ApodModel> apodImageList; //Niche wali grid ya list mein dikhne wali images.
  final List<ApodModel> apodCarouselImageList; // carousel mein dikhne vali images
  final int currentCarouselIndex; // Carousel mein user abhi kaunsi image dekh raha hai (0, 1, 2...).
  final String startDate; //Screen par likhi hui "From" aur "To" wali dates ko yaad rakhne ke liye.
  final String endDate;
  final bool isUpdating;
  final bool isLoadMoreImages; // check karne ke liye ki kya aur nayi imgs lani h apod api se

  ApodSuccessState({
    required this.apodCarouselImageList,
    required this.apodImageList,
    required this.startDate,
    required this.endDate,
    this.currentCarouselIndex = 0,
    this.isUpdating = false, // Default false rahega
    this.isLoadMoreImages=false,
  });

  /* to create new box (state) while using the old data
  Flutter mein purani state ko "edit" nahi karte,instead ek Nayi State
  banate hain purane data ko use karke.

  humare paas ek dabba (State) hai jisme 5 images aur date rakhi hai.
  now user only updated date to get diff apod img date wise.

  copyWith- It helps to keep the old data while only updating the new data that has to be changed
  Woh purane dabbe se 5 images uthayega (kyunki images toh wahi hain)
  aur sirf Date nayi wali daal kar ek Naya state bana dega.

  ?? ka matlab: "Agar naya data (start) aaya hai toh woh lo, warna purana (this.startDate) hi chalne do."
  */


  ApodSuccessState copyWith({
    List<ApodModel>? apodCarouselImageList, // carousel imgs
    List<ApodModel>? apodImageList, // apod date wise imgs
    int? index,  // current img being viewed in the carousel
    String? start,
    String? end,
    bool? isUpdating,
    bool? isLoadMoreImages,
    }) {
    return ApodSuccessState(
      // Agar naya data aaya toh woh lo yani jo variables copywith m likhe h, warna purana hi data rehne do jo current obj mein h yani this.instanceVariable
      apodCarouselImageList: apodCarouselImageList ?? this.apodCarouselImageList, // Purani list vahi rakho
      apodImageList:apodImageList ?? this.apodImageList,
      currentCarouselIndex: index ?? this.currentCarouselIndex, // Agar naya index aaya toh badlo, varna purana hi rehne do
      startDate: start ?? this.startDate,
      endDate: end ?? this.endDate,
      isUpdating: isUpdating ?? this.isUpdating, // Naya value ya purana
      isLoadMoreImages: isLoadMoreImages ?? this.isLoadMoreImages,
    );
  }

}
