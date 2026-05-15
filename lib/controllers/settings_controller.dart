import 'package:flutter/material.dart';
import '../Services/api_service.dart';

class SettingsController {
  final ApiService _apiService = ApiService();

  // Variables para controlar los estados en la vista
  bool alertLimitEnabled = true;
  bool weeklyReportEnabled = false;
  final TextEditingController budgetController = TextEditingController();

  // Función corregida: Se llama loadSettings para coincidir con tu Page
  Future<void> loadSettings(int usuarioId, Function onUpdate) async {
    try {
      final config = await _apiService.obtenerConfiguracion(usuarioId);
      if (config != null) {
        alertLimitEnabled = config['alerta_limite'] == 1;
        weeklyReportEnabled = config['reporte_semanal'] == 1;
        budgetController.text = (config['presupuesto'] ?? 0).toString();
        onUpdate(); // Para avisar a la vista que refresque
      }
    } catch (e) {
      print("Error en SettingsController: $e");
    }
  }

  // Función para guardar
  Future<bool> saveSettings(int usuarioId) async {
    try {
      double presupuesto = double.tryParse(budgetController.text) ?? 0.0;

      return await _apiService.actualizarConfiguracion(
        usuarioId,
        alertLimitEnabled,
        weeklyReportEnabled,
        presupuesto,
      );
    } catch (e) {
      print("Error al guardar: $e");
      return false;
    }
  }
}