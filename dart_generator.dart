import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final List<Map<String, dynamic>> finalData = [];
  final Random random = Random();

  // 16 April 2025 se 16 April 2026 tak ka loop
  DateTime startDate = DateTime(2025, 4, 16);
  DateTime endDate = DateTime(2026, 4, 16);

  List<String> types = ['C', 'S', 'O', 'ER'];
  List<String> instruments = ['SOHO: LASCO/C2', 'SOHO: LASCO/C3', 'STEREO A: COR2'];

  for (int month = 0; month < 12; month++) {
    // Har mahine ke liye random target (120 se 200 ke beech)
    int eventsInThisMonth = 120 + random.nextInt(81);

    DateTime currentMonth = DateTime(startDate.year, startDate.month + month, 1);
    int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    for (int i = 0; i < eventsInThisMonth; i++) {
      // Random day aur random time
      int day = 1 + random.nextInt(daysInMonth);
      int hour = random.nextInt(24);
      int minute = random.nextInt(60);

      DateTime eventTime = DateTime(currentMonth.year, currentMonth.month, day, hour, minute);

      // Data structure NASA format mein
      finalData.add({
        "activityID": "${eventTime.toIso8601String()}-CME-${random.nextInt(100)}",
        "catalog": "M2M_CATALOG",
        "startTime": eventTime.toIso8601String().replaceAll('T', ' ').substring(0, 16) + "Z",
        "sourceLocation": "${random.nextBool() ? 'N' : 'S'}${random.nextInt(40)}${random.nextBool() ? 'E' : 'W'}${random.nextInt(90)}",
        "activeRegionNum": 13000 + random.nextInt(1000),
        "note": "Historical Mock Data: Simulated solar event.",
        "instruments": [{"displayName": instruments[random.nextInt(instruments.length)]}],
        "cmeAnalyses": [
          {
            "isMostAccurate": true,
            "speed": 300 + random.nextInt(1500),
            "type": types[random.nextInt(types.length)],
            "halfAngle": 15 + random.nextInt(70)
          }
        ]
      });
    }
  }

  // Data ko date wise sort karo taaki sequence natural lage
  finalData.sort((a, b) => b['startTime'].compareTo(a['startTime']));

  // File save karo
  final file = File('cme_demo_data.json');
  file.writeAsStringSync(jsonEncode(finalData));

  print("✅ Success! 1000+ records generate ho gaye hain 'cme_demo_data.json' mein.");
  print("Total Records: ${finalData.length}");
}