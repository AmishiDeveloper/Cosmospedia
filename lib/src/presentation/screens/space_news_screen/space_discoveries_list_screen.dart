import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';
import 'package:cosmospedia/src/presentation/screens/space_news_screen/space_news_widgets/space_content_card.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_appbar.dart';
import 'package:cosmospedia/src/presentation/widgets/custom_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpaceDiscoveriesListScreen extends StatelessWidget {
  final String title;
  final List<SpaceContent> items;

  const SpaceDiscoveriesListScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: customBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              // CustomAppBar with back button
              // _buildSimpleHeader(context, title),

              CustomAppBar(title: title),

              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return SpaceContentCard(content: items[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          Text(title, style: AppTextStyles.headingSmallStyle(context)),
        ],
      ),
    );
  }
}
