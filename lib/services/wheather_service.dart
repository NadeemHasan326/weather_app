import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wheather_app/models/wheather_model.dart';

class WheatherService {
  static Future<WheatherModel?> getWheather({required String cityName}) async {
    final apiKey = dotenv.env["WHEATHER_API_KEY"];

    try {
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey",
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WheatherModel.fromJson(json);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
