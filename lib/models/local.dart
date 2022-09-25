const String tableLocal = 'Locals';

class LocalFields {
  static final List<String> values = [
    pk,
    uuid,
    name,
    value,
    notes,
    dateCreated,
  ];

  static const String pk = '_pk';
  static const String uuid = 'uuid';
  static const String name = 'name';
  static const String value = 'value';
  static const String notes = 'notes';
  static const String dateCreated = 'dateCreated';
}

class Local {
  final int? pk;
  final String uuid;
  final String name;
  final String value;
  final String notes;
  final DateTime dateCreated;

  const Local({
    this.pk,
    required this.uuid,
    required this.name,
    required this.value,
    required this.notes,
    required this.dateCreated,
  });

  Local copy({
    int? pk,
    String? uuid,
    String? name,
    String? value,
    String? notes,
    DateTime? dateCreated,
  }) =>
      Local(
        pk: pk ?? this.pk,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        value: value ?? this.value,
        notes: notes ?? this.notes,
        dateCreated: dateCreated ?? this.dateCreated,
      );

  static Local fromJson(Map<String, Object?> json) => Local(
        pk: json[LocalFields.pk] as int?,
        uuid: json[LocalFields.uuid] as String,
        name: json[LocalFields.name] as String,
        value: json[LocalFields.value] as String,
        notes: json[LocalFields.notes] as String,
        dateCreated: DateTime.parse(json[LocalFields.dateCreated].toString()),
      );

  Map<String, Object?> toJson() => {
        LocalFields.pk: pk,
        LocalFields.uuid: uuid,
        LocalFields.name: name,
        LocalFields.value: value,
        LocalFields.notes: notes,
        LocalFields.dateCreated: dateCreated.toIso8601String(),
      };
}
