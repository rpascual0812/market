// import 'dart:ffi';

// import 'package:flutter/cupertino.dart';

class Products {
  int pk;
  String uuid;
  String type; // looking for, future crop, already available
  String name;
  String description;
  double quantity;
  double priceFrom;
  double priceTo;
  List user;
  List measurement;
  List country;
  List userDocument;
  List productDocument;
  DateTime dateCreated;
  Products({
    required this.pk,
    required this.uuid,
    required this.type,
    required this.name,
    required this.description,
    required this.quantity,
    required this.priceFrom,
    required this.priceTo,
    required this.user,
    required this.measurement,
    required this.country,
    required this.userDocument,
    required this.productDocument,
    required this.dateCreated,
  });
}
