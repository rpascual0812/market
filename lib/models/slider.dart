const String tableSliders = 'sliders';

class SliderFields {
  static final List<dynamic> values = [
    pk,
    type,
    title,
    details,
    userPk,
    sliderDocument,
  ];

  static const String pk = '_pk';
  static const String type = 'type';
  static const String title = 'title';
  static const String details = 'details';
  static const String userPk = 'userPk';
  static const String sliderDocument = 'sliderDocument';
}

class Sliders {
  final int? pk;
  final String type;
  final String title;
  final String details;
  final int userPk;
  final List sliderDocument;

  const Sliders({
    this.pk,
    required this.type,
    required this.title,
    required this.details,
    required this.userPk,
    required this.sliderDocument,
  });

  Sliders copy({
    int? pk,
    String? type,
    String? title,
    String? details,
    int? userPk,
    List? sliderDocument,
  }) =>
      Sliders(
        pk: pk ?? this.pk,
        type: type ?? this.type,
        title: title ?? this.title,
        details: details ?? this.details,
        userPk: userPk ?? this.userPk,
        sliderDocument: sliderDocument ?? this.sliderDocument,
      );

  static Sliders fromJson(Map<String, Object?> json) => Sliders(
        pk: json[SliderFields.pk] as int?,
        type: json[SliderFields.type] as String,
        title: json[SliderFields.title] as String,
        details: json[SliderFields.details] as String,
        userPk: json[SliderFields.userPk] as int,
        sliderDocument: json[SliderFields.sliderDocument] as List,
      );

  Map<dynamic, Object?> toJson() => {
        SliderFields.pk: pk,
        SliderFields.type: type,
        SliderFields.title: title,
        SliderFields.details: details,
        SliderFields.userPk: userPk,
        SliderFields.sliderDocument: sliderDocument,
      };
}
