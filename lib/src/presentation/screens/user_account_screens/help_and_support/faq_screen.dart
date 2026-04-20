import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/user_account_models/faq_model/faq_model.dart';
import 'package:cosmospedia/src/presentation/screens/user_account_screens/help_and_support/faq_shimmer_widget.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen>
    with AutomaticKeepAliveClientMixin {
  final List<FaqCategory> _faqCategories = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  void _loadFaqs() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _faqCategories.addAll(generateFaqCategories());
      _isLoading = false;
    });

    // Create keys for each FAQ item
    for (int catIndex = 0; catIndex < _faqCategories.length; catIndex++) {
      for (
        int itemIndex = 0;
        itemIndex < _faqCategories[catIndex].items.length;
        itemIndex++
      ) {
        _itemKeys['cat${catIndex}_item$itemIndex'] = GlobalKey();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      body: customBackgroundWidget(
        child: SafeArea(child: _buildFaqList(context)),
      ),
    );
  }

  Widget _buildFaqList(BuildContext context) {
    return Column(
      children: [

        Stack(
          children: [
            // 1. Back Button (Left mein fix rahega)
            Positioned(
              left: 8.w,
              top: 8.w,
              bottom: 8.w,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.surfaceLight),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // 2. Title (Screen ke ekdum center mein)
            Center(
              child: CustomAppBar(title: 'Frequently Asked Questions'),
            ),
          ],
        ),

        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.purple.withOpacity(0.3),
                AppColors.info.withOpacity(0.3),
              ],
            ),
            //AppColors.surfaceLight.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
            border: Border.all(color: AppColors.surfaceLight.withOpacity(0.4)),
          ),
          child: Center(
            child: Text(
              'CosmosPedia FAQs',
              style: AppTextStyles.subHeadingLargeStyle(
                context,
              ).copyWith(fontSize: 20.sp),
            ),
          ),
        ),

        SizedBox(height: 20.h),

        Expanded(
          child: _isLoading
              ? FaqShimmerWidget()
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 16.h),
                  key: PageStorageKey('faq_list'),
                  itemCount: _faqCategories.length,
                  itemBuilder: (context, index) {
                    final category = _faqCategories[index];
                    return _buildFaqCategory(category, context, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFaqCategory(
    FaqCategory category,
    BuildContext context,
    int categoryIndex,
  ) {
    // Color mapping based on category - matching the screenshot styles
    Map<String, Color> categoryColorMap = {
      'General Questions': AppColors.info,
      'Features & Navigation': AppColors.success,
      'Account & User Data': AppColors.warning,
      'Troubleshooting': AppColors.yellow,
      'Space Data & Sources': AppColors.teal,
      'Customization & Settings': AppColors.errorDark,
      'Upcoming Features & Roadmap': AppColors.textDeepPurple,
      'Need Additional HXCVBNM,./elp?': AppColors.purpleShade700,
      // Purple like the support icons
    };

    // Default to purple if not found
    Color iconColor =
        categoryColorMap[category.title] ?? AppColors.purpleShade700;

    return RepaintBoundary(
      child: Card(
        key: ValueKey('category_$categoryIndex'),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        elevation: 4.r,
        // Reduced elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        color: Colors.transparent,
        // Transparent base
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.5), // More translucent
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category.icon,
                        size: 30.r,
                        color: AppColors.surfaceLight,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        category.title,
                        style: AppTextStyles.headingMediumStyle(context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Divider(
                    color: AppColors.greyShimmerShade400,
                    height: 1.h,
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: category.items.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.greyShimmerShade400,
                    height: 1.h,
                  ),
                  itemBuilder: (context, itemIndex) {
                    final item = category.items[itemIndex];
                    return _buildFaqItem(
                      item,
                      context,
                      iconColor,
                      categoryIndex,
                      itemIndex,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleFaqItem(FaqItem item, int categoryIndex, int itemIndex) {
    setState(() {
      // Close all other open items first
      for (var cat in _faqCategories) {
        for (var faq in cat.items) {
          if (faq != item && faq.isExpanded) {
            faq.isExpanded = false;
          }
        }
      }

      // Toggle the current item
      item.isExpanded = !item.isExpanded;
    });

    // Only attempt to scroll if we're opening the item
    if (item.isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _itemKeys['cat${categoryIndex}_item$itemIndex'];
        if (key?.currentContext != null && _scrollController.hasClients) {
          final renderBox =
              key?.currentContext!.findRenderObject() as RenderBox;
          final viewport = RenderAbstractViewport.of(renderBox);
          final position = viewport.getOffsetToReveal(renderBox, 0.5).offset;

          _scrollController.animateTo(
            position,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  Widget _buildFaqItem(
    FaqItem item,
    BuildContext context,
    Color categoryColor,
    int categoryIndex,
    int itemIndex,
  ) {
    final key = _itemKeys['cat${categoryIndex}_item$itemIndex'];

    return RepaintBoundary(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              item.question,
              style: AppTextStyles.descriptionMediumTextStyle(context),
            ),
            trailing: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: categoryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.surfaceLight,
                size: 20.r,
              ),
            ),
            onTap: () => _toggleFaqItem(item, categoryIndex, itemIndex),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: item.isExpanded
                ? Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.2),
                        //AppColors.surfaceLight.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: categoryColor.withOpacity(0.3),
                          width: 1.w,
                        ),
                      ),
                      child: Text(
                        item.answer,
                        style: AppTextStyles.descriptionSmallTextStyle(context)
                            .copyWith(
                              color: AppColors
                                  .greyShimmerShade400, //AppColors.surfaceLight.withOpacity(0.9),
                            ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
