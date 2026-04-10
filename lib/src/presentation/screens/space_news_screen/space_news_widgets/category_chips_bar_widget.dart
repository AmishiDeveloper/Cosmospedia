import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/logic/cubits/space_news_cubit/space_news_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryChipsBarWidget extends StatelessWidget {
  const CategoryChipsBarWidget();

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'News', 'Events', 'Missions', 'Launches'];

    return BlocBuilder<SpaceNewsCubit, SpaceNewsState>(
      builder: (context, state) {
        String active = 'All';
        if (state is SpaceNewsSuccessState) active = state.activeCategory;
        if (state is SpaceNewsLoadingState) active = state.loadingCategory;

        return SizedBox(
          height: 70.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = active == cat;

              return Row(
                children: [
                  ChoiceChip(
                    //padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    label: IntrinsicWidth(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 50.w,maxHeight: 28.h),
                            child: Center(
                              child: Text(
                                cat,),
                            ),
                        ),
                    ),//Text(cat), //style: AppTextStyles.descriptionSmallTextStyle(context),
                    labelStyle: AppTextStyles.descriptionSmallTextStyle(context),
                    labelPadding: EdgeInsets.only(left: isSelected ? 0 : 8.w, right: 8.w), //horizontal:5.w
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        context.read<SpaceNewsCubit>().getSpecificCategory(cat);
                      }
                    },
                    selectedColor: AppColors.primaryDark,
                    //disabledColor: AppColors.greyShimmer.withOpacity(0.3),
                    backgroundColor: AppColors.greyShimmerShade600.withOpacity(0.8),
                    checkmarkColor: AppColors.surfaceLight,
                    side: BorderSide(
                      color: isSelected
                        ? AppColors.surfaceLight
                        : Colors.transparent,
                    ),
                  ),

                  SizedBox(width: 15.w,),

                ],
              );
            },
          ),
        );
      },
    );
  }
}