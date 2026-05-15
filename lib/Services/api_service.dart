import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gastos_model.dart';
import '../models/register_model.dart';

class ApiService {
  // Dirección IP para Chrome Web
  static const String baseUrl = "http://localhost:3000";

  // Funcion Registro
  Future<bool> registrarUsuarioCompleto(RegisterRequest datos) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/registro-completo'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(datos.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Error en registro: $e");
      return false;
    }
  }

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
        Uri.parse('$baseUrl/gastos'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario_id": usuarioId,
          "descripcion": desc,
          "monto": monto,
          "categoria": cat,
          "fecha": fecha,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;

    } catch (e) {
      print("Error en api_service al agregar: $e");
      return false;
    }
  }

  // 3. OBTENER CONFIGURACIÓN DEL USUARIO
  Future<Map<String, dynamic>?> obtenerConfiguracion(int usuarioId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/configuracion/$usuarioId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Error en ApiService (GET config): $e");
      return null;
    }
  }

  // 4. ACTUALIZAR CONFIGURACIÓN DEL USUARIO
  Future<bool> actualizarConfiguracion(int id, bool alerta, bool reporte, double presupuesto) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/configuracion'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "alerta_limite": alerta ? 1 : 0,
          "reporte_semanal": reporte ? 1 : 0,
          "presupuesto": presupuesto,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error en ApiService (POST config): $e");
      return false;
    }
  }
}