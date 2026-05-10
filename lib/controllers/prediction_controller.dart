import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class PredictionController {
  final String _baseUrl = 'http://127.0.0.1:5000';

  Future<Prediction> makePrediction(double celsius) async {
    final url = Uri.parse('$_baseUrl/predict/$celsius');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Prediction.fromJson(data);
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }
}