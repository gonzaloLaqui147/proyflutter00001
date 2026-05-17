import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../models/gastos_model.dart';
import '../controllers/reports_controller.dart';
import 'expenses_page.dart';

class ReportsPage extends StatelessWidget {
  final int usuarioId;

  const ReportsPage({super.key, required this.usuarioId});

  // Función auxiliar para asociar íconos reales en la sección de Mayores Gastos y Predicciones IA
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

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    final ReportsController controller = ReportsController();
    final DateTime now = DateTime.now();

    final List<String> meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    String periodoActual = "${meses[now.month - 1]} ${now.year}";

    final Map<String, Color> coloresCategorias = {
      'Comida': const Color(0xFF001529),
      'Transporte': Colors.green,
      'Ocio': Colors.redAccent,
      'Compras': Colors.orange,
      'Salud': Colors.blue,
      'Educación': Colors.purple,
      'Servicios': Colors.amber,
      'Otros': Colors.grey,
    };

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
        future: apiService.fetchGastos(usuarioId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF001529)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar reportes: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Registra gastos para visualizar tus reportes.'));
          }

          final todosLosGastos = snapshot.data!;

          // CÁLCULOS DEL CONTROLADOR
          final datosPresupuesto = controller.calcularPresupuesto(todosLosGastos);
          final distribucionCategorias = controller.calcularDistribucionPorCategoria(todosLosGastos);
          final double totalAbsoluto = controller.calcularTotalAbsoluto(distribucionCategorias);

          // NUEVOS CÁLCULOS OBTENIDOS
          final listadoHistorico = controller.calcularHistoricoSeisMeses(todosLosGastos);
          final listaMayoresGastos = controller.obtenerMayoresGastos(todosLosGastos);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mis Reportes',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001529),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Análisis detallado de tu actividad financiera.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 25),

                // Tarjeta 1: Presupuesto mensual
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Presupuesto\nmensual',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001529),
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Periodo: $periodoActual',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${(datosPresupuesto['porcentaje']! * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF006C35),
                                ),
                              ),
                              Text(
                                'utilizado',
                                style: TextStyle(color: Colors.grey[600], fontSize: 11),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: datosPresupuesto['porcentaje'],
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE9ECEF),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF006C35)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Gastado:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text('S/. ${datosPresupuesto['gastado']!.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001529))),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Restante:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text('S/. ${datosPresupuesto['restante']!.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001529))),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tarjeta 2: Categoría de Gastos
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categoría de Gastos',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
                          ),
                          Icon(Icons.pie_chart_outline, color: Colors.grey[400]),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            const Text('TOTAL HISTÓRICO', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                            Text('S/. ${totalAbsoluto.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF001529))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      ...distribucionCategorias.entries.map((entry) {
                        final String categoriaNombre = entry.key;
                        final double montoCategoria = entry.value;

                        double porcentaje = (montoCategoria / (totalAbsoluto > 0 ? totalAbsoluto : 1)) * 100;
                        Color colorAsignado = coloresCategorias[categoriaNombre] ?? Colors.grey;

                        return _buildDistributionRow(
                            categoriaNombre,
                            '${porcentaje.toStringAsFixed(0)}%',
                            colorAsignado
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tarjeta 3: Histórico (AHORA DINÁMICO)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Histórico (Últimos 6 meses)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
                          ),
                          Icon(Icons.trending_up, color: Colors.green),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: listadoHistorico.map((mesMap) {
                          String nombreMes = mesMap['nombre'];
                          double totalMes = mesMap['total'];
                          bool esMesActual = mesMap['mes'] == now.month && mesMap['year'] == now.year;

                          return Column(
                            children: [
                              Text(
                                'S/.${totalMes.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: esMesActual ? FontWeight.bold : FontWeight.normal,
                                  color: esMesActual ? const Color(0xFF006C35) : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                nombreMes,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: esMesActual ? FontWeight.bold : FontWeight.normal,
                                  color: esMesActual ? const Color(0xFF001529) : Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Sección: Mayores Gastos (AHORA DINÁMICO)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mayores Gastos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpensesPage(usuarioId: usuarioId),
                          ),
                        );
                      },
                      child: const Text(
                        'Ver todos',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Mapeo dinámico de los 3 ítems con mayores costos de la BD
                if (listaMayoresGastos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text('No hay transacciones registradas.')),
                  )
                else
                  ...listaMayoresGastos.map((gasto) {
                    return _buildMajorExpenseItem(
                      icon: _getIconForCategory(gasto.categoria),
                      title: gasto.descripcion,
                      subtitle: '${gasto.fecha} • ${gasto.categoria}',
                      amount: '-S/ ${gasto.monto.toStringAsFixed(2)}',
                    );
                  }),

                // ================================================================
                // INTEGRACIÓN IA: PREDICCIONES BILLE_AI (Siguiente Mes)
                // ================================================================
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Text(
                      'Predicciones Bille AI',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF001529),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tus próximos 3 probables gastos para el siguiente mes:',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 12),

                FutureBuilder<List<Map<String, dynamic>>>(
                  future: controller.obtenerPrediccionesProximoMes(todosLosGastos, usuarioId, apiService),
                  builder: (context, aiSnapshot) {
                    if (aiSnapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF001529)),
                              ),
                              SizedBox(width: 12),
                              Text('Bille AI analizando tendencias...', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                      );
                    }

                    if (!aiSnapshot.hasData || aiSnapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final predicciones = aiSnapshot.data!;

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF001529), Color(0xFF0A2540)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF001529).withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Column(
                        children: predicciones.map((pred) {
                          String cat = pred['categoria'];
                          double monto = pred['monto'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white.withOpacity(0.15),
                                      radius: 16,
                                      child: Icon(_getIconForCategory(cat), color: Colors.white, size: 16),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      cat,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Text(
                                  'S/. ${monto.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Color(0xFF43FA9B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDistributionRow(String label, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF001529))),
            ],
          ),
          Text(percentage, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF001529))),
        ],
      ),
    );
  }

  Widget _buildMajorExpenseItem({
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