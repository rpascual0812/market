// import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class Products {
  int pk;
  String uuid;
  String title;
  String productImage;
  double quantity;
  String unit;
  String description;
  String location;
  String type; // looking for, future crop, already available
  String imageURL;
  int createdBy;
  String userImage;
  String userName;
  DateTime dateCreated;
  Products({
    required this.pk,
    required this.uuid,
    required this.title,
    required this.productImage,
    required this.quantity,
    required this.unit,
    required this.description,
    required this.location,
    required this.type,
    this.imageURL = '',
    required this.createdBy,
    required this.userImage,
    required this.userName,
    required this.dateCreated,
  });
}
