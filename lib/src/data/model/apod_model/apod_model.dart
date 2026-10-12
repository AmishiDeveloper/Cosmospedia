/*
model is a template of api response that tells what kind of data will come from the api

Model is used to :-

JSON to Dart Object: ise hum "Parsing" ya "Deserialization" kehte hain.

Type Safety & Intellisense: Sahi spelling aur datatype ki wajah se app "Run-time" par crash nahi hoti balki "Compile-time" par hi error dikha deti hai.

Data Transformation: Example String date ko DateTime banana model ki hi responsibility hai.

Reusability: Model ek "Data Carrier" ban jata hai jo ek screen se doosri screen tak data lekar jata hai.

Model raw data (JSON) ko ek "Sahi Shakal" deta hai taaki Flutter use aasani se aur bina crash huye screen par dikha sake.

Is file ka simple kaam ye hai: NASA ke JSON  (raw data) ko ek saaf-suthre Dart Object mein badalna taaki aap apni UI mein item.title likhein aur aapko suggestions mil jayein.


*/

// To parse this JSON data, do
//
//     final apodModel = apodModelFromJson(jsonString);

// import 'dart:convert';//JSON data (jo string format mein hota hai) ko Dart ke samajhne layak (Map/List) banane ke liye is library ki zarurat padti hai.
//
// List<ApodModel> apodModelFromJson(String str) => List<ApodModel>.from(json.decode(str).map((x) => ApodModel.fromJson(x)));//Ye ek "Converter" function hai. Jab NASA se poori list aayegi string format mein, toh ye use decode karke ApodModel ke dhabbon (Objects) ki ek list bana dega.
//
// String apodModelToJson(List<ApodModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class ApodModel {
//   DateTime? date; //NASA se date text mein aati hai, humne use DateTime banaya taaki hum calendar ke saath khel sakein. ? ka matlab: Ho sakta hai NASA kabhi ye data bhejna bhool jaye, toh app crash nahi hogi (Null Safety).
//   String? explanation;
//   String? hdurl;
//   String? mediaType;
//   String? serviceVersion;
//   String? title;
//   String? url;
//   String? copyright;
//
//   ApodModel({
//     this.date,
//     this.explanation,
//     this.hdurl,
//     this.mediaType,
//     this.serviceVersion,
//     this.title,
//     this.url,
//     this.copyright,
//   });
//
//   //Maan lo aapko ek purana model badalna hai, lekin sirf uski title change karni hai baaki sab same rahe.
//   // Logic: date ?? this.date ka matlab hai: "Agar nayi date di hai toh woh lo, warna purani hi rehne do." Ye state management (Cubit) mein bahut kaam aata hai.
//   ApodModel copyWith({
//     DateTime? date,
//     String? explanation,
//     String? hdurl,
//     String? mediaType,
//     String? serviceVersion,
//     String? title,
//     String? url,
//     String? copyright,
//   }) =>
//       ApodModel(
//         date: date ?? this.date,
//         explanation: explanation ?? this.explanation,
//         hdurl: hdurl ?? this.hdurl,
//         mediaType: mediaType ?? this.mediaType,
//         serviceVersion: serviceVersion ?? this.serviceVersion,
//         title: title ?? this.title,
//         url: url ?? this.url,
//         copyright: copyright ?? this.copyright,
//       );
//
//   //Kaam: Ye sabse zaruri part hai! NASA se jo data aata hai wo Map<String, dynamic> hota hai (jaise: {"title": "Galaxy"}).
//   // Translation: Ye line-by-line check karta hai: "Achha, NASA ke 'explanation' wale dabbe mein kya hai? Use uthake mere Dart wale explanation mein daal do."
//   // Special Logic: DateTime.parse(json["date"]) NASA ki string date (2026-02-19) ko Dart ki asli DateTime mein badal raha hai.
//   factory ApodModel.fromJson(Map<String, dynamic> json) => ApodModel(
//     date: json["date"] == null ? null : DateTime.tryParse(json["date"]),
//     explanation: json["explanation"],
//     hdurl: json["hdurl"],
//     mediaType: json["media_type"],
//     serviceVersion: json["service_version"],
//     title: json["title"],
//     url: json["url"],
//     copyright: json["copyright"],
//   );
//
//   //Kaam: Agar humein apni app se NASA ko ya kisi database ko wapas data bhejna ho, toh hum use wapas JSON (Map) format mein badalte hain. Ye fromJson ka bilkul ulta kaam karta hai.
//   Map<String, dynamic> toJson() => {
//     "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//     "explanation": explanation,
//     "hdurl": hdurl,
//     "media_type": mediaType,
//     "service_version": serviceVersion,
//     "title": title,
//     "url": url,
//     "copyright": copyright,
//   };
// }

import 'dart:convert';

// List parsing helper function
List<ApodModel> apodModelListFromJson(String str) =>
    List<ApodModel>.from(json.decode(str).map((x) => ApodModel.fromJson(x)));

// List to JSON string helper function
String apodModelListToJson(List<ApodModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApodModel {
  final DateTime? date;
  final int? postId;
  final String? title;
  final String? permalink;
  final String? mediaType;
  final String? explanation;
  final String? credit;
  final String? copyright;
  final String? alt;
  final String? url; // Article page URL
  final String? hdurl; // Actual Image (.jpg) URL
  final String? basicHtml;
  final String? basicHtmlUrl;
  final String? serviceVersion;

  const ApodModel({
    this.date,
    this.postId,
    this.title,
    this.permalink,
    this.mediaType,
    this.explanation,
    this.credit,
    this.copyright,
    this.alt,
    this.url,
    this.hdurl,
    this.basicHtml,
    this.basicHtmlUrl,
    this.serviceVersion,
  });

  /// Helper: UI mein image render karne ke liye isko use karein
  String get displayImageUrl =>
      (hdurl != null && hdurl!.isNotEmpty) ? hdurl! : (url ?? '');

  String get cleanExplanation {
    if (explanation == null || explanation!.isEmpty) {
      return 'Discovery details not available.';
    }
    return explanation!
        // 1. Starting Explanation: label hatao
        .replaceFirst(
          RegExp(
            r'^\s*(<strong>\s*)?Explanation:\s*(<\/strong>)?\s*',
            caseSensitive: false,
          ),
          '',
        )
        // 2. Saare HTML tags (<...>) hatao
        .replaceAll(RegExp(r'<[^>]*>'), '')
        // 3. Special characters clean karo
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&')
        .trim();
  }

  ApodModel copyWith({
    DateTime? date,
    int? postId,
    String? title,
    String? permalink,
    String? mediaType,
    String? explanation,
    String? credit,
    String? copyright,
    String? alt,
    String? url,
    String? hdurl,
    String? basicHtml,
    String? basicHtmlUrl,
    String? serviceVersion,
  }) => ApodModel(
    date: date ?? this.date,
    postId: postId ?? this.postId,
    title: title ?? this.title,
    permalink: permalink ?? this.permalink,
    mediaType: mediaType ?? this.mediaType,
    explanation: explanation ?? this.explanation,
    credit: credit ?? this.credit,
    copyright: copyright ?? this.copyright,
    alt: alt ?? this.alt,
    url: url ?? this.url,
    hdurl: hdurl ?? this.hdurl,
    basicHtml: basicHtml ?? this.basicHtml,
    basicHtmlUrl: basicHtmlUrl ?? this.basicHtmlUrl,
    serviceVersion: serviceVersion ?? this.serviceVersion,
  );

  factory ApodModel.fromJson(Map<String, dynamic> json) => ApodModel(
    date: json["date"] == null
        ? null
        : DateTime.tryParse(json["date"].toString()),
    postId: json["post_id"] as int? ?? json["id"] as int?,
    title: json["title"] as String?,
    permalink: json["permalink"] as String?,
    mediaType: json["media_type"] as String? ?? 'image',
    explanation: json["explanation"] as String?,
    credit: json["credit"] as String?,
    copyright: json["copyright"] as String?,
    alt: json["alt"] as String?,
    url: json["url"] as String?,
    hdurl: json["hdurl"] as String?,
    basicHtml: json["basic_html"] as String?,
    basicHtmlUrl: json["basic_html_url"] as String?,
    serviceVersion: json["service_version"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "date": date == null
        ? null
        : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "post_id": postId,
    "title": title,
    "permalink": permalink,
    "media_type": mediaType,
    "explanation": explanation,
    "credit": credit,
    "copyright": copyright,
    "alt": alt,
    "url": url,
    "hdurl": hdurl,
    "basic_html": basicHtml,
    "basic_html_url": basicHtmlUrl,
    if (serviceVersion != null) "service_version": serviceVersion,
  };
}
