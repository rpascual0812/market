import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_messages.dart';
import 'package:market/screens/auth/login_page.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AppDefaults {
  static const double radius = 20.00;
  static const double circular = 25.00;
  static const double margin = 16.00;
  static const double padding = 16.00;
  static const double height = 45.00;

  static const double fontSize = 13.00;

  static const double h1 = 50.00;
  static const double h2 = 45.00;
  static const double h3 = 40.00;
  static const double h4 = 35.00;
  static const double h5 = 30.00;
  static const double h6 = 25.00;
  static const double h7 = 20.00;

  static const filters = [
    'Best Seller',
    'Newest',
    'Highest Price',
    'Lowest Price',
    'Average Rating',
    'Vegetables',
    'Fruits',
    'Seeds',
    'Herbs',
  ];

  static BorderRadius borderRadius = BorderRadius.circular(radius);
  static EdgeInsets edgeInset =
      const EdgeInsets.symmetric(vertical: 15, horizontal: 10.0);
  static EdgeInsets edgeInsetDropdown =
      const EdgeInsets.symmetric(vertical: 8, horizontal: 10.0);

  static TextStyle formTextStyle = const TextStyle(fontSize: fontSize);
  static OutlineInputBorder outlineInputBorderSuccess = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDefaults.radius - 10),
    borderSide: const BorderSide(width: 1.0, color: Colors.grey),
  );
  static OutlineInputBorder outlineInputBorderError = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDefaults.radius - 10),
    borderSide: const BorderSide(width: 1.0, color: Colors.redAccent),
  );

  /// Many Parts of the UI uses this same box shadows
  static List<BoxShadow> boxShadows = [
    BoxShadow(
      blurRadius: 15,
      offset: const Offset(5, 4),
      color: const Color(0x0ff33333).withOpacity(0.05),
    )
  ];

  static displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  static toast(BuildContext context, String type, String message) =>
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:
            type == 'success' ? AppColors.primary : AppColors.danger,
        textColor: Colors.white,
        fontSize: AppDefaults.fontSize,
      );

  static navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static logout(BuildContext context) {
    toast(context, 'error', AppMessage.getError('SESSION_EXPIRED'));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  static userImage(List documents) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (documents.isNotEmpty) {
      for (var i = 0; i < documents.length; i++) {
        if (documents[i]['document']['path'] != null &&
            documents[i]['type'] == 'profile_photo') {
          userImage =
              '${dotenv.get('API')}/${documents[i]['document']['path']}';
        }
      }
    }

    return userImage;
  }

  static productImage(List documents) {
    var productImage = '${dotenv.get('API')}/assets/images/no-image.jpg';
    for (var i = 0; i < documents.length; i++) {
      if (documents[i]['document']['path'] != null && documents[i]['default']) {
        productImage =
            '${dotenv.get('API')}/${documents[i]['document']['path']}';
      }
    }

    return productImage;
  }

  static userAddress(List addresses) {
    Map<String, dynamic> userAddress = {};
    for (var i = 0; i < addresses.length; i++) {
      if (addresses[i]['default']) {
        userAddress = addresses[i];
      }
    }

    return userAddress;
  }

  static sellerAddress(List addresses) {
    Map<String, dynamic> userAddress = {};
    for (var i = 0; i < addresses.length; i++) {
      if (addresses[i]['default']) {
        userAddress = addresses[i];
      }
    }

    return userAddress;
  }

  static jwtDecode(String? token) {
    if (token != '') {
      try {
        Map<String, dynamic> payload = Jwt.parseJwt(token!);
        return payload;
      } catch (error) {
        // invalid token format
      }
    }
  }
}
