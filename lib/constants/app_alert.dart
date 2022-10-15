import 'package:flutter/material.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class Swal {
  static successConfirm(
      BuildContext context, String title, String message) async {
    return await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.success,
        denyButtonText: "Ok",
        denyButtonColor: Colors.grey,
        title: "Do you want to save the changes?",
        confirmButtonText: "Go to Cart",
      ),
    );
  }
}
