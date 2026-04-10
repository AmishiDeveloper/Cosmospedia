// To parse this JSON data, do
//
//     final cmeAnalysisModel = cmeAnalysisModelFromJson(jsonString);

import 'dart:convert';

import 'package:cosmospedia/src/data/model/cme_models/cme_common_models/cme_catalog.dart';

List<CmeAnalysisModel> cmeAnalysisModelFromJson(String str) => List<CmeAnalysisModel>.from(json.decode(str).map((x) => CmeAnalysisModel.fromJson(x)));

String cmeAnalysisModelToJson(List<CmeAnalysisModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CmeAnalysisModel {
  String? time215;
  double? latitude;
  double? longitude;
  double? halfAngle;
  double? speed;
  Type? type;
  bool? isMostAccurate;
  String? associatedCmeid;
  String? associatedCmEstartTime;
  String? note;
  String? associatedCmeLink;
  Catalog? catalog;
  FeatureCode? featureCode;
  String? dataLevel;
  FeatureCode? measurementTechnique;
  FeatureCode? imageType;
  dynamic tilt;
  dynamic minorHalfWidth;
  dynamic speedMeasuredAtHeight;
  String? submissionTime;
  int? versionId;
  String? link;

  CmeAnalysisModel({
    this.time215,
    this.latitude,
    this.longitude,
    this.halfAngle,
    this.speed,
    this.type,
    this.isMostAccurate,
    this.associatedCmeid,
    this.associatedCmEstartTime,
    this.note,
    this.associatedCmeLink,
    this.catalog,
    this.featureCode,
    this.dataLevel,
    this.measurementTechnique,
    this.imageType,
    this.tilt,
    this.minorHalfWidth,
    this.speedMeasuredAtHeight,
    this.submissionTime,
    this.versionId,
    this.link,
  });

  CmeAnalysisModel copyWith({
    String? time215,
    double? latitude,
    double? longitude,
    double? halfAngle,
    double? speed,
    Type? type,
    bool? isMostAccurate,
    String? associatedCmeid,
    String? associatedCmEstartTime,
    String? note,
    String? associatedCmeLink,
    Catalog? catalog,
    FeatureCode? featureCode,
    String? dataLevel,
    FeatureCode? measurementTechnique,
    FeatureCode? imageType,
    dynamic tilt,
    dynamic minorHalfWidth,
    dynamic speedMeasuredAtHeight,
    String? submissionTime,
    int? versionId,
    String? link,
  }) =>
      CmeAnalysisModel(
        time215: time215 ?? this.time215,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        halfAngle: halfAngle ?? this.halfAngle,
        speed: speed ?? this.speed,
        type: type ?? this.type,
        isMostAccurate: isMostAccurate ?? this.isMostAccurate,
        associatedCmeid: associatedCmeid ?? this.associatedCmeid,
        associatedCmEstartTime: associatedCmEstartTime ?? this.associatedCmEstartTime,
        note: note ?? this.note,
        associatedCmeLink: associatedCmeLink ?? this.associatedCmeLink,
        catalog: catalog ?? this.catalog,
        featureCode: featureCode ?? this.featureCode,
        dataLevel: dataLevel ?? this.dataLevel,
        measurementTechnique: measurementTechnique ?? this.measurementTechnique,
        imageType: imageType ?? this.imageType,
        tilt: tilt ?? this.tilt,
        minorHalfWidth: minorHalfWidth ?? this.minorHalfWidth,
        speedMeasuredAtHeight: speedMeasuredAtHeight ?? this.speedMeasuredAtHeight,
        submissionTime: submissionTime ?? this.submissionTime,
        versionId: versionId ?? this.versionId,
        link: link ?? this.link,
      );

  factory CmeAnalysisModel.fromJson(Map<String, dynamic> json) => CmeAnalysisModel(
    time215: json["time21_5"],
    latitude: (json["latitude"]as num?)?.toDouble(),
    longitude: (json["longitude"] as num?)?.toDouble(),
    halfAngle: (json["halfAngle"]as num?)?.toDouble(),
    speed: (json["speed"]as num?)?.toDouble(),

    // Enum handling: isse crash nahi hoga agar koi naya Type aa gaya
    type: (json["type"] != null && typeValues.map.containsKey(json["type"]))
        ? typeValues.map[json["type"]]
        : null,//typeValues.map[json["type"]]!,
    isMostAccurate: json["isMostAccurate"],
    associatedCmeid: json["associatedCMEID"],
    associatedCmEstartTime: json["associatedCMEstartTime"],
    note: json["note"],
    associatedCmeLink: json["associatedCMELink"],
    catalog: catalogValues.map[json["catalog"]]!,
    featureCode: featureCodeValues.map[json["featureCode"]]!,
    dataLevel: json["dataLevel"],
    measurementTechnique: featureCodeValues.map[json["measurementTechnique"]]!,
    imageType: featureCodeValues.map[json["imageType"]]!,
    tilt: json["tilt"],
    minorHalfWidth: json["minorHalfWidth"],
    speedMeasuredAtHeight: json["speedMeasuredAtHeight"],
    submissionTime: json["submissionTime"],
    versionId: json["versionId"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "time21_5": time215,
    "latitude": latitude,
    "longitude": longitude,
    "halfAngle": halfAngle,
    "speed": speed,
    "type": typeValues.reverse[type],
    "isMostAccurate": isMostAccurate,
    "associatedCMEID": associatedCmeid,
    "associatedCMEstartTime": associatedCmEstartTime,
    "note": note,
    "associatedCMELink": associatedCmeLink,
    "catalog": catalogValues.reverse[catalog],
    "featureCode": featureCodeValues.reverse[featureCode],
    "dataLevel": dataLevel,
    "measurementTechnique": featureCodeValues.reverse[measurementTechnique],
    "imageType": featureCodeValues.reverse[imageType],
    "tilt": tilt,
    "minorHalfWidth": minorHalfWidth,
    "speedMeasuredAtHeight": speedMeasuredAtHeight,
    "submissionTime": submissionTime,
    "versionId": versionId,
    "link": link,
  };
}

// enum Catalog {
//   M2_M_CATALOG
// }
//
// final catalogValues = EnumValues({
//   "M2M_CATALOG": Catalog.M2_M_CATALOG
// });

enum FeatureCode {
  NULL
}

final featureCodeValues = EnumValues({
  "null": FeatureCode.NULL
});

enum Type {
  C,
  S,
  O
}

final typeValues = EnumValues({
  "C": Type.C,
  "S": Type.S,
  "O": Type.O
});

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
