// abstract class SpaceContent {
//   String get id;
//   String get title;
//   String get imageUrl;
//   DateTime get date; // Sabke liye common name 'date'
//   String get type;   // 'news', 'blog', 'event' or 'launch'
// }

import 'package:intl/intl.dart';

/// [SpaceContent] ek base interface hai jo different APIs
/// (SNAPI aur LL2) ke data ko ek common format mein laata hai.
abstract class SpaceContent {

  // 1. Unique ID
  String get idValue;

  // 2. Title (News Headline ya Rocket Name)
  String get titleValue;

  // 3. Image URL
  String get imageUrlValue;

  // 4. News Site / Agency (e.g., NASA ya SpaceX)
  String get newsSiteValue;

  // 5. Summary (Mission Description ya News Summary)
  String get summaryValue;

  // 6. Published At / Launch Date (Sorting ke liye main field)
  DateTime get publishedAtDate;

  // 7. Updated At (Data kab last refresh hua)
  DateTime get updatedAtDate;

  // Extra: Type identify karne ke liye (news, mission, event, launch)
  String get typeValue;

  /// Helper: Date ko sundar format mein dikhane ke liye
  /// Example: "Apr 4, 2026"
  String get formattedDate => DateFormat.yMMMd().format(publishedAtDate);
}