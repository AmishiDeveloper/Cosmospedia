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
  }) => RelativeVelocity(
    kilometersPerSecond: kilometersPerSecond ?? this.kilometersPerSecond,
    kilometersPerHour: kilometersPerHour ?? this.kilometersPerHour,
    milesPerHour: milesPerHour ?? this.milesPerHour,
  );

  factory RelativeVelocity.fromJson(Map<String, dynamic> json) =>
      RelativeVelocity(
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

