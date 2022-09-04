// import 'dart:ffi';

// import 'package:flutter/cupertino.dart';

class Ratings {
  int pk;
  int userId;
  String userFirstName;
  String userLastName;
  String userImage;
  double rating;
  String comment;
  DateTime dateCreated;
  Ratings({
    required this.pk,
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.dateCreated,
  });
}
