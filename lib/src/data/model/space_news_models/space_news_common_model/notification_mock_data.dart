// Ye class SpaceContent interface ko implement kar rahi h
import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/space_news_common_interface.dart';

class NotificationMockData implements SpaceContent {
  @override final String idValue;
  @override final String titleValue;
  @override final String summaryValue;
  @override final String imageUrlValue;
  @override final String typeValue;
  @override final String newsSiteValue;
  @override final String formattedDate;

  NotificationMockData({
    required String id,
    required String title,
    required String summary,
    required String imageUrl,
    required String type,
    required String newsSite,
    required String date,
  })  : idValue = id,
        titleValue = title,
        summaryValue = summary,
        imageUrlValue = imageUrl,
        typeValue = type,
        newsSiteValue = newsSite,
        formattedDate = date;

  @override
  DateTime get publishedAtDate => DateTime.now();

  @override
  // TODO: implement updatedAtDate
  DateTime get updatedAtDate =>  DateTime.now();
}