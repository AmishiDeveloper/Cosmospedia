class EstimatedDiameter {
  Feet? kilometers;
  Feet? meters;
  Feet? miles;
  Feet? feet;

  EstimatedDiameter({this.kilometers, this.meters, this.miles, this.feet});

  EstimatedDiameter copyWith({
    Feet? kilometers,
    Feet? meters,
    Feet? miles,
    Feet? feet,
  }) => EstimatedDiameter(
    kilometers: kilometers ?? this.kilometers,
    meters: meters ?? this.meters,
    miles: miles ?? this.miles,
    feet: feet ?? this.feet,
  );

  factory EstimatedDiameter.fromJson(Map<String, dynamic> json) =>
      EstimatedDiameter(
        kilometers: json["kilometers"] == null
            ? null
            : Feet.fromJson(json["kilometers"]),
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

  Feet({this.estimatedDiameterMin, this.estimatedDiameterMax});

  Feet copyWith({double? estimatedDiameterMin, double? estimatedDiameterMax}) =>
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
