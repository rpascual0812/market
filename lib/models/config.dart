const String tableConfigs = 'config';

class ConfigFields {
  static final List<String> values = [pk, key, value];

  static const String pk = '_pk';
  static const String key = 'key';
  static const String value = 'value';
}

class Config {
  final int? pk;
  final String key;
  final String value;

  const Config({
    this.pk,
    required this.key,
    required this.value,
  });

  Config copy({
    int? pk,
    String? key,
    String? value,
  }) =>
      Config(
        pk: pk ?? this.pk,
        key: key ?? this.key,
        value: value ?? this.value,
      );

  static Config fromJson(Map<String, Object?> json) => Config(
        pk: json[ConfigFields.pk] as int?,
        key: json[ConfigFields.key] as String,
        value: json[ConfigFields.value] as String,
      );

  Map<String, Object?> toJson() => {
        ConfigFields.pk: pk,
        ConfigFields.key: key,
        ConfigFields.value: value,
      };
}
