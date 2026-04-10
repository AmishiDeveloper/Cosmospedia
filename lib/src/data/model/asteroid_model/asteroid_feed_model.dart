// To parse this JSON data, do
//
//     final asteroidFeedModel = asteroidFeedModelFromJson(jsonString);

import 'dart:convert';

import 'asteroid_common_models/asteroid_close_approach_model.dart';
import 'asteroid_common_models/asteroid_estimated_diameter_model.dart';

AsteroidFeedModel asteroidFeedModelFromJson(String str) => AsteroidFeedModel.fromJson(json.decode(str));

String asteroidFeedModelToJson(AsteroidFeedModel data) => json.encode(data.toJson());

class AsteroidFeedModel {
  AsteroidFeedModelLinks? links;
  int? elementCount;
  Map<String, List<NearEarthObject>>? nearEarthObjects;

  AsteroidFeedModel({
    this.links,
    this.elementCount,
    this.nearEarthObjects,
  });

  AsteroidFeedModel copyWith({
    AsteroidFeedModelLinks? links,
    int? elementCount,
    Map<String, List<NearEarthObject>>? nearEarthObjects,
  }) =>
      AsteroidFeedModel(
        links: links ?? this.links,
        elementCount: elementCount ?? this.elementCount,
        nearEarthObjects: nearEarthObjects ?? this.nearEarthObjects,
      );

