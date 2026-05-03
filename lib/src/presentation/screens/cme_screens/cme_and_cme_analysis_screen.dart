import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/logic/cubits/cme_cubits/cme_and_cme_analysis_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/cme_screens/cme_analysis_screen.dart';
import 'package:cosmospedia/src/presentation/screens/cme_screens/cme_screen.dart';
import 'package:cosmospedia/src/presentation/screens/cme_screens/cme_shimmer_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_snack_bar.dart'; // Snack bar import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CmeAndCmeAnalysisScreen extends StatefulWidget {
  const CmeAndCmeAnalysisScreen({super.key});

  @override
  State<CmeAndCmeAnalysisScreen> createState() =>
      _CmeAndCmeAnalysisScreenState();
}

class _CmeAndCmeAnalysisScreenState extends State<CmeAndCmeAnalysisScreen> {
  @override
  void initState() {
    super.initState();

    // Initial fetch: Pehle live try karega, fail hua toh fallback automatic ho jayega .Sirf current date pass ki hai, automatic data fetch ke liye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CmeAndCmeAnalysisCubit>().updateDateRange(DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Padding(
              padding:  EdgeInsets.only(top:10.h),
              child: const CustomAppBar(title: 'Coronal Mass Ejections & Analysis'),
            ),
          ),
        ),
        body: customBackgroundWidget(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: BlocConsumer<CmeAndCmeAnalysisCubit, CmeAndCmeAnalysisState>(
                listener: (context, state) {
                  // --- DEMO MODE HANDLER ---
                  // Ab agar Demo Mode on hota hai, toh sirf Snackbar dikhayega.
                  if (state is CmeAndCmeAnalysisSuccessState && state.message != null) {
                    // Informative snackbar for Demo Mode
                    showCustomSnackBar(
                      context: context,
                      message: state.message!,
                      backgroundColor: AppColors.orangeShade800,
                    );
                  }
                },
                builder: (context, state) {
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(child: SizedBox(height: 10.h)),

                        // Top Info Container (Dates Range)
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.all(15.h),
                            decoration: BoxDecoration(
                              color: AppColors.greyShimmerShade100.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(color: AppColors.textPrimaryDark),
                            ),
                            child: _buildDateInfoRow(context, state),
                          ),
                        ),

                        SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                        // Sticky Tab Bar
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            height: 50.h,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.greyShimmerShade600,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.r),
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primaryDark,
                                      AppColors.textDeepPurple,
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppColors.textPrimaryDark,
                                  ),
                                ),
                                labelStyle: AppTextStyles.subHeadingLargeStyle(context).copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                unselectedLabelColor: AppColors.greyShimmerShade50,
                                dividerColor: Colors.transparent,
                                tabs: const [
                                  Tab(text: "CME"),
                                  Tab(text: "CME Analysis"),
                                  // Tab(child: Expanded(child: Text("CME"))),
                                  // Tab(child: Expanded(child: Text("CME Analysis",textAlign: TextAlign.center,))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: _buildTabViewBody(context, state),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfoRow(BuildContext context, CmeAndCmeAnalysisState state) {
    bool isUpdating = false;
    String dateText = "Calculating...";

    if (state is CmeAndCmeAnalysisSuccessState) {
      isUpdating = state.isUpdating;
      dateText = isUpdating
          ? "Calculating period..."
          : "${formatForUI(state.startDate)} to ${formatForUI(state.endDate)}";
    } else if (state is CmeAndCmeAnalysisLoadingState) {
      dateText = "Fetching data...";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.date_range, color: AppColors.surfaceLight),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(
                "Monitoring Period (30 days)",
                style: AppTextStyles.descriptionSmallTextStyle(context),
              ),
            ),
            FittedBox(
              child: Text(
                dateText,
                style: AppTextStyles.descriptionSmallTextStyle(context).copyWith(
                  fontSize: 13.sp,
                  color: AppColors.greyShimmerShade300,
                ),
              ),
            ),
          ],
        ),
        //SizedBox(width:5.w),
        Expanded(
          child: Align(alignment: AlignmentGeometry.centerRight,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryDark,
              ),
              child: IconButton(
                onPressed: (state is CmeAndCmeAnalysisSuccessState && state.isUpdating)
                    ? null
                    : () => context.read<CmeAndCmeAnalysisCubit>().pickEndDate(context),
                icon: Icon(
                  Icons.calendar_month_rounded,
                  size: 24.h,
                  color: AppColors.surfaceLight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabViewBody(BuildContext context, CmeAndCmeAnalysisState state) {
    if (state is CmeAndCmeAnalysisLoadingState) {
      return CmeShimmerWidget();
    } else if (state is CmeAndCmeAnalysisErrorState) {
      return Center(
        child: Text(
          state.errorMessage,
          style: AppTextStyles.descriptionSmallTextStyle(context),
          textAlign: TextAlign.center,
        ),
      );
    } else if (state is CmeAndCmeAnalysisSuccessState) {
      return TabBarView(
        physics: const BouncingScrollPhysics(),
        children: [
          CmeScreen(
            cmeData: state.cmeData,
            expansionIndex: state.cmeExpansionTileExpandedIndex ?? -1,
          ),
          CmeAnalysisScreen(
            analysisData: state.cmeAnalysis,
            impactProbability: state.impactProbability,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  String formatForUI(String dateStr) {
    try {
      DateTime dt = DateFormat('yyyy-MM-dd').parse(dateStr);
      return DateFormat('dd MMM, yyyy').format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverAppBarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

