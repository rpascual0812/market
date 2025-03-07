import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Remote {
  static get(String path, Map<String, String> params) {
    final url = Uri.parse('${dotenv.get('API')}/$path')
        .replace(queryParameters: params);
    return http.get(url);
  }

  static sGet(String path, Map<String, String> params, String token) {
    var tokenObj = json.decode(token);
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${tokenObj['user']['access_token']}',
    };

    final url = Uri.parse('${dotenv.get('API')}/$path')
        .replace(queryParameters: params);
    return http.get(url, headers: headers);
  }

  static post(String path, Map<String, Object> body) {
    print(body);
    // final url = Uri.parse('${dotenv.get('API')}/$path');
    // return http.post(url, body: body);
  }
}
