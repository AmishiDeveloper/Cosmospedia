import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:cosmospedia/src/presentation/widgets/custom_elevated_button.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_error_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
    String formattedTodaysDate = DateFormat(
      'dd-MM-yyyy',
    ).format(DateTime.now());
    _startDate = TextEditingController(text: formattedTodaysDate);
    _endDate = TextEditingController(text: formattedTodaysDate);
    startDateFocusNode = FocusNode();
    endDateFocusNode = FocusNode();

    _mainScrollController.addListener(() {
      //Check karo ki kya Cubit abhi loading toh nahi kar raha
      final state = context.read<ApodCubit>().state;

      if (state is ApodSuccessState && !state.isLoadMoreImages && !state.isUpdating) {
        if (_mainScrollController.position.pixels >=
            _mainScrollController.position.maxScrollExtent * 0.9) {
          context.read<ApodCubit>().loadMoreData();
        }
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
                    //Visibility Guard (Doosri screen par snackbar block)
                    if (!ModalRoute.of(context)!.isCurrent) return;

                    final cubit = context.read<ApodCubit>();

                    // 1. Success State aane par TextFields update karo
                    if (state is ApodSuccessState) {
                      //Agar date pehle se wahi hai, toh controller mat chhedo
                      // 1. Controllers update karo (Success data aate hi correct date set hogi)
                      if (_startDate.text != state.startDate) {
                        _startDate.text = state.startDate;
                      }
                      if (_endDate.text != state.endDate) {
                        _endDate.text = state.endDate;
                      }

                      // 2. Agar Cubit ne koi message bheja hai, toh Snackbar dikhao
                      if (state.message != null && state.message!.isNotEmpty) {
                        //Purane snack bar hatao
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        showCustomSnackBar(
                          context: context,
                          message: state.message!,
                          backgroundColor: AppColors.orangeShade800,
                        );
                      }
                    }

                    // 1. check for error state
                    if (state is ApodErrorState) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      // Condition A: NASA Data Availability issues (Orange Snackbar)
                      if (state.errorMessage.contains("not available") ||
                          state.errorMessage.contains("Falling back") ||
                          state.errorMessage.contains("Date must be between")) {
                        // Iske liye orange/warning snackbar dikhao bina retry button ke
                        showCustomSnackBar(
                          context: context,
                          message: state.errorMessage,
                          backgroundColor: AppColors
                              .orangeShade800, // Alag color taaki user ko lage info hai
                        );

                        // Agar error ke waqt hamare paas koi purana success data hai,
                        // toh TextFields ko wapas wahi set kardo jo stable tha.
                        final successData = cubit.lastSuccessState;

                        if (successData != null) {
                          _startDate.text = successData.startDate;
                          _endDate.text = successData.endDate;
                        }
                      }

                      // 2.Agar Date update ke waqt  Network/Internet/Server errors aaye toh (Red/Default Snackbar).


                      else {
                        // Snackbar tabhi dikhao jab ya toh ye date update ho,
                        // ya initial fetch fail ho gaya ho (taaki user ko pata chale screen khali kyun hai)

                        if (!cubit.isInitialFetch ||
                            cubit.lastSuccessState == null) {
                          showCustomSnackBar(
                            context: context,
                            message: state.errorMessage,
                            backgroundColor: AppColors.error,
                            actionLabel: 'Retry',
                            // Improvement: Retry button in snackbar
                            // Agar dates input hain toh update range call karo, warna manual refresh
                            onActionPressed: () {
                              if (!cubit.isInitialFetch) {
                                cubit.updateDateRange(
                                  updatedStart: _startDate.text,
                                  updatedEnd: _endDate.text,
                                );
                              }
                              else {
                                cubit.manualRefresh();
                              }
                            },

                          );
                        }
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
                    //Agar loading hai PAR cache mil chuka hai (lastSuccessState), toh loading mat dikhao
                    if ((state is ApodLoadingState || state is ApodInitial) && cubit.lastSuccessState == null) {
                      return const ApodShimmerWidget();
                    }

                    // Case 2: Pehli baar mein hi error aa gaya (No Carousel, No Data)
                    if (state is ApodErrorState && cubit.isInitialFetch) {
                      return CustomErrorWidget(
                        errorMessage: state.errorMessage,
                        onRetry: () async {
                         await  cubit.manualRefresh();
                          //cubit.getInitialData();
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
                        ? _buildSuccessWidget(
                            context: context,
                            successData: successData,
                            cubit: cubit,
                          )
                        : CustomErrorWidget(
                            errorMessage: 'Data not available',
                            onRetry: () {
                              if (cubit.isInitialFetch) {
                                // cubit.getInitialData();
                                cubit.manualRefresh();
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
          // --- SECTION 1: CAROUSEL OR ERROR WIDGET ---
          successData.apodCarouselImageList.isEmpty
              ? SizedBox(
                  height: 250.h,
                  child: CustomErrorWidget(
                    errorMessage: "Carousel is lost in space!",
                    onRetry: () => context.read<ApodCubit>().retryCarousel(),
                  ),
                )
              : Column(
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
                            return _buildCarouselItem(context, item);
                          },
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 12.h),

                    // Carousel Dots Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: successData.apodCarouselImageList
                          .asMap()
                          .entries
                          .map((entry) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width:
                                  successData.currentCarouselIndex == entry.key
                                  ? 18.w
                                  : 7.w,
                              // Active dot lamba hoga Niche jo chhote dots hain, woh check karte hain ki currentCarouselIndex kya hai. Jo dot active hota hai, uski width hum 18.w (lamba) kar dete hain.
                              height: 7.h,
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color:
                                    successData.currentCarouselIndex ==
                                        entry.key
                                    ? AppColors.surfaceLight
                                    : AppColors.surfaceLight.withOpacity(0.3),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ],
                ),

          SizedBox(height: 30.h),

          // --- SECTION 2: DATE PICKER ROW ---
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

          // --- SECTION 3:feature card / Grid View
          successData.apodImageList.isEmpty
              ? Column(
                  children: [
                    Text(
                      "No images found for this range",
                      style: AppTextStyles.subHeadingMediumStyle(context),
                    ),
                    SizedBox(height: 10.h),
                    CustomElevatedButton(
                      onPressed: () => cubit.updateDateRange(),
                      //cubit.manualRefresh(), //  Yeh humne naya banaya tha
                      text: 'Try Fetching Again',
                    ),
                  ],
                )
              : successData.apodImageList.length == 1
              ? ApodFeatureCard(item: successData.apodImageList[0])
              : ApodGridWidget(
                  items: successData.apodImageList,
                  //.cast<ApodModel>(),
                ),

          SizedBox(height: 15.h), // Bottom padding
        ],
      ),
    );
  }

  GestureDetector _buildCarouselItem(BuildContext context, ApodModel item) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          AppRoute.fade(
            ApodDetailScreen(item: item, heroTag: 'carousel_${item.date}'),
          ),
        );
      },
      child: Container(
        //  Margin ko width se adjust karo taaki center page enlarge hone par side widgets ko na dabaye
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          // Yahan border hata diya taaki clipping issues na ho
          color: AppColors.greyShimmerShade700.withOpacity(0.4),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              blurRadius: 10.r,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // LAYER 1: Content (Image + Text)
            Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: 'carousel_${item.date}',
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: item.url ?? '',
                      width: double.infinity,
                      placeholder: (context, url) => buildImagePlaceholder(),
                      errorWidget: (context, url, error) =>
                          //const Icon(Icons.broken_image),
                      Container(
                        color: AppColors.textPrimaryDark,
                        // child: Center(
                        //   child: Icon(
                        //     Icons.broken_image,
                        //     color: AppColors.surfaceLight,
                        //     size: 40.r,
                        //   ),
                        // ),
                        child:CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:'https://media.istockphoto.com/id/692243858/photo/exoplanet-in-deep-space.jpg?s=612x612&w=0&k=20&c=KQ7B3RI8_D3qeD06RtE7IuEyiDHnLGDg-Hqp8Fe8PXU=',
                          width: double.infinity,
                          memCacheHeight: 400,
                          memCacheWidth: 800,
                        ),
                    ),
                  ),
                ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight.withOpacity(0.3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title ?? 'No Title',
                        style: AppTextStyles.headingSmallStyle(
                          context,
                        ).copyWith(color: AppColors.surfaceLight),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
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

            // LAYER 2:  PURE OVERLAY BORDER (No Padding logic here)
            // Ye sabse upar draw hoga, isliye content iske piche rahega
            Positioned.fill(
              child: IgnorePointer(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5.r),
                    bottom: Radius.circular(15.r),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.surfaceLight.withOpacity(0.6),
                        //  Border thickness manage karega overlap
                        width: 1.2.r,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    // Current text ko DateTime mein convert karein taaki calendar wahi date dikhaye

    DateTime currentSelectedDate = DateFormat(
      'dd-MM-yyyy',
    ).parse(isStartDate ? _startDate.text : _endDate.text);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentSelectedDate,
      // shows updated date on calendar when opened to change date
      firstDate: DateTime(1995, 6, 16),
      //isStartDate ? DateTime(1995, 6, 16) : startVal,
      // NASA APOD is date se shuru hua tha
      lastDate: DateTime.now(), //isStartDate ? endVal : DateTime.now(),
    );

    // Agar user 'Cancel' dabaye toh 'picked' null hoga
    // Isliye hum check karte hain 'picked != null' taaki purani date overwrite na ho
    if (picked != null) {
      // means a date is selected

      DateTime startVal = DateFormat('dd-MM-yyyy').parse(_startDate.text);
      DateTime endVal = DateFormat('dd-MM-yyyy').parse(_endDate.text);

      // picked date is being formated in the date format dd-MM-yyyy
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);

      if (isStartDate) {
        // A. Check karo start date end date ke baad toh nahi
        if (picked.isAfter(endVal)) {
          showCustomSnackBar(
            context: context,
            message: "Start date can't be after end date!",
            backgroundColor: AppColors.warning,
          );
          return;
        }

        // B: LIMIT CHECK (Peeche ki 60 din ki range)
        // Agar end date aur nayi selected start date ka farq 60 din se zyada hai
        if (endVal.difference(picked).inDays > 60) {
          showCustomSnackBar(
            context: context,
            message: "Range too large! Please select less than or equal to 2 months.",
            backgroundColor: AppColors.orangeShade800,
          );
          return;
        }

        // now set the start date in the text field
        _startDate.text = formattedDate; // start TextField updated

        // calling api after updating the start date
        context.read<ApodCubit>().updateDateRange(updatedStart: formattedDate);
      }
      else {
        // A: Check karo end date start date se pehle toh nahi
        if (picked.isBefore(startVal)) {
          showCustomSnackBar(
            context: context,
            message: "End date can't be before start date!",
            backgroundColor: AppColors.warning,
          );
          return; // Stop here
        }

        // B: LIMIT CHECK (Aage ki 60 din ki range)
        // Agar nayi selected end date aur purani start date ka farq 60 din se zyada hai
        if (picked.difference(startVal).inDays > 60) {
          showCustomSnackBar(
            context: context,
            message: "Range too large! Please select less than or equal to 2 months.",
            backgroundColor: AppColors.orangeShade800,
          );
          return;
        }
        // finally set the date in text field
        _endDate.text = formattedDate; // end textfield updated
        context.read<ApodCubit>().updateDateRange(
          updatedEnd: formattedDate,
        ); // calling api after updating the end date
      }
    }
  }

  Widget buildImagePlaceholder() {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.greyShimmerShade400,
        highlightColor: AppColors.surfaceLight.withOpacity(0.5),
        //greyShimmerShade100,
        duration: const Duration(milliseconds: 1000),
      ),
      // child: Container(
      //   width: double.infinity,
      //   height: 200.h, // Image ki height se match karna zaroori hai
      //   decoration: BoxDecoration(
      //     color: AppColors.greyShimmerShade400,
      //     borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      //   ),
      // ),
      child: Bone(
        // <--- Container ki jagah Bone use karo
        width: double.infinity,
        height: 200.h,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
    );
  }
}
