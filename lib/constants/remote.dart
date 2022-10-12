import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Remote {
  static get(String path, Map<String, String> params) {
    final url = Uri.parse('${dotenv.get('API')}/$path')
        .replace(queryParameters: params);
    return http.get(url);
  }
}
