class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

enum Catalog {
  M2_M_CATALOG
}

final catalogValues = EnumValues({
  "M2M_CATALOG": Catalog.M2_M_CATALOG
});

enum FeatureCode {
  LE,
  SH
}

final featureCodeValues = EnumValues({
  "LE": FeatureCode.LE,
  "SH": FeatureCode.SH
});

enum Type {
  C,
  S,
  O
}

final typeValues = EnumValues({
  "C": Type.C,
  "O": Type.O,
  "S": Type.S
});

enum MeasurementTechnique {
  PLANE_OF_SKY,
  SWPC_CAT
}

final measurementTechniqueValues = EnumValues({
  "Plane-of-sky": MeasurementTechnique.PLANE_OF_SKY,
  "SWPC_CAT": MeasurementTechnique.SWPC_CAT
});

enum ImageType {
  RUNNING_DIFFERENCE
}

final imageTypeValues = EnumValues({
  "running difference": ImageType.RUNNING_DIFFERENCE
});