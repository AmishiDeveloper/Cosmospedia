import 'dart:core';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/logic/cubits/apod_cubit/apod_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_detail_screen.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_widgets/apod_shimmer_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_error_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'apod_widgets/apod_feature_card.dart';
import 'apod_widgets/apod_grid_widget.dart';

/*
apod ui screen mein hum saare logic (Cubit) aur data (Model) ko jod kar user ke liye ek sundar UI banate hain.
*/
class ApodScreen extends StatefulWidget {
  const ApodScreen({super.key});

  @override
  State<ApodScreen> createState() {
    return _ApodScreenState();
  }
}

class _ApodScreenState extends State<ApodScreen> {
  late TextEditingController _startDate;
  late TextEditingController _endDate;
  late FocusNode startDateFocusNode;
  late FocusNode endDateFocusNode;
  // 1. Ek Main ScrollController banao
  final ScrollController _mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    /* Jab screen pehli baar banti hai, hum aaj ki date (DateTime.now())
    nikal kar controllers mein default daal dete hain taaki khali
    textfields na dikhe.
    */
    String formattedTodaysDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _startDate = TextEditingController(text: formattedTodaysDate);
    _endDate = TextEditingController(text: formattedTodaysDate);
    startDateFocusNode = FocusNode();
    endDateFocusNode = FocusNode();
    _mainScrollController.addListener(() {
      if (_mainScrollController.position.pixels >=
          _mainScrollController.position.maxScrollExtent * 0.9) {
        context.read<ApodCubit>().loadMoreData();
      }
    });
  }

  //Jab user is screen se bahar jata hai, aur voh screen stack mein
  // nahi hoti hai toh controllers ko "delete" kar dete hain taaki
  // mobile ki memory (RAM) fuzool mein kharch na ho.
  @override
  void dispose() {
    // TODO: implement dispose
    _startDate.dispose();
    _endDate.dispose();
    startDateFocusNode.dispose();
    endDateFocusNode.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: customBackgroundWidget(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomAppBar(title: 'CosmosPedia'),

              Expanded(
                child: BlocConsumer<ApodCubit, ApodState>(
                  listener: (context, state) {
                    final cubit = context.read<ApodCubit>();

                    // 1. check for error state
                    if (state is ApodErrorState) {
                      if (state.errorMessage.contains("not available") ||
                          state.errorMessage.contains("Falling back")||
                          state.errorMessage.contains("Date must be between")
                      ) {
                        // Iske liye orange/warning snackbar dikhao bina retry button ke
                        showCustomSnackBar(
                          context: context,
                          message: state.errorMessage,
                          backgroundColor: AppColors.orangeShade800, // Alag color taaki user ko lage info hai
                        );

                        final successData = cubit.lastSuccessState;

                        if (successData != null) {
                          _startDate.text = successData.startDate;
                          _endDate.text = successData.endDate;
                        }
                      }
                      // 2.Agar beech mein error aaye (Date update ke waqt) jaise (Internet issue, etc.) aur ye initial fetch nahi hai
                      else if (!cubit.isInitialFetch) {
                        showCustomSnackBar(
                          context: context,
                          message: state.errorMessage,
                          actionLabel: 'Retry',
                          // Improvement: Retry button in snackbar
                          onActionPressed: () {
                            cubit.updateDateRange(
                              updatedStart: _startDate.text,
                              updatedEnd: _endDate.text,
                            );
                          },
                        );
                      }
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is ApodLoadingState ||
                      current is ApodErrorState ||
                      current is ApodSuccessState,

                  builder: (context, state) {
                    final cubit = context.read<ApodCubit>();
                    // Case 1: Pehli baar load ho raha hai
                    if (state is ApodLoadingState || state is ApodInitial) {
                      return const ApodShimmerWidget();
                    }

                    // Case 2: Pehli baar mein hi error aa gaya (No Carousel, No Data)
                    if (state is ApodErrorState && cubit.isInitialFetch) {
                      return CustomErrorWidget(
                        errorMessage: state.errorMessage,
                        onRetry: () {
                          cubit.getInitialData();
                        },
                      );
                    }

                    // Case 3: Sab sahi hai (Ya phir date update mein error aaya, par Carousel dikhana hai)
                    // if (state is ApodSuccessState || (state is ApodErrorState && !cubit.isInitialFetch))
                    // {
                    // Agar state Success hai toh wahi lo,Agar Error hai toh Cubit se
                    // uska 'state' mangwao (jo humne emit(currentState) kiya tha)
                    //In Dart when it is written state is ApodSuccessState, then only
                    // in that block state.apodImageList can be read. but as soon as
                    // || (OR) ApodErrorState is added, Dart due to "Type Safety"
                    // could not determine state.carouselImageList and other because
                    // there are no such variables in the error state
                    // by creating successData variable we are manually forcing that
                    // we know if the state is not initial state then cubit will already be
                    //having ApodSuccessState data so use that data only.
                    final successData = state is ApodSuccessState
                        ? state
                        : cubit.lastSuccessState;

                    return (successData != null)
                        ? _buildSuccessWidget(context: context,successData: successData,cubit: cubit)
                        : CustomErrorWidget(
                            errorMessage: 'Data not available',
                            onRetry: () {
                              if (cubit.isInitialFetch) {
                                cubit.getInitialData();
                              } else {
                                cubit.updateDateRange(
                                  updatedStart: _startDate.text,
                                  updatedEnd: _endDate.text,
                                );
                              }
                            },
                          );
                    // here
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessWidget({
    required BuildContext context,
    required ApodSuccessState successData,
    required ApodCubit cubit,
  }) {
    return SingleChildScrollView(
      controller: _mainScrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 240.h,
              //aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                //ui tells cubit that that index of the img has changed .then cubit updates the dots of the carousel
                cubit.updateCarouselIndex(index);
              },
            ),
            items: successData.apodCarouselImageList.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  //return CarouselShimmerWidget();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        AppRoute.fade(
                          ApodDetailScreen(
                            item: item,
                            heroTag: 'carousel_${item.date}',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        border: Border.all(color: AppColors.surfaceLight),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              // margin: EdgeInsets.symmetric(
                              //   horizontal: 5.w,
                              // ),
                              decoration: BoxDecoration(
                                color: AppColors.textPrimaryDark,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  topRight: Radius.circular(20.r),
                                ),
                              ),
                              child: Hero(
                                tag: 'carousel_${item.date}',
                                child: Image.network(
                                  item.url ??
                                      'https://www.shutterstock.com/image-vector/page-404-error-spaceman-flag-260nw-1484690978.jpg',
                                  // ApodModel ka url
                                  fit: BoxFit.cover,
                                  // Loading indicator jab tak image load ho rahi ho
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.surfaceLight,
                                          ),
                                        );
                                      },
                                  // Error agar image load na ho paye
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: AppColors.surfaceLight,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 2.h,
                              horizontal: 2.w,
                            ),
                            // margin: EdgeInsets.symmetric(
                            //   horizontal: 5.w,
                            // ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight.withOpacity(0.4),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.r),
                                bottomRight: Radius.circular(20.r),
                              ),
                              // border: Border.all(
                              //   color: AppColors.surfaceLight,
                              // ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  //'Universal Galaxy',
                                  item.title ?? 'No Title',
                                  style: AppTextStyles.headingSmallStyle(
                                    context,
                                  ).copyWith(color: AppColors.surfaceLight),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                Text(
                                  // '2026-02-12',
                                  item.date != null
                                      ? DateFormat('yyyy-MM-dd').format(item.date!)
                                      : '',
                                  style: AppTextStyles.subHeadingSmallStyle(
                                    context,
                                  ).copyWith(color: AppColors.surfaceLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),

          SizedBox(height: 12.h),

          // Carousel Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: successData.apodCarouselImageList.asMap().entries.map((
              entry,
            ) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: successData.currentCarouselIndex == entry.key
                    ? 18.w
                    : 7.w,
                // Active dot lamba hoga Niche jo chhote dots hain, woh check karte hain ki currentCarouselIndex kya hai. Jo dot active hota hai, uski width hum 18.w (lamba) kar dete hain.
                height: 7.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: successData.currentCarouselIndex == entry.key
                      ? AppColors.surfaceLight
                      : AppColors.surfaceLight.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 30.h),

          // Date Row
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _startDate,
                  hintText: 'Start Date',
                  labelText: 'FROM',
                  readOnly: true,
                  suffix: Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.surfaceLight,
                    size: 20.sp,
                  ),
                  onTap: () {
                    _selectDate(context, isStartDate: true);
                  },
                ),
              ),

              SizedBox(width: 20.w),

              Expanded(
                child: CustomTextField(
                  controller: _endDate,
                  hintText: 'End Date',
                  labelText: 'TO',
                  readOnly: true,
                  suffix: Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.surfaceLight,
                    size: 20.sp,
                  ),
                  onTap: () {
                    _selectDate(context, isStartDate: false);
                  },
                ),
              ),
            ],
          ),

          // Agar updating ho rahi hai toh LinearProgressIndicator dikhao
          Container(
            height: 30.h,
            alignment: Alignment.center,
            child: (successData.isUpdating)
                ? LinearProgressIndicator(
                    color: AppColors.surfaceLight,
                    backgroundColor: Colors.transparent,
                    minHeight: 2.h,
                  )
                : const SizedBox.shrink(),
          ),

          // feature card / Grid View
          successData.apodImageList.isEmpty
              ? Text(
                  "No images found for this range",
                  style: AppTextStyles.subHeadingMediumStyle(context),
                )
              : successData.apodImageList.length == 1
              ? ApodFeatureCard(item: successData.apodImageList[0])
              : ApodGridWidget(
                  items: successData.apodImageList,
                  //.cast<ApodModel>(),
                ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context, {required bool isStartDate}) async {
    // Current text ko DateTime mein convert karein taaki calendar wahi date dikhaye

    DateTime currentSelectedDate = DateFormat('dd-MM-yyyy').parse(isStartDate ? _startDate.text : _endDate.text);


    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentSelectedDate,
      // shows updated date on calendar when opened to change date
      firstDate: DateTime(1995, 6, 16),//isStartDate ? DateTime(1995, 6, 16) : startVal,
      // NASA APOD is date se shuru hua tha
      lastDate: DateTime.now(),//isStartDate ? endVal : DateTime.now(),
      // builder: (context, child) {
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       colorScheme: ColorScheme.dark(
      //         primary: AppColors.surfaceLight, // Selection color
      //         onPrimary: AppColors.black,
      //         surface: AppColors.greyShimmerShade900, // Background color
      //         onSurface: AppColors.surfaceLight,
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
    );

    // Agar user 'Cancel' dabaye toh 'picked' null hoga
    // Isliye hum check karte hain 'picked != null' taaki purani date overwrite na ho
    if (picked != null) {// means a date is selected

      DateTime startVal = DateFormat('dd-MM-yyyy').parse(_startDate.text);
      DateTime endVal = DateFormat('dd-MM-yyyy').parse(_endDate.text);

      // picked date is being formated in the date format dd-MM-yyyy
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);

      if (isStartDate) {
        if (picked.isAfter(endVal)) {
          showCustomSnackBar(
            context: context,
            message: "Start date can't be after end date!",
            backgroundColor: AppColors.warning,
          );
          return;
        }
        _startDate.text = formattedDate; // start TextField updated

        // calling api after updating the start date
        context.read<ApodCubit>().updateDateRange(updatedStart: formattedDate,);
      } else {
        if (picked.isBefore(startVal)) {
          showCustomSnackBar(
            context: context,
            message: "End date can't be before start date!",
            backgroundColor: AppColors.warning,
          );
          return; // Stop here
        }
        _endDate.text = formattedDate; // end textfield updated
        context.read<ApodCubit>().updateDateRange(updatedEnd: formattedDate); // calling api after updating the end date
      }
    }
  }
}
