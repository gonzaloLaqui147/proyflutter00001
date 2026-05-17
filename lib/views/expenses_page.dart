import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // Necesario para la descarga directa en Chrome Web

import '../Services/api_service.dart';
import '../models/gastos_model.dart';

class ExpensesPage extends StatefulWidget {
  final int usuarioId; // Agregamos el id para saber de quién buscar los gastos

  const ExpensesPage({super.key, required this.usuarioId});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final ApiService _apiService = ApiService();

  // Función auxiliar para obtener el ícono según la categoría
  IconData _getIconForCategory(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'comida': return Icons.restaurant;
      case 'transporte': return Icons.directions_car;
      case 'ocio': return Icons.celebration;
      case 'compras': return Icons.shopping_bag;
      case 'salud': return Icons.medical_services;
      case 'educación': return Icons.school;
      case 'servicios': return Icons.bolt;
      default: return Icons.monetization_on_outlined;
    }
  }

  // === FUNCIÓN DE EXPORTACIÓN REVISADA Y CONVERTIDA A VALUE-CELL ===
  Future<void> _exportarAExcel(List<Gasto> listaGastos) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Mis Gastos Bille'];
      excel.delete('Sheet1'); // Eliminar la hoja por defecto

      // En la versión 4.0.6, appendRow espera una lista de tipos 'CellValue'
      // Usamos TextCellValue para textos y IntCellValue/DoubleCellValue para números
      sheetObject.appendRow([
        TextCellValue("Fecha"),
        TextCellValue("Categoría"),
        TextCellValue("Descripción"),
        TextCellValue("Monto (S/)"),
      ]);

      // Rellenamos las filas con los datos reales usando los contenedores correctos
      for (var gasto in listaGastos) {
        sheetObject.appendRow([
          TextCellValue(gasto.fecha),
          TextCellValue(gasto.categoria),
          TextCellValue(gasto.descripcion),
          DoubleCellValue(gasto.monto),
        ]);
      }

      List<int>? fileBytes = excel.save();
      if (fileBytes == null) return;

      // Al estar en Chrome Web, ejecutamos la descarga mediante el navegador
      if (kIsWeb) {
        final blob = html.Blob([fileBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);

        html.AnchorElement(href: url)
          ..setAttribute("download", "Reporte_Gastos_Bille.xlsx")
          ..click();

        html.Url.revokeObjectUrl(url);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📥 Descargando reporte de Excel...'),
            backgroundColor: Color(0xFF006C35),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al exportar: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF001529)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Text(
            'Bille',
            style: TextStyle(
              color: Color(0xFF001529),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Color(0xFF001529)),
          ),
        ],
      ),
      body: FutureBuilder<List<Gasto>>(
        future: _apiService.fetchGastos(widget.usuarioId), // Consumo del endpoint completo
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF001529)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar gastos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aún no has registrado ningún gástos.'));
          }

          final todosLosGastos = snapshot.data!;

          // Cálculo dinámico del total acumulado del mes actual
          final double totalMesActual = todosLosGastos.fold(0.0, (suma, gasto) {
            try {
              DateTime fechaGasto = DateTime.parse(gasto.fecha);
              if (fechaGasto.month == now.month && fechaGasto.year == now.year) {
                return suma + gasto.monto;
              }
            } catch (_) {
              // Manejo preventivo si el formato de fecha de la BD varía
            }
            return suma;
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agrupamos el título y el botón en un Row idéntico al diseño limpio
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mis Gastos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001529),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.file_download_outlined, color: Color(0xFF006C35), size: 26),
                      tooltip: 'Exportar a Excel',
                      onPressed: () => _exportarAExcel(todosLosGastos),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Historial completo de tus transacciones.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 25),

                // Tarjeta de Resumen Mensual Dinámica
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF001529),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GASTOS DE ESTE MES',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'S/ ${totalMesActual.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Listado de Historial Completo
                const Text(
                  'Historial',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001529),
                  ),
                ),
                const SizedBox(height: 12),

                // Mapeamos dinámicamente cada gasto guardado en la base de datos
                ...todosLosGastos.map((gasto) {
                  return _buildExpenseItem(
                    icon: _getIconForCategory(gasto.categoria),
                    title: gasto.descripcion,
                    subtitle: '${gasto.fecha} • ${gasto.categoria}',
                    amount: '- S/ ${gasto.monto.toStringAsFixed(2)}',
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpenseItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF1F3F5),
            radius: 22,
            child: Icon(icon, color: const Color(0xFF001529), size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001529)),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}