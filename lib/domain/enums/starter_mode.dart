enum StarterMode {
  rotation,
  random,
  manual;

  String toJson() => name;

  static StarterMode fromJson(String json) => StarterMode.values.byName(json);
}
