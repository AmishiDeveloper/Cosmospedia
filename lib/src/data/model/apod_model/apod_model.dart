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

import 'dart:convert';//JSON data (jo string format mein hota hai) ko Dart ke samajhne layak (Map/List) banane ke liye is library ki zarurat padti hai.

List<ApodModel> apodModelFromJson(String str) => List<ApodModel>.from(json.decode(str).map((x) => ApodModel.fromJson(x)));//Ye ek "Converter" function hai. Jab NASA se poori list aayegi string format mein, toh ye use decode karke ApodModel ke dhabbon (Objects) ki ek list bana dega.

String apodModelToJson(List<ApodModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApodModel {
  DateTime? date; //NASA se date text mein aati hai, humne use DateTime banaya taaki hum calendar ke saath khel sakein. ? ka matlab: Ho sakta hai NASA kabhi ye data bhejna bhool jaye, toh app crash nahi hogi (Null Safety).
  String? explanation;
  String? hdurl;
  String? mediaType;
  String? serviceVersion;
  String? title;
  String? url;
  String? copyright;

  ApodModel({
    this.date,
    this.explanation,
    this.hdurl,
    this.mediaType,
    this.serviceVersion,
    this.title,
    this.url,
    this.copyright,
  });

  //Maan lo aapko ek purana model badalna hai, lekin sirf uski title change karni hai baaki sab same rahe.
  // Logic: date ?? this.date ka matlab hai: "Agar nayi date di hai toh woh lo, warna purani hi rehne do." Ye state management (Cubit) mein bahut kaam aata hai.
  ApodModel copyWith({
    DateTime? date,
    String? explanation,
    String? hdurl,
    String? mediaType,
    String? serviceVersion,
    String? title,
    String? url,
    String? copyright,
  }) =>
      ApodModel(
        date: date ?? this.date,
        explanation: explanation ?? this.explanation,
        hdurl: hdurl ?? this.hdurl,
        mediaType: mediaType ?? this.mediaType,
        serviceVersion: serviceVersion ?? this.serviceVersion,
        title: title ?? this.title,
        url: url ?? this.url,
        copyright: copyright ?? this.copyright,
      );

  //Kaam: Ye sabse zaruri part hai! NASA se jo data aata hai wo Map<String, dynamic> hota hai (jaise: {"title": "Galaxy"}).
  // Translation: Ye line-by-line check karta hai: "Achha, NASA ke 'explanation' wale dabbe mein kya hai? Use uthake mere Dart wale explanation mein daal do."
  // Special Logic: DateTime.parse(json["date"]) NASA ki string date (2026-02-19) ko Dart ki asli DateTime mein badal raha hai.
  factory ApodModel.fromJson(Map<String, dynamic> json) => ApodModel(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    explanation: json["explanation"],
    hdurl: json["hdurl"],
    mediaType: json["media_type"],
    serviceVersion: json["service_version"],
    title: json["title"],
    url: json["url"],
    copyright: json["copyright"],
  );

  //Kaam: Agar humein apni app se NASA ko ya kisi database ko wapas data bhejna ho, toh hum use wapas JSON (Map) format mein badalte hain. Ye fromJson ka bilkul ulta kaam karta hai.
  Map<String, dynamic> toJson() => {
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "explanation": explanation,
    "hdurl": hdurl,
    "media_type": mediaType,
    "service_version": serviceVersion,
    "title": title,
    "url": url,
    "copyright": copyright,
  };
}
