import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final List<Map<String, dynamic>> analysisData = [];
  final Random random = Random();

  // 16 April 2025 se 16 April 2026 tak ka loop
  DateTime startDate = DateTime(2025, 4, 16);
  List<String> types = ['C', 'S', 'O', 'ER'];

  for (int month = 0; month < 12; month++) {
    // Har mahine lagbhag 120-180 analysis reports
    int reportsThisMonth = 120 + random.nextInt(61);

    DateTime currentMonth = DateTime(startDate.year, startDate.month + month, 1);
    int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    for (int i = 0; i < reportsThisMonth; i++) {
      int day = 1 + random.nextInt(daysInMonth);
      DateTime eventTime = DateTime(currentMonth.year, currentMonth.month, day, random.nextInt(24), random.nextInt(60));

      // Analysis API ka exact JSON format
      analysisData.add({
        "time21_5": eventTime.toIso8601String().substring(0, 16) + "Z",
        "latitude": -90 + random.nextInt(181),
        "longitude": -180 + random.nextInt(361),
        "halfAngle": 10 + random.nextInt(80),
        "speed": 200 + random.nextInt(2000),
        "type": types[random.nextInt(types.length)],
        "isMostAccurate": random.nextBool(),
        "associatedCMEID": "2025-${month+1}-$day-CME-001",
        "note": "Mock Analysis: Solar storm impact prediction."
      });
    }
  }

  // Sort by date (Latest first)
  analysisData.sort((a, b) => b['time21_5'].compareTo(a['time21_5']));

  // Save to assets/data/
  final file = File('assets/data/cme_analysis_demo_data.json');
  file.writeAsStringSync(jsonEncode(analysisData));

  print("✅ Success! ${analysisData.length} Analysis records generated.");
}