import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gastos_model.dart';

class ApiService {
  // Dirección IP para Chrome Web
  static const String baseUrl = "http://localhost:3000";

  // 1. FUNCIÓN PARA LEER (GET)
  Future<List<Gasto>> fetchGastos(int usuarioId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/gastos/$usuarioId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Gasto.fromJson(json)).toList();
      } else {
        throw Exception("Error del servidor al leer: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión al obtener gastos: $e");
    }
  }

  // 2. FUNCIÓN PARA CREAR (POST)
  Future<bool> agregarGasto(int usuarioId, String desc, double monto, String cat, String fecha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/gastos'), // CAMBIADO: Antes decía /add-gasto
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario_id": usuarioId,
          "descripcion": desc,
          "monto": monto,
          "categoria": cat,
          "fecha": fecha,
        }),
      );

      // OJO: Tu Node.js responde con status 201 (Created), no 200.
      // Cambia esto para que reconozca el éxito:
      return response.statusCode == 201 || response.statusCode == 200;

    } catch (e) {
      print("Error en api_service al agregar: $e");
      return false;
    }
  }
}