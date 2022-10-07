const String tableSliders = 'sliders';

class ArticleFields {
  static final List<dynamic> values = [
    pk,
    title,
    description,
    articleDocument,
    userPk,
  ];

  static const String pk = '_pk';
  static const String title = 'title';
  static const String description = 'description';
  static const String articleDocument = 'articleDocument';
  static const String userPk = 'userPk';
}

class Articles {
  final int? pk;
  final String title;
  final String description;
  final List articleDocument;
  final int userPk;

  const Articles({
    this.pk,
    required this.title,
    required this.description,
    required this.articleDocument,
    required this.userPk,
  });

  Articles copy({
    int? pk,
    String? title,
    String? description,
    List? articleDocument,
    int? userPk,
  }) =>
      Articles(
        pk: pk ?? this.pk,
        title: title ?? this.title,
        description: description ?? this.description,
        articleDocument: articleDocument ?? this.articleDocument,
        userPk: userPk ?? this.userPk,
      );

  static Articles fromJson(Map<String, Object?> json) => Articles(
        pk: json[ArticleFields.pk] as int?,
        title: json[ArticleFields.title] as String,
        description: json[ArticleFields.description] as String,
        articleDocument: json[ArticleFields.articleDocument] as List,
        userPk: json[ArticleFields.userPk] as int,
      );

  Map<dynamic, Object?> toJson() => {
        ArticleFields.pk: pk,
        ArticleFields.title: title,
        ArticleFields.description: description,
        ArticleFields.articleDocument: articleDocument,
        ArticleFields.userPk: userPk,
      };
}
