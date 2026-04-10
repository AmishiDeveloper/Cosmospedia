import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/logic/cubits/cme_cubits/cme_and_cme_analysis_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/cme_screens/cme_analysis_screen.dart';
import 'package:cosmospedia/src/presentation/screens/cme_screens/cme_screen.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CmeAndCmeAnalysisScreen extends StatefulWidget {
  const CmeAndCmeAnalysisScreen({super.key});

  @override
  State<CmeAndCmeAnalysisScreen> createState() => _CmeAndCmeAnalysisScreenState();
}

class _CmeAndCmeAnalysisScreenState extends State<CmeAndCmeAnalysisScreen> {

  @override
  void initState() {
    super.initState();
    // API Hit on start
    String end = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String start = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<CmeAndCmeAnalysisCubit>().fetchCmeAndAnalysisData(
          startDate: start,
          endDate: end,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    String end = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String start = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)));

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
            title: CustomAppBar(title: 'Coronal Mass Ejections & Analysis'),
          ),
        ),
        body: customBackgroundWidget(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: NestedScrollView(
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
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.date_range, color: AppColors.surfaceLight),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Monitoring Period",
                                    style: AppTextStyles.descriptionSmallTextStyle(context)),
                                Text("${start} to ${end}",
                                    style: AppTextStyles.subHeadingLargeStyle(context).copyWith(fontSize: 16.sp)),
                              ],
                            ),
                          ],
                        ),
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
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.r),
                              gradient: LinearGradient(
                                colors: [AppColors.primaryDark, AppColors.textDeepPurple],
                              ),
                              border: Border.all(color: AppColors.textPrimaryDark),
                            ),
                            labelStyle: AppTextStyles.subHeadingLargeStyle(context).copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            unselectedLabelColor: AppColors.greyShimmerShade50,
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(text: "CME "),
                              Tab(text: "Impact Analysis"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: BlocBuilder<CmeAndCmeAnalysisCubit, CmeAndCmeAnalysisState>(
                  builder: (context, state) {
                    if (state is CmeAndCmeAnalysisLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CmeAndCmeAnalysisErrorState) {
                      return Center(child: Text(state.errorMessage));
                    } else if (state is CmeAndCmeAnalysisSuccessState) {
                      return TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Tab 1: Timeline View (Table/List)
                          CmeScreen(cmeData: state.cmeData),

                          // Tab 2: Graphs View (CmeAnalysis)
                          CmeAnalysisScreen(analysisData: state.cmeAnalysis),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Delegate for Sticky Header (Aapki file se copy kiya hua) ---
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  _SliverAppBarDelegate({required this.child, required this.height});

  @override double get minExtent => height;
  @override double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}



