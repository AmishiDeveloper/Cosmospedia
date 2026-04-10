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