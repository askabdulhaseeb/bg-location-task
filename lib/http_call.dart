import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpCall {
  final String url = dotenv.env['URL'] ?? '';
  final String token = dotenv.env['TOKEN'] ?? '';

  
}
