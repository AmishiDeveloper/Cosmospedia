// To parse this JSON data, do
//
//     final cmeModel = cmeModelFromJson(jsonString);

import 'dart:convert';

import 'package:cosmospedia/src/data/model/cme_models/cme_common_models/cme_common_model.dart';

List<CmeModel> cmeModelFromJson(String str) => List<CmeModel>.from(json.decode(str).map((x) => CmeModel.fromJson(x)));

String cmeModelToJson(List<CmeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CmeModel {
  String? activityId;
  Catalog? catalog;
  String? startTime;
  List<Instrument>? instruments;
  String? sourceLocation;
  int? activeRegionNum;
  String? note;
  String? submissionTime;
  int? versionId;
  String? link;
  List<CmeAnalysis>? cmeAnalyses;
  List<LinkedEvent>? linkedEvents;
  List<SentNotification>? sentNotifications;

  CmeModel({
    this.activityId,
    this.catalog,
    this.startTime,
    this.instruments,
    this.sourceLocation,
    this.activeRegionNum,
    this.note,
    this.submissionTime,
    this.versionId,
    this.link,
    this.cmeAnalyses,
    this.linkedEvents,
    this.sentNotifications,
  });

  CmeModel copyWith({
    String? activityId,
    Catalog? catalog,
    String? startTime,
    List<Instrument>? instruments,
    String? sourceLocation,
    int? activeRegionNum,
    String? note,
    String? submissionTime,
    int? versionId,
    String? link,
    List<CmeAnalysis>? cmeAnalyses,
    List<LinkedEvent>? linkedEvents,
    List<SentNotification>? sentNotifications,
  }) =>
      CmeModel(
        activityId: activityId ?? this.activityId,
        catalog: catalog ?? this.catalog,
        startTime: startTime ?? this.startTime,
        instruments: instruments ?? this.instruments,
        sourceLocation: sourceLocation ?? this.sourceLocation,
        activeRegionNum: activeRegionNum ?? this.activeRegionNum,
        note: note ?? this.note,
        submissionTime: submissionTime ?? this.submissionTime,
        versionId: versionId ?? this.versionId,
        link: link ?? this.link,
        cmeAnalyses: cmeAnalyses ?? this.cmeAnalyses,
        linkedEvents: linkedEvents ?? this.linkedEvents,
        sentNotifications: sentNotifications ?? this.sentNotifications,
      );

  factory CmeModel.fromJson(Map<String, dynamic> json) => CmeModel(
    activityId: json["activityID"],
    catalog: catalogValues.map[json["catalog"]]!,
    startTime: json["startTime"],
    instruments: json["instruments"] == null ? [] : List<Instrument>.from(json["instruments"]!.map((x) => Instrument.fromJson(x))),
    sourceLocation: json["sourceLocation"],
    activeRegionNum: json["activeRegionNum"],
    note: json["note"],
    submissionTime: json["submissionTime"],
    versionId: json["versionId"],
    link: json["link"],
    cmeAnalyses: json["cmeAnalyses"] == null ? [] : List<CmeAnalysis>.from(json["cmeAnalyses"]!.map((x) => CmeAnalysis.fromJson(x))),
    linkedEvents: json["linkedEvents"] == null ? [] : List<LinkedEvent>.from(json["linkedEvents"]!.map((x) => LinkedEvent.fromJson(x))),
    sentNotifications: json["sentNotifications"] == null ? [] : List<SentNotification>.from(json["sentNotifications"]!.map((x) => SentNotification.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "activityID": activityId,
    "catalog": catalogValues.reverse[catalog],
    "startTime": startTime,
    "instruments": instruments == null ? [] : List<dynamic>.from(instruments!.map((x) => x.toJson())),
    "sourceLocation": sourceLocation,
    "activeRegionNum": activeRegionNum,
    "note": note,
    "submissionTime": submissionTime,
    "versionId": versionId,
    "link": link,
    "cmeAnalyses": cmeAnalyses == null ? [] : List<dynamic>.from(cmeAnalyses!.map((x) => x.toJson())),
    "linkedEvents": linkedEvents == null ? [] : List<dynamic>.from(linkedEvents!.map((x) => x.toJson())),
    "sentNotifications": sentNotifications == null ? [] : List<dynamic>.from(sentNotifications!.map((x) => x.toJson())),
  };
}

// enum Catalog {
//   M2_M_CATALOG
// }
//
// final catalogValues = EnumValues({
//   "M2M_CATALOG": Catalog.M2_M_CATALOG
// });

class CmeAnalysis {
  bool? isMostAccurate;
  String? time215;
  double? latitude;
  double? longitude;
  double? halfAngle;
  double? speed;
  Type? type;
  FeatureCode? featureCode;
  ImageType? imageType;
  MeasurementTechnique? measurementTechnique;
  String? note;
  int? levelOfData;
  dynamic tilt;
  dynamic minorHalfWidth;
  double? speedMeasuredAtHeight;
  String? submissionTime;
  String? link;
  List<EnlilList>? enlilList;

  CmeAnalysis({
    this.isMostAccurate,
    this.time215,
    this.latitude,
    this.longitude,
    this.halfAngle,
    this.speed,
    this.type,
    this.featureCode,
    this.imageType,
    this.measurementTechnique,
    this.note,
    this.levelOfData,
    this.tilt,
    this.minorHalfWidth,
    this.speedMeasuredAtHeight,
    this.submissionTime,
    this.link,
    this.enlilList,
  });

  CmeAnalysis copyWith({
    bool? isMostAccurate,
    String? time215,
    double? latitude,
    double? longitude,
    double? halfAngle,
    double? speed,
    Type? type,
    FeatureCode? featureCode,
    ImageType? imageType,
    MeasurementTechnique? measurementTechnique,
    String? note,
    int? levelOfData,
    dynamic tilt,
    dynamic minorHalfWidth,
    double? speedMeasuredAtHeight,
    String? submissionTime,
    String? link,
    List<EnlilList>? enlilList,
  }) =>
      CmeAnalysis(
        isMostAccurate: isMostAccurate ?? this.isMostAccurate,
        time215: time215 ?? this.time215,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        halfAngle: halfAngle ?? this.halfAngle,
        speed: speed ?? this.speed,
        type: type ?? this.type,
        featureCode: featureCode ?? this.featureCode,
        imageType: imageType ?? this.imageType,
        measurementTechnique: measurementTechnique ?? this.measurementTechnique,
        note: note ?? this.note,
        levelOfData: levelOfData ?? this.levelOfData,
        tilt: tilt ?? this.tilt,
        minorHalfWidth: minorHalfWidth ?? this.minorHalfWidth,
        speedMeasuredAtHeight: speedMeasuredAtHeight ?? this.speedMeasuredAtHeight,
        submissionTime: submissionTime ?? this.submissionTime,
        link: link ?? this.link,
        enlilList: enlilList ?? this.enlilList,
      );

  factory CmeAnalysis.fromJson(Map<String, dynamic> json) => CmeAnalysis(
    isMostAccurate: json["isMostAccurate"],
    time215: json["time21_5"],
    latitude: (json["latitude"]as num?)?.toDouble(),
    longitude:  (json["longitude"] as num?)?.toDouble(),
    halfAngle: (json["halfAngle"]as num?)?.toDouble(),
    speed: (json["speed"]as num?)?.toDouble(),
    type: (json["type"] != null && typeValues.map.containsKey(json["type"]))
        ? typeValues.map[json["type"]]
        : null,//typeValues.map[json["type"]]!,
    featureCode: (json["featureCode"] != null && featureCodeValues.map.containsKey(json["featureCode"]))
        ? featureCodeValues.map[json["featureCode"]]
        : null,//featureCodeValues.map[json["featureCode"]]!,
    imageType:  (json["imageType"] != null && imageTypeValues.map.containsKey(json["imageType"]))
        ? imageTypeValues.map[json["imageType"]]
        : null,//imageTypeValues.map[json["imageType"]]!,
    measurementTechnique: (json["measurementTechnique"] != null && measurementTechniqueValues.map.containsKey(json["measurementTechnique"]))
        ? measurementTechniqueValues.map[json["measurementTechnique"]]
        : null,//measurementTechniqueValues.map[json["measurementTechnique"]]!,
    note: json["note"],
    levelOfData: json["levelOfData"],
    tilt: json["tilt"],
    minorHalfWidth: json["minorHalfWidth"],
    speedMeasuredAtHeight: json["speedMeasuredAtHeight"]?.toDouble(),
    submissionTime: json["submissionTime"],
    link: json["link"],
    enlilList: json["enlilList"] == null ? [] : List<EnlilList>.from(json["enlilList"]!.map((x) => EnlilList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isMostAccurate": isMostAccurate,
    "time21_5": time215,
    "latitude": latitude,
    "longitude": longitude,
    "halfAngle": halfAngle,
    "speed": speed,
    "type": typeValues.reverse[type],
    "featureCode": featureCodeValues.reverse[featureCode],
    "imageType": imageTypeValues.reverse[imageType],
    "measurementTechnique": measurementTechniqueValues.reverse[measurementTechnique],
    "note": note,
    "levelOfData": levelOfData,
    "tilt": tilt,
    "minorHalfWidth": minorHalfWidth,
    "speedMeasuredAtHeight": speedMeasuredAtHeight,
    "submissionTime": submissionTime,
    "link": link,
    "enlilList": enlilList == null ? [] : List<dynamic>.from(enlilList!.map((x) => x.toJson())),
  };
}

class EnlilList {
  String? modelCompletionTime;
  double? au;
  String? estimatedShockArrivalTime;
  double? estimatedDuration;
  double? rminRe;
  dynamic kp18;
  int? kp90;
  int? kp135;
  int? kp180;
  bool? isEarthGb;
  bool? isEarthMinorImpact;
  String? link;
  List<ImpactList>? impactList;
  List<String>? cmeIDs;

  EnlilList({
    this.modelCompletionTime,
    this.au,
    this.estimatedShockArrivalTime,
    this.estimatedDuration,
    this.rminRe,
    this.kp18,
    this.kp90,
    this.kp135,
    this.kp180,
    this.isEarthGb,
    this.isEarthMinorImpact,
    this.link,
    this.impactList,
    this.cmeIDs,
  });

  EnlilList copyWith({
    String? modelCompletionTime,
    double? au,
    String? estimatedShockArrivalTime,
    double? estimatedDuration,
    double? rminRe,
    dynamic kp18,
    int? kp90,
    int? kp135,
    int? kp180,
    bool? isEarthGb,
    bool? isEarthMinorImpact,
    String? link,
    List<ImpactList>? impactList,
    List<String>? cmeIDs,
  }) =>
      EnlilList(
        modelCompletionTime: modelCompletionTime ?? this.modelCompletionTime,
        au: au ?? this.au,
        estimatedShockArrivalTime: estimatedShockArrivalTime ?? this.estimatedShockArrivalTime,
        estimatedDuration: estimatedDuration ?? this.estimatedDuration,
        rminRe: rminRe ?? this.rminRe,
        kp18: kp18 ?? this.kp18,
        kp90: kp90 ?? this.kp90,
        kp135: kp135 ?? this.kp135,
        kp180: kp180 ?? this.kp180,
        isEarthGb: isEarthGb ?? this.isEarthGb,
        isEarthMinorImpact: isEarthMinorImpact ?? this.isEarthMinorImpact,
        link: link ?? this.link,
        impactList: impactList ?? this.impactList,
        cmeIDs: cmeIDs ?? this.cmeIDs,
      );

  factory EnlilList.fromJson(Map<String, dynamic> json) => EnlilList(
    modelCompletionTime: json["modelCompletionTime"],
    au: json["au"]?.toDouble(),
    estimatedShockArrivalTime: json["estimatedShockArrivalTime"],
    estimatedDuration: json["estimatedDuration"]?.toDouble(),
    rminRe: json["rmin_re"]?.toDouble(),
    kp18: json["kp_18"],
    kp90: json["kp_90"],
    kp135: json["kp_135"],
    kp180: json["kp_180"],
    isEarthGb: json["isEarthGB"],
    isEarthMinorImpact: json["isEarthMinorImpact"],
    link: json["link"],
    impactList: json["impactList"] == null ? [] : List<ImpactList>.from(json["impactList"]!.map((x) => ImpactList.fromJson(x))),
    cmeIDs: json["cmeIDs"] == null ? [] : List<String>.from(json["cmeIDs"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "modelCompletionTime": modelCompletionTime,
    "au": au,
    "estimatedShockArrivalTime": estimatedShockArrivalTime,
    "estimatedDuration": estimatedDuration,
    "rmin_re": rminRe,
    "kp_18": kp18,
    "kp_90": kp90,
    "kp_135": kp135,
    "kp_180": kp180,
    "isEarthGB": isEarthGb,
    "isEarthMinorImpact": isEarthMinorImpact,
    "link": link,
    "impactList": impactList == null ? [] : List<dynamic>.from(impactList!.map((x) => x.toJson())),
    "cmeIDs": cmeIDs == null ? [] : List<dynamic>.from(cmeIDs!.map((x) => x)),
  };
}

class ImpactList {
  bool? isGlancingBlow;
  bool? isMinorImpact;
  Location? location;
  String? arrivalTime;

  ImpactList({
    this.isGlancingBlow,
    this.isMinorImpact,
    this.location,
    this.arrivalTime,
  });

  ImpactList copyWith({
    bool? isGlancingBlow,
    bool? isMinorImpact,
    Location? location,
    String? arrivalTime,
  }) =>
      ImpactList(
        isGlancingBlow: isGlancingBlow ?? this.isGlancingBlow,
        isMinorImpact: isMinorImpact ?? this.isMinorImpact,
        location: location ?? this.location,
        arrivalTime: arrivalTime ?? this.arrivalTime,
      );

  factory ImpactList.fromJson(Map<String, dynamic> json) => ImpactList(
    isGlancingBlow: json["isGlancingBlow"],
    isMinorImpact: json["isMinorImpact"],
    location: (json["location"] != null && locationValues.map.containsKey(json["location"]))
        ? locationValues.map[json["location"]]
        : null,//locationValues.map[json["location"]]!,
    arrivalTime: json["arrivalTime"],
  );

  Map<String, dynamic> toJson() => {
    "isGlancingBlow": isGlancingBlow,
    "isMinorImpact": isMinorImpact,
    "location": locationValues.reverse[location],
    "arrivalTime": arrivalTime,
  };
}

enum Location {
  BEPI_COLOMBO,
  EUROPA_CLIPPER,
  JUICE,
  JUNO,
  LUCY,
  MARS,
  OSIRIS_APEX,
  PARKER_SOLAR_PROBE,
  PSYCHE,
  SOLAR_ORBITER,
  STEREO_A
}

final locationValues = EnumValues({
  "BepiColombo": Location.BEPI_COLOMBO,
  "Europa Clipper": Location.EUROPA_CLIPPER,
  "Juice": Location.JUICE,
  "Juno": Location.JUNO,
  "Lucy": Location.LUCY,
  "Mars": Location.MARS,
  "OSIRIS-APEX": Location.OSIRIS_APEX,
  "Parker Solar Probe": Location.PARKER_SOLAR_PROBE,
  "Psyche": Location.PSYCHE,
  "Solar Orbiter": Location.SOLAR_ORBITER,
  "STEREO A": Location.STEREO_A
});

// enum FeatureCode {
//   LE,
//   SH
// }

// final featureCodeValues = EnumValues({
//   "LE": FeatureCode.LE,
//   "SH": FeatureCode.SH
// });

// enum ImageType {
//   RUNNING_DIFFERENCE
// }
//
// final imageTypeValues = EnumValues({
//   "running difference": ImageType.RUNNING_DIFFERENCE
// });

// enum MeasurementTechnique {
//   PLANE_OF_SKY,
//   SWPC_CAT
// }

// final measurementTechniqueValues = EnumValues({
//   "Plane-of-sky": MeasurementTechnique.PLANE_OF_SKY,
//   "SWPC_CAT": MeasurementTechnique.SWPC_CAT
// });

// enum Type {
//   C,
//   O,
//   S
// }

// final typeValues = EnumValues({
//   "C": Type.C,
//   "O": Type.O,
//   "S": Type.S
// });

class Instrument {
  DisplayName? displayName;

  Instrument({
    this.displayName,
  });

  Instrument copyWith({
    DisplayName? displayName,
  }) =>
      Instrument(
        displayName: displayName ?? this.displayName,
      );

  factory Instrument.fromJson(Map<String, dynamic> json) => Instrument(
    displayName: (json["displayName"] != null && displayNameValues.map.containsKey(json["displayName"]))
        ? displayNameValues.map[json["displayName"]]
        : null, //displayNameValues.map[json["displayName"]]!,
  );

  Map<String, dynamic> toJson() => {
    "displayName": displayNameValues.reverse[displayName],
  };
}

enum DisplayName {
  GOES_CCOR_1,
  SOHO_LASCO_C2,
  SOHO_LASCO_C3,
  STEREO_A_SECCHI_COR2
}

final displayNameValues = EnumValues({
  "GOES: CCOR-1": DisplayName.GOES_CCOR_1,
  "SOHO: LASCO/C2": DisplayName.SOHO_LASCO_C2,
  "SOHO: LASCO/C3": DisplayName.SOHO_LASCO_C3,
  "STEREO A: SECCHI/COR2": DisplayName.STEREO_A_SECCHI_COR2
});

class LinkedEvent {
  String? activityId;

  LinkedEvent({
    this.activityId,
  });

  LinkedEvent copyWith({
    String? activityId,
  }) =>
      LinkedEvent(
        activityId: activityId ?? this.activityId,
      );

  factory LinkedEvent.fromJson(Map<String, dynamic> json) => LinkedEvent(
    activityId: json["activityID"],
  );

  Map<String, dynamic> toJson() => {
    "activityID": activityId,
  };
}

class SentNotification {
  String? messageId;
  String? messageIssueTime;
  String? messageUrl;

  SentNotification({
    this.messageId,
    this.messageIssueTime,
    this.messageUrl,
  });

  SentNotification copyWith({
    String? messageId,
    String? messageIssueTime,
    String? messageUrl,
  }) =>
      SentNotification(
        messageId: messageId ?? this.messageId,
        messageIssueTime: messageIssueTime ?? this.messageIssueTime,
        messageUrl: messageUrl ?? this.messageUrl,
      );

  factory SentNotification.fromJson(Map<String, dynamic> json) => SentNotification(
    messageId: json["messageID"],
    messageIssueTime: json["messageIssueTime"],
    messageUrl: json["messageURL"],
  );

  Map<String, dynamic> toJson() => {
    "messageID": messageId,
    "messageIssueTime": messageIssueTime,
    "messageURL": messageUrl,
  };
}

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
