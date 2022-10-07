import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Remote {
  static get(String path) {
    final url = Uri.parse('${dotenv.get('API')}/$path');
    return http.get(url);
  }
}
