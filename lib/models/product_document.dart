const String tableProductDocuments = 'ProductDocuments';

class ProductDocumentFields {
  static final List<dynamic> values = [
    pk,
    userPk,
    productPk,
    type,
    documentPk,
    dateCreated,
    document,
  ];

  static const String pk = '_pk';
  static const String userPk = 'userPk';
  static const String productPk = 'productPk';
  static const String type = 'type';
  static const String documentPk = 'documentPk';
  static const String dateCreated = 'dateCreated';
  static const String document = 'document';
}

class ProductDocuments {
  final int? pk;
  final int userPk;
  final int productPk;
  final String type;
  final int documentPk;
  final DateTime dateCreated;
  final Map<String, dynamic> document;

  const ProductDocuments({
    this.pk,
    required this.userPk,
    required this.productPk,
    required this.type,
    required this.documentPk,
    required this.dateCreated,
    required this.document,
  });

  ProductDocuments copy({
    int? pk,
    int? userPk,
    int? productPk,
    String? type,
    int? documentPk,
    DateTime? dateCreated,
    Map<String, dynamic>? document,
  }) =>
      ProductDocuments(
        pk: pk ?? this.pk,
        userPk: userPk ?? this.userPk,
        productPk: productPk ?? this.productPk,
        type: type ?? this.type,
        documentPk: documentPk ?? this.documentPk,
        dateCreated: dateCreated ?? this.dateCreated,
        document: document ?? this.document,
      );

  static ProductDocuments fromJson(Map<String, Object?> json) =>
      ProductDocuments(
        pk: json[ProductDocumentFields.pk] as int?,
        userPk: json[ProductDocumentFields.userPk] as int,
        productPk: json[ProductDocumentFields.productPk] as int,
        type: json[ProductDocumentFields.type] as String,
        documentPk: json[ProductDocumentFields.documentPk] as int,
        dateCreated: json[ProductDocumentFields.dateCreated] as DateTime,
        document: json[ProductDocumentFields.document] as Map<String, dynamic>,
      );

  Map<dynamic, Object?> toJson() => {
        ProductDocumentFields.pk: pk,
        ProductDocumentFields.userPk: userPk,
        ProductDocumentFields.productPk: productPk,
        ProductDocumentFields.type: type,
        ProductDocumentFields.documentPk: documentPk,
        ProductDocumentFields.dateCreated: dateCreated,
        ProductDocumentFields.document: document,
      };
}
