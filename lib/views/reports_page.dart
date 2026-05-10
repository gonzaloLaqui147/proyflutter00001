import 'package:flutter/material.dart';
import 'expenses_page.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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

            // Tarjeta: Presupuesto mensual
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Presupuesto\nmensual',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF001529),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Periodo: Octubre 2023',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '65%',
                            style: TextStyle(
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
                    child: const LinearProgressIndicator(
                      value: 0.65,
                      minHeight: 8,
                      backgroundColor: Color(0xFFE9ECEF),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006C35)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gastado:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          SizedBox(height: 2),
                          Text('S/. 2,400.00', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001529))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Restante:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          SizedBox(height: 2),
                          Text('S/. 1,292.00', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001529))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tarjeta: Distribución de Gastos (Placeholder de Gráfico de Torta)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
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
                  // Área del gráfico simulado
                  const Center(
                    child: Column(
                      children: [
                        Text('TOTAL', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        Text('\$2.4M', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF001529))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDistributionRow('Comida', '40%', const Color(0xFF001529)),
                  _buildDistributionRow('Transporte', '20%', Colors.green),
                  _buildDistributionRow('Ocio', '25%', Colors.redAccent),
                  _buildDistributionRow('Otros', '15%', Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tarjeta: Histórico (6 meses)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
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
                        'Histórico (6 meses)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
                      ),
                      Icon(Icons.trending_up, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Simulación de etiquetas de meses
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT'].map((month) {
                      return Text(
                        month,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: month == 'OCT' ? FontWeight.bold : FontWeight.normal,
                          color: month == 'OCT' ? const Color(0xFF001529) : Colors.grey,
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Sección: Mayores Gastos
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
                      MaterialPageRoute(builder: (context) => const ExpensesPage()),
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

            // Lista de mayores gastos
            _buildMajorExpenseItem(
              icon: Icons.restaurant,
              title: 'Restaurante "El Solar"',
              subtitle: '15 Oct • Comida',
              amount: '-S/125.000',
            ),
            _buildMajorExpenseItem(
              icon: Icons.shopping_bag,
              title: 'Tienda de Ropa Urbana',
              subtitle: '12 Oct • Ocio',
              amount: '-S/340.200',
            ),
            _buildMajorExpenseItem(
              icon: Icons.bolt,
              title: 'Factura Energía Eléctrica',
              subtitle: '08 Oct • Servicios',
              amount: '-S/210.000',
            ),
            const SizedBox(height: 30),
          ],
        ),
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
            color: Colors.black.withValues(alpha: 0.02),
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