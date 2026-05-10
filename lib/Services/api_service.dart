import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IP especial para que el emulador vea tu PC
  static const String baseUrl = "http://10.0.2.2:3000";

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("¡Conexión exitosa a Bille!");
      return true;
    } else {
      print("Error en el login: ${response.body}");
      return false;
    }
  }
}