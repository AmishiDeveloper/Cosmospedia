// To parse this JSON data, do
//
//     final asteroidLookUpModel = asteroidLookUpModelFromJson(jsonString);

import 'dart:convert';

AsteroidLookUpModel asteroidLookUpModelFromJson(String str) => AsteroidLookUpModel.fromJson(json.decode(str));

String asteroidLookUpModelToJson(AsteroidLookUpModel data) => json.encode(data.toJson());

class AsteroidLookUpModel {
  Links? links;
  String? id;
  String? neoReferenceId;
  String? name;
  String? designation;
  String? nasaJplUrl;
  double? absoluteMagnitudeH;
  EstimatedDiameter? estimatedDiameter;
  bool? isPotentiallyHazardousAsteroid;
  List<CloseApproachDatum>? closeApproachData;
  OrbitalData? orbitalData;
  bool? isSentryObject;

  AsteroidLookUpModel({
    this.links,
    this.id,
    this.neoReferenceId,
    this.name,
    this.designation,
    this.nasaJplUrl,
    this.absoluteMagnitudeH,
    this.estimatedDiameter,
    this.isPotentiallyHazardousAsteroid,
    this.closeApproachData,
    this.orbitalData,
    this.isSentryObject,
  });

  AsteroidLookUpModel copyWith({
    Links? links,
    String? id,
    String? neoReferenceId,
    String? name,
    String? designation,
    String? nasaJplUrl,
    double? absoluteMagnitudeH,
    EstimatedDiameter? estimatedDiameter,
    bool? isPotentiallyHazardousAsteroid,
    List<CloseApproachDatum>? closeApproachData,
    OrbitalData? orbitalData,
    bool? isSentryObject,
  }) =>
      AsteroidLookUpModel(
        links: links ?? this.links,
        id: id ?? this.id,
        neoReferenceId: neoReferenceId ?? this.neoReferenceId,
        name: name ?? this.name,
        designation: designation ?? this.designation,
        nasaJplUrl: nasaJplUrl ?? this.nasaJplUrl,
        absoluteMagnitudeH: absoluteMagnitudeH ?? this.absoluteMagnitudeH,
        estimatedDiameter: estimatedDiameter ?? this.estimatedDiameter,
        isPotentiallyHazardousAsteroid: isPotentiallyHazardousAsteroid ?? this.isPotentiallyHazardousAsteroid,
        closeApproachData: closeApproachData ?? this.closeApproachData,
        orbitalData: orbitalData ?? this.orbitalData,
        isSentryObject: isSentryObject ?? this.isSentryObject,
      );

  factory AsteroidLookUpModel.fromJson(Map<String, dynamic> json) => AsteroidLookUpModel(
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    id: json["id"],
    neoReferenceId: json["neo_reference_id"],
    name: json["name"],
    designation: json["designation"],
    nasaJplUrl: json["nasa_jpl_url"],
    absoluteMagnitudeH: json["absolute_magnitude_h"]?.toDouble(),
    estimatedDiameter: json["estimated_diameter"] == null ? null : EstimatedDiameter.fromJson(json["estimated_diameter"]),
    isPotentiallyHazardousAsteroid: json["is_potentially_hazardous_asteroid"],
    closeApproachData: json["close_approach_data"] == null ? [] : List<CloseApproachDatum>.from(json["close_approach_data"]!.map((x) => CloseApproachDatum.fromJson(x))),
    orbitalData: json["orbital_data"] == null ? null : OrbitalData.fromJson(json["orbital_data"]),
    isSentryObject: json["is_sentry_object"],
  );

  Map<String, dynamic> toJson() => {
    "links": links?.toJson(),
    "id": id,
    "neo_reference_id": neoReferenceId,
    "name": name,
    "designation": designation,
    "nasa_jpl_url": nasaJplUrl,
    "absolute_magnitude_h": absoluteMagnitudeH,
    "estimated_diameter": estimatedDiameter?.toJson(),
    "is_potentially_hazardous_asteroid": isPotentiallyHazardousAsteroid,
    "close_approach_data": closeApproachData == null ? [] : List<dynamic>.from(closeApproachData!.map((x) => x.toJson())),
    "orbital_data": orbitalData?.toJson(),
    "is_sentry_object": isSentryObject,
  };
}

class CloseApproachDatum {
  DateTime? closeApproachDate;
  String? closeApproachDateFull;
  int? epochDateCloseApproach;
  RelativeVelocity? relativeVelocity;
  MissDistance? missDistance;
  OrbitingBody? orbitingBody;

  CloseApproachDatum({
    this.closeApproachDate,
    this.closeApproachDateFull,
    this.epochDateCloseApproach,
    this.relativeVelocity,
    this.missDistance,
    this.orbitingBody,
  });

  CloseApproachDatum copyWith({
    DateTime? closeApproachDate,
    String? closeApproachDateFull,
    int? epochDateCloseApproach,
    RelativeVelocity? relativeVelocity,
    MissDistance? missDistance,
    OrbitingBody? orbitingBody,
  }) =>
      CloseApproachDatum(
        closeApproachDate: closeApproachDate ?? this.closeApproachDate,
        closeApproachDateFull: closeApproachDateFull ?? this.closeApproachDateFull,
        epochDateCloseApproach: epochDateCloseApproach ?? this.epochDateCloseApproach,
        relativeVelocity: relativeVelocity ?? this.relativeVelocity,
        missDistance: missDistance ?? this.missDistance,
        orbitingBody: orbitingBody ?? this.orbitingBody,
      );

  factory CloseApproachDatum.fromJson(Map<String, dynamic> json) => CloseApproachDatum(
    closeApproachDate: json["close_approach_date"] == null ? null : DateTime.parse(json["close_approach_date"]),
    closeApproachDateFull: json["close_approach_date_full"],
    epochDateCloseApproach: json["epoch_date_close_approach"],
    relativeVelocity: json["relative_velocity"] == null ? null : RelativeVelocity.fromJson(json["relative_velocity"]),
    missDistance: json["miss_distance"] == null ? null : MissDistance.fromJson(json["miss_distance"]),
    orbitingBody: json["orbiting_body"] != null
        ?orbitingBodyValues.map[json["orbiting_body"]]
    : null,
  );

  Map<String, dynamic> toJson() => {
    "close_approach_date": "${closeApproachDate!.year.toString().padLeft(4, '0')}-${closeApproachDate!.month.toString().padLeft(2, '0')}-${closeApproachDate!.day.toString().padLeft(2, '0')}",
    "close_approach_date_full": closeApproachDateFull,
    "epoch_date_close_approach": epochDateCloseApproach,
    "relative_velocity": relativeVelocity?.toJson(),
    "miss_distance": missDistance?.toJson(),
    "orbiting_body": orbitingBodyValues.reverse[orbitingBody],
  };
}

class MissDistance {
  String? astronomical;
  String? lunar;
  String? kilometers;
  String? miles;

  MissDistance({
    this.astronomical,
    this.lunar,
    this.kilometers,
    this.miles,
  });

  MissDistance copyWith({
    String? astronomical,
    String? lunar,
    String? kilometers,
    String? miles,
  }) =>
      MissDistance(
        astronomical: astronomical ?? this.astronomical,
        lunar: lunar ?? this.lunar,
        kilometers: kilometers ?? this.kilometers,
        miles: miles ?? this.miles,
      );

  factory MissDistance.fromJson(Map<String, dynamic> json) => MissDistance(
    astronomical: json["astronomical"],
    lunar: json["lunar"],
    kilometers: json["kilometers"],
    miles: json["miles"],
  );

  Map<String, dynamic> toJson() => {
    "astronomical": astronomical,
    "lunar": lunar,
    "kilometers": kilometers,
    "miles": miles,
  };
}

enum OrbitingBody {
  EARTH,
  MERC,
  VENUS
}

final orbitingBodyValues = EnumValues({
  "Earth": OrbitingBody.EARTH,
  "Merc": OrbitingBody.MERC,
  "Venus": OrbitingBody.VENUS
});

class RelativeVelocity {
  String? kilometersPerSecond;
  String? kilometersPerHour;
  String? milesPerHour;

  RelativeVelocity({
    this.kilometersPerSecond,
    this.kilometersPerHour,
    this.milesPerHour,
  });

  RelativeVelocity copyWith({
    String? kilometersPerSecond,
    String? kilometersPerHour,
    String? milesPerHour,
  }) =>
      RelativeVelocity(
        kilometersPerSecond: kilometersPerSecond ?? this.kilometersPerSecond,
        kilometersPerHour: kilometersPerHour ?? this.kilometersPerHour,
        milesPerHour: milesPerHour ?? this.milesPerHour,
      );

  factory RelativeVelocity.fromJson(Map<String, dynamic> json) => RelativeVelocity(
    kilometersPerSecond: json["kilometers_per_second"],
    kilometersPerHour: json["kilometers_per_hour"],
    milesPerHour: json["miles_per_hour"],
  );

  Map<String, dynamic> toJson() => {
    "kilometers_per_second": kilometersPerSecond,
    "kilometers_per_hour": kilometersPerHour,
    "miles_per_hour": milesPerHour,
  };
}

class EstimatedDiameter {
  Feet? kilometers;
  Feet? meters;
  Feet? miles;
  Feet? feet;

  EstimatedDiameter({
    this.kilometers,
    this.meters,
    this.miles,
    this.feet,
  });

  EstimatedDiameter copyWith({
    Feet? kilometers,
    Feet? meters,
    Feet? miles,
    Feet? feet,
  }) =>
      EstimatedDiameter(
        kilometers: kilometers ?? this.kilometers,
        meters: meters ?? this.meters,
        miles: miles ?? this.miles,
        feet: feet ?? this.feet,
      );

  factory EstimatedDiameter.fromJson(Map<String, dynamic> json) => EstimatedDiameter(
    kilometers: json["kilometers"] == null ? null : Feet.fromJson(json["kilometers"]),
    meters: json["meters"] == null ? null : Feet.fromJson(json["meters"]),
    miles: json["miles"] == null ? null : Feet.fromJson(json["miles"]),
    feet: json["feet"] == null ? null : Feet.fromJson(json["feet"]),
  );

  Map<String, dynamic> toJson() => {
    "kilometers": kilometers?.toJson(),
    "meters": meters?.toJson(),
    "miles": miles?.toJson(),
    "feet": feet?.toJson(),
  };
}

class Feet {
  double? estimatedDiameterMin;
  double? estimatedDiameterMax;

  Feet({
    this.estimatedDiameterMin,
    this.estimatedDiameterMax,
  });

  Feet copyWith({
    double? estimatedDiameterMin,
    double? estimatedDiameterMax,
  }) =>
      Feet(
        estimatedDiameterMin: estimatedDiameterMin ?? this.estimatedDiameterMin,
        estimatedDiameterMax: estimatedDiameterMax ?? this.estimatedDiameterMax,
      );

  factory Feet.fromJson(Map<String, dynamic> json) => Feet(
    estimatedDiameterMin: json["estimated_diameter_min"]?.toDouble(),
    estimatedDiameterMax: json["estimated_diameter_max"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "estimated_diameter_min": estimatedDiameterMin,
    "estimated_diameter_max": estimatedDiameterMax,
  };
}

class Links {
  String? self;

  Links({
    this.self,
  });

  Links copyWith({
    String? self,
  }) =>
      Links(
        self: self ?? this.self,
      );

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json["self"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
  };
}

class OrbitalData {
  String? orbitId;
  DateTime? orbitDeterminationDate;
  DateTime? firstObservationDate;
  DateTime? lastObservationDate;
  int? dataArcInDays;
  int? observationsUsed;
  String? orbitUncertainty;
  String? minimumOrbitIntersection;
  String? jupiterTisserandInvariant;
  String? epochOsculation;
  String? eccentricity;
  String? semiMajorAxis;
  String? inclination;
  String? ascendingNodeLongitude;
  String? orbitalPeriod;
  String? perihelionDistance;
  String? perihelionArgument;
  String? aphelionDistance;
  String? perihelionTime;
  String? meanAnomaly;
  String? meanMotion;
  String? equinox;
  OrbitClass? orbitClass;

  OrbitalData({
    this.orbitId,
    this.orbitDeterminationDate,
    this.firstObservationDate,
    this.lastObservationDate,
    this.dataArcInDays,
    this.observationsUsed,
    this.orbitUncertainty,
    this.minimumOrbitIntersection,
    this.jupiterTisserandInvariant,
    this.epochOsculation,
    this.eccentricity,
    this.semiMajorAxis,
    this.inclination,
    this.ascendingNodeLongitude,
    this.orbitalPeriod,
    this.perihelionDistance,
    this.perihelionArgument,
    this.aphelionDistance,
    this.perihelionTime,
    this.meanAnomaly,
    this.meanMotion,
    this.equinox,
    this.orbitClass,
  });

  OrbitalData copyWith({
    String? orbitId,
    DateTime? orbitDeterminationDate,
    DateTime? firstObservationDate,
    DateTime? lastObservationDate,
    int? dataArcInDays,
    int? observationsUsed,
    String? orbitUncertainty,
    String? minimumOrbitIntersection,
    String? jupiterTisserandInvariant,
    String? epochOsculation,
    String? eccentricity,
    String? semiMajorAxis,
    String? inclination,
    String? ascendingNodeLongitude,
    String? orbitalPeriod,
    String? perihelionDistance,
    String? perihelionArgument,
    String? aphelionDistance,
    String? perihelionTime,
    String? meanAnomaly,
    String? meanMotion,
    String? equinox,
    OrbitClass? orbitClass,
  }) =>
      OrbitalData(
        orbitId: orbitId ?? this.orbitId,
        orbitDeterminationDate: orbitDeterminationDate ?? this.orbitDeterminationDate,
        firstObservationDate: firstObservationDate ?? this.firstObservationDate,
        lastObservationDate: lastObservationDate ?? this.lastObservationDate,
        dataArcInDays: dataArcInDays ?? this.dataArcInDays,
        observationsUsed: observationsUsed ?? this.observationsUsed,
        orbitUncertainty: orbitUncertainty ?? this.orbitUncertainty,
        minimumOrbitIntersection: minimumOrbitIntersection ?? this.minimumOrbitIntersection,
        jupiterTisserandInvariant: jupiterTisserandInvariant ?? this.jupiterTisserandInvariant,
        epochOsculation: epochOsculation ?? this.epochOsculation,
        eccentricity: eccentricity ?? this.eccentricity,
        semiMajorAxis: semiMajorAxis ?? this.semiMajorAxis,
        inclination: inclination ?? this.inclination,
        ascendingNodeLongitude: ascendingNodeLongitude ?? this.ascendingNodeLongitude,
        orbitalPeriod: orbitalPeriod ?? this.orbitalPeriod,
        perihelionDistance: perihelionDistance ?? this.perihelionDistance,
        perihelionArgument: perihelionArgument ?? this.perihelionArgument,
        aphelionDistance: aphelionDistance ?? this.aphelionDistance,
        perihelionTime: perihelionTime ?? this.perihelionTime,
        meanAnomaly: meanAnomaly ?? this.meanAnomaly,
        meanMotion: meanMotion ?? this.meanMotion,
        equinox: equinox ?? this.equinox,
        orbitClass: orbitClass ?? this.orbitClass,
      );

  factory OrbitalData.fromJson(Map<String, dynamic> json) => OrbitalData(
    orbitId: json["orbit_id"],
    orbitDeterminationDate: json["orbit_determination_date"] == null ? null : DateTime.parse(json["orbit_determination_date"]),
    firstObservationDate: json["first_observation_date"] == null ? null : DateTime.parse(json["first_observation_date"]),
    lastObservationDate: json["last_observation_date"] == null ? null : DateTime.parse(json["last_observation_date"]),
    dataArcInDays: json["data_arc_in_days"],
    observationsUsed: json["observations_used"],
    orbitUncertainty: json["orbit_uncertainty"],
    minimumOrbitIntersection: json["minimum_orbit_intersection"],
    jupiterTisserandInvariant: json["jupiter_tisserand_invariant"],
    epochOsculation: json["epoch_osculation"],
    eccentricity: json["eccentricity"],
    semiMajorAxis: json["semi_major_axis"],
    inclination: json["inclination"],
    ascendingNodeLongitude: json["ascending_node_longitude"],
    orbitalPeriod: json["orbital_period"],
    perihelionDistance: json["perihelion_distance"],
    perihelionArgument: json["perihelion_argument"],
    aphelionDistance: json["aphelion_distance"],
    perihelionTime: json["perihelion_time"],
    meanAnomaly: json["mean_anomaly"],
    meanMotion: json["mean_motion"],
    equinox: json["equinox"],
    orbitClass: json["orbit_class"] == null ? null : OrbitClass.fromJson(json["orbit_class"]),
  );

  Map<String, dynamic> toJson() => {
    "orbit_id": orbitId,
    "orbit_determination_date": orbitDeterminationDate?.toIso8601String(),
    "first_observation_date": firstObservationDate != null
        ?"${firstObservationDate!.year.toString().padLeft(4, '0')}-${firstObservationDate!.month.toString().padLeft(2, '0')}-${firstObservationDate!.day.toString().padLeft(2, '0')}"
        : null,
    "last_observation_date": "${lastObservationDate!.year.toString().padLeft(4, '0')}-${lastObservationDate!.month.toString().padLeft(2, '0')}-${lastObservationDate!.day.toString().padLeft(2, '0')}",
    "data_arc_in_days": dataArcInDays,
    "observations_used": observationsUsed,
    "orbit_uncertainty": orbitUncertainty,
    "minimum_orbit_intersection": minimumOrbitIntersection,
    "jupiter_tisserand_invariant": jupiterTisserandInvariant,
    "epoch_osculation": epochOsculation,
    "eccentricity": eccentricity,
    "semi_major_axis": semiMajorAxis,
    "inclination": inclination,
    "ascending_node_longitude": ascendingNodeLongitude,
    "orbital_period": orbitalPeriod,
    "perihelion_distance": perihelionDistance,
    "perihelion_argument": perihelionArgument,
    "aphelion_distance": aphelionDistance,
    "perihelion_time": perihelionTime,
    "mean_anomaly": meanAnomaly,
    "mean_motion": meanMotion,
    "equinox": equinox,
    "orbit_class": orbitClass?.toJson(),
  };
}

class OrbitClass {
  String? orbitClassType;
  String? orbitClassDescription;
  String? orbitClassRange;

  OrbitClass({
    this.orbitClassType,
    this.orbitClassDescription,
    this.orbitClassRange,
  });

  OrbitClass copyWith({
    String? orbitClassType,
    String? orbitClassDescription,
    String? orbitClassRange,
  }) =>
      OrbitClass(
        orbitClassType: orbitClassType ?? this.orbitClassType,
        orbitClassDescription: orbitClassDescription ?? this.orbitClassDescription,
        orbitClassRange: orbitClassRange ?? this.orbitClassRange,
      );

  factory OrbitClass.fromJson(Map<String, dynamic> json) => OrbitClass(
    orbitClassType: json["orbit_class_type"],
    orbitClassDescription: json["orbit_class_description"],
    orbitClassRange: json["orbit_class_range"],
  );

  Map<String, dynamic> toJson() => {
    "orbit_class_type": orbitClassType,
    "orbit_class_description": orbitClassDescription,
    "orbit_class_range": orbitClassRange,
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
