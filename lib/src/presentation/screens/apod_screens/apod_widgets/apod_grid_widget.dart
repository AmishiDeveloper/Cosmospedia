import 'package:cosmospedia/src/core/app_themes/app_colors.dart';
import 'package:cosmospedia/src/core/app_themes/text_styles.dart';
import 'package:cosmospedia/src/core/routes/app_route.dart';
import 'package:cosmospedia/src/data/model/apod_model/apod_model.dart';
import 'package:cosmospedia/src/logic/cubits/apod_cubit/apod_cubit.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_detail_screen.dart';
import 'package:cosmospedia/src/presentation/screens/apod_screens/apod_widgets/apod_image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ApodGridWidget extends StatelessWidget {
  final List<ApodModel> items;

  const ApodGridWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        GridView.builder(
          shrinkWrap: true,
          // ScrollView ke andar use karne ke liye
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.85, // Adjust height/width ratio
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  AppRoute.scale(
                    ApodDetailScreen(item: item, heroTag: item.date.toString()),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  border: Border.all(color: AppColors.surfaceLight),
                  // color: AppColors.cardDark,
                  // image: DecorationImage(
                  //   image: NetworkImage(item.url ?? ''),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  // Stack use kar rahe hain taaki image aur text sahi se layer ho sakein
                  fit: StackFit.expand,
                  children: [
                    // 1. Hero Widget with Image
                    Hero(
                      tag: item.date.toString(),
                      // UNIQUE TAG (Matches FeatureCard & DetailScreen)
                      child: Image.network(
                        item.url ?? '',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          //return const Center(child: CircularProgressIndicator());
                          return buildImagePlaceholder();
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          size: 50.h,
                          color: AppColors.surfaceLight,
                        ),
                      ),
                    ),

                    // 2. Gradient Overlay for Text Readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),

                    // 3. Title Text
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          item.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTextStyles.descriptionLargeTextStyle(
                                context,
                              ).copyWith(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15.r),
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [Colors.transparent, AppColors.black.withOpacity(0.8)],
                //     ),
                //   ),
                //   padding: EdgeInsets.all(8.w),
                //   alignment: Alignment.bottomLeft,
                //   child: Text(
                //     item.title ?? '',
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //     style: AppTextStyles.descriptionLargeTextStyle(context).copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold),
                //   ),
                // ),
              ),
            );
          },
        ),

        // 3. Naya Data load hote waqt niche spinner dikhao
        BlocBuilder<ApodCubit, ApodState>(
          builder: (context, state) {
            if (state is ApodSuccessState && state.isLoadMoreImages) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryDark),
                    SizedBox(height: 10.h),
                    Text('Fetching the apod data',style: AppTextStyles.descriptionSmallTextStyle(context)),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