  factory AsteroidFeedModel.fromJson(Map<String, dynamic> json) => AsteroidFeedModel(
    links: json["links"] == null ? null : AsteroidFeedModelLinks.fromJson(json["links"]),
    elementCount: json["element_count"],
    nearEarthObjects: json["near_earth_objects"]== null
        ? null
        : Map.from(json["near_earth_objects"]).map((k, v) => MapEntry<String, List<NearEarthObject>>(k, List<NearEarthObject>.from(v.map((x) => NearEarthObject.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "links": links?.toJson(),
    "element_count": elementCount,
    "near_earth_objects": Map.from(nearEarthObjects!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
  };
}

class AsteroidFeedModelLinks {
  String? next;
  String? previous;
  String? self;

  AsteroidFeedModelLinks({
    this.next,
    this.previous,
    this.self,
  });

  AsteroidFeedModelLinks copyWith({
    String? next,
    String? previous,
    String? self,
  }) =>
      AsteroidFeedModelLinks(
        next: next ?? this.next,
        previous: previous ?? this.previous,
        self: self ?? this.self,
      );

  factory AsteroidFeedModelLinks.fromJson(Map<String, dynamic> json) => AsteroidFeedModelLinks(
    next: json["next"],
    previous: json["previous"],
    self: json["self"],
  );

  Map<String, dynamic> toJson() => {
    "next": next,
    "previous": previous,
    "self": self,
  };
}

class NearEarthObject {
  NearEarthObjectLinks? links;
  String? id;
  String? neoReferenceId;
  String? name;
  String? nasaJplUrl;
  double? absoluteMagnitudeH;
  EstimatedDiameter? estimatedDiameter;
  bool? isPotentiallyHazardousAsteroid;
  List<CloseApproachDatum>? closeApproachData;
  bool? isSentryObject;
  String? sentryData;

  NearEarthObject({
    this.links,
    this.id,
    this.neoReferenceId,
    this.name,
    this.nasaJplUrl,
    this.absoluteMagnitudeH,
    this.estimatedDiameter,
    this.isPotentiallyHazardousAsteroid,
    this.closeApproachData,
    this.isSentryObject,
    this.sentryData,
  });

  NearEarthObject copyWith({
    NearEarthObjectLinks? links,
    String? id,
    String? neoReferenceId,
    String? name,
    String? nasaJplUrl,
    double? absoluteMagnitudeH,
    EstimatedDiameter? estimatedDiameter,
    bool? isPotentiallyHazardousAsteroid,
    List<CloseApproachDatum>? closeApproachData,
    bool? isSentryObject,
    String? sentryData,
  }) =>
      NearEarthObject(
        links: links ?? this.links,
        id: id ?? this.id,
        neoReferenceId: neoReferenceId ?? this.neoReferenceId,
        name: name ?? this.name,
        nasaJplUrl: nasaJplUrl ?? this.nasaJplUrl,
        absoluteMagnitudeH: absoluteMagnitudeH ?? this.absoluteMagnitudeH,
        estimatedDiameter: estimatedDiameter ?? this.estimatedDiameter,
        isPotentiallyHazardousAsteroid: isPotentiallyHazardousAsteroid ?? this.isPotentiallyHazardousAsteroid,
        closeApproachData: closeApproachData ?? this.closeApproachData,
        isSentryObject: isSentryObject ?? this.isSentryObject,
        sentryData: sentryData ?? this.sentryData,
      );

  factory NearEarthObject.fromJson(Map<String, dynamic> json) => NearEarthObject(
    links: json["links"] == null ? null : NearEarthObjectLinks.fromJson(json["links"]),
    id: json["id"],
    neoReferenceId: json["neo_reference_id"],
    name: json["name"],
    nasaJplUrl: json["nasa_jpl_url"],
    absoluteMagnitudeH: json["absolute_magnitude_h"]?.toDouble(),
    estimatedDiameter: json["estimated_diameter"] == null ? null : EstimatedDiameter.fromJson(json["estimated_diameter"]),
    isPotentiallyHazardousAsteroid: json["is_potentially_hazardous_asteroid"],
    closeApproachData: json["close_approach_data"] == null ? [] : List<CloseApproachDatum>.from(json["close_approach_data"]!.map((x) => CloseApproachDatum.fromJson(x))),
    isSentryObject: json["is_sentry_object"],
    sentryData: json["sentry_data"],
  );

  Map<String, dynamic> toJson() => {
    "links": links?.toJson(),
    "id": id,
    "neo_reference_id": neoReferenceId,
    "name": name,
    "nasa_jpl_url": nasaJplUrl,
    "absolute_magnitude_h": absoluteMagnitudeH,
    "estimated_diameter": estimatedDiameter?.toJson(),
    "is_potentially_hazardous_asteroid": isPotentiallyHazardousAsteroid,
    "close_approach_data": closeApproachData == null ? [] : List<dynamic>.from(closeApproachData!.map((x) => x.toJson())),
    "is_sentry_object": isSentryObject,
    "sentry_data": sentryData,
  };
}

// class CloseApproachDatum {
//   DateTime? closeApproachDate;
//   String? closeApproachDateFull;
//   int? epochDateCloseApproach;
//   RelativeVelocity? relativeVelocity;
//   MissDistance? missDistance;
//   OrbitingBody? orbitingBody;
//
//   CloseApproachDatum({
//     this.closeApproachDate,
//     this.closeApproachDateFull,
//     this.epochDateCloseApproach,
//     this.relativeVelocity,
//     this.missDistance,
//     this.orbitingBody,
//   });
//
//   CloseApproachDatum copyWith({
//     DateTime? closeApproachDate,
//     String? closeApproachDateFull,
//     int? epochDateCloseApproach,
//     RelativeVelocity? relativeVelocity,
//     MissDistance? missDistance,
//     OrbitingBody? orbitingBody,
//   }) =>
//       CloseApproachDatum(
//         closeApproachDate: closeApproachDate ?? this.closeApproachDate,
//         closeApproachDateFull: closeApproachDateFull ?? this.closeApproachDateFull,
//         epochDateCloseApproach: epochDateCloseApproach ?? this.epochDateCloseApproach,
//         relativeVelocity: relativeVelocity ?? this.relativeVelocity,
//         missDistance: missDistance ?? this.missDistance,
//         orbitingBody: orbitingBody ?? this.orbitingBody,
//       );
//
//   factory CloseApproachDatum.fromJson(Map<String, dynamic> json) => CloseApproachDatum(
//     closeApproachDate: json["close_approach_date"] == null ? null : DateTime.parse(json["close_approach_date"]),
//     closeApproachDateFull: json["close_approach_date_full"],
//     epochDateCloseApproach: json["epoch_date_close_approach"],
//     relativeVelocity: json["relative_velocity"] == null ? null : RelativeVelocity.fromJson(json["relative_velocity"]),
//     missDistance: json["miss_distance"] == null ? null : MissDistance.fromJson(json["miss_distance"]),
//     orbitingBody: json["orbiting_body"] != null ? orbitingBodyValues.map[json["orbiting_body"]]: null,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "close_approach_date": "${closeApproachDate!.year.toString().padLeft(4, '0')}-${closeApproachDate!.month.toString().padLeft(2, '0')}-${closeApproachDate!.day.toString().padLeft(2, '0')}",
//     "close_approach_date_full": closeApproachDateFull,
//     "epoch_date_close_approach": epochDateCloseApproach,
//     "relative_velocity": relativeVelocity?.toJson(),
//     "miss_distance": missDistance?.toJson(),
//     "orbiting_body": orbitingBodyValues.reverse[orbitingBody],
//   };
// }
//
// class MissDistance {
//   String? astronomical;
//   String? lunar;
//   String? kilometers;
//   String? miles;
//
//   MissDistance({
//     this.astronomical,
//     this.lunar,
//     this.kilometers,
//     this.miles,
//   });
//
//   MissDistance copyWith({
//     String? astronomical,
//     String? lunar,
//     String? kilometers,
//     String? miles,
//   }) =>
//       MissDistance(
//         astronomical: astronomical ?? this.astronomical,
//         lunar: lunar ?? this.lunar,
//         kilometers: kilometers ?? this.kilometers,
//         miles: miles ?? this.miles,
//       );
//
//   factory MissDistance.fromJson(Map<String, dynamic> json) => MissDistance(
//     astronomical: json["astronomical"],
//     lunar: json["lunar"],
//     kilometers: json["kilometers"],
//     miles: json["miles"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "astronomical": astronomical,
//     "lunar": lunar,
//     "kilometers": kilometers,
//     "miles": miles,
//   };
// }
//
// enum OrbitingBody {
//   EARTH
// }
//
// final orbitingBodyValues = EnumValues({
//   "Earth": OrbitingBody.EARTH
// });

// class RelativeVelocity {
//   String? kilometersPerSecond;
//   String? kilometersPerHour;
//   String? milesPerHour;
//
//   RelativeVelocity({
//     this.kilometersPerSecond,
//     this.kilometersPerHour,
//     this.milesPerHour,
//   });
//
//   RelativeVelocity copyWith({
//     String? kilometersPerSecond,
//     String? kilometersPerHour,
//     String? milesPerHour,
//   }) =>
//       RelativeVelocity(
//         kilometersPerSecond: kilometersPerSecond ?? this.kilometersPerSecond,
//         kilometersPerHour: kilometersPerHour ?? this.kilometersPerHour,
//         milesPerHour: milesPerHour ?? this.milesPerHour,
//       );
//
//   factory RelativeVelocity.fromJson(Map<String, dynamic> json) => RelativeVelocity(
//     kilometersPerSecond: json["kilometers_per_second"],
//     kilometersPerHour: json["kilometers_per_hour"],
//     milesPerHour: json["miles_per_hour"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "kilometers_per_second": kilometersPerSecond,
//     "kilometers_per_hour": kilometersPerHour,
//     "miles_per_hour": milesPerHour,
//   };
// }

// class EstimatedDiameter {
//   Feet? kilometers;
//   Feet? meters;
//   Feet? miles;
//   Feet? feet;
//
//   EstimatedDiameter({
//     this.kilometers,
//     this.meters,
//     this.miles,
//     this.feet,
//   });
//
//   EstimatedDiameter copyWith({
//     Feet? kilometers,
//     Feet? meters,
//     Feet? miles,
//     Feet? feet,
//   }) =>
//       EstimatedDiameter(
//         kilometers: kilometers ?? this.kilometers,
//         meters: meters ?? this.meters,
//         miles: miles ?? this.miles,
//         feet: feet ?? this.feet,
//       );
//
//   factory EstimatedDiameter.fromJson(Map<String, dynamic> json) => EstimatedDiameter(
//     kilometers: json["kilometers"] == null ? null : Feet.fromJson(json["kilometers"]),
//     meters: json["meters"] == null ? null : Feet.fromJson(json["meters"]),
//     miles: json["miles"] == null ? null : Feet.fromJson(json["miles"]),
//     feet: json["feet"] == null ? null : Feet.fromJson(json["feet"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "kilometers": kilometers?.toJson(),
//     "meters": meters?.toJson(),
//     "miles": miles?.toJson(),
//     "feet": feet?.toJson(),
//   };
// }
//
// class Feet {
//   double? estimatedDiameterMin;
//   double? estimatedDiameterMax;
//
//   Feet({
//     this.estimatedDiameterMin,
//     this.estimatedDiameterMax,
//   });
//
//   Feet copyWith({
//     double? estimatedDiameterMin,
//     double? estimatedDiameterMax,
//   }) =>
//       Feet(
//         estimatedDiameterMin: estimatedDiameterMin ?? this.estimatedDiameterMin,
//         estimatedDiameterMax: estimatedDiameterMax ?? this.estimatedDiameterMax,
//       );
//
//   factory Feet.fromJson(Map<String, dynamic> json) => Feet(
//     estimatedDiameterMin: json["estimated_diameter_min"]?.toDouble(),
//     estimatedDiameterMax: json["estimated_diameter_max"]?.toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "estimated_diameter_min": estimatedDiameterMin,
//     "estimated_diameter_max": estimatedDiameterMax,
//   };
// }

class NearEarthObjectLinks {
  String? self;

  NearEarthObjectLinks({
    this.self,
  });

  NearEarthObjectLinks copyWith({
    String? self,
  }) =>
      NearEarthObjectLinks(
        self: self ?? this.self,
      );

  factory NearEarthObjectLinks.fromJson(Map<String, dynamic> json) => NearEarthObjectLinks(
    self: json["self"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
