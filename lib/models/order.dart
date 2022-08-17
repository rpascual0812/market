const String tableOrders = 'orders';

class OrderFields {
  static final List<String> values = [
    pk,
    productPk,
    uuid,
    paid,
    notes,
    dateCreated,
    synced,
  ];

  static const String pk = '_pk';
  static const String productPk = 'productPk';
  static const String uuid = 'uuid';
  static const String paid = 'paid';
  static const String notes = 'notes';
  static const String dateCreated = 'dateCreated';
  static const String synced = 'synced';
}

class Order {
  final int? pk;
  final int productPk;
  final String uuid;
  final bool paid;
  final String notes;
  final DateTime dateCreated;
  final bool synced;

  const Order({
    this.pk,
    required this.productPk,
    required this.uuid,
    required this.paid,
    required this.notes,
    required this.dateCreated,
    required this.synced,
  });

  Order copy({
    int? pk,
    int? productPk,
    String? uuid,
    bool? paid,
    String? notes,
    DateTime? dateCreated,
    bool? synced,
  }) =>
      Order(
        pk: pk ?? this.pk,
        productPk: productPk ?? this.productPk,
        uuid: uuid ?? this.uuid,
        paid: paid ?? this.paid,
        notes: notes ?? this.notes,
        dateCreated: dateCreated ?? this.dateCreated,
        synced: synced ?? this.synced,
      );

  static Order fromJson(Map<String, Object?> json) => Order(
        pk: json[OrderFields.pk] as int?,
        productPk: json[OrderFields.productPk] as int,
        uuid: json[OrderFields.uuid] as String,
        paid: json[OrderFields.paid] == 1,
        notes: json[OrderFields.notes] as String,
        dateCreated: DateTime.parse(json[OrderFields.dateCreated].toString()),
        synced: json[OrderFields.synced] == 1,
      );

  Map<String, Object?> toJson() => {
        OrderFields.pk: pk,
        OrderFields.productPk: productPk,
        OrderFields.uuid: uuid,
        OrderFields.paid: paid ? 1 : 0,
        OrderFields.notes: notes,
        OrderFields.dateCreated: dateCreated.toIso8601String(),
        OrderFields.synced: synced ? 1 : 0,
      };
}
