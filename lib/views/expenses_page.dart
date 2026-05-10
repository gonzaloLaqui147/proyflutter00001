import 'package:flutter/material.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

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
              'Mis Gastos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001529),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Historial completo de tus transacciones.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 25),

            // Tarjeta de Resumen Mensual (Gasto del mes actual)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF001529),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GASTOS DE ESTE MES',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'S/ 1,550.00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Grupo de Gastos: HOY
            const Text(
              'Hoy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001529),
              ),
            ),
            const SizedBox(height: 12),
            _buildExpenseItem(
              icon: Icons.restaurant,
              title: 'Restaurante La Mar',
              subtitle: '13:45 • Comida',
              amount: '- S/ 120.00',
            ),
            _buildExpenseItem(
              icon: Icons.directions_car,
              title: 'Uber Perú',
              subtitle: '09:30 • Transporte',
              amount: '- S/ 25.50',
            ),
            const SizedBox(height: 20),

            // Grupo de Gastos: AYER
            const Text(
              'Ayer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001529),
              ),
            ),
            const SizedBox(height: 12),
            _buildExpenseItem(
              icon: Icons.shopping_bag,
              title: 'H&M Jockey Plaza',
              subtitle: '18:15 • Compras',
              amount: '- S/ 249.00',
            ),
            _buildExpenseItem(
              icon: Icons.local_gas_station,
              title: 'Primax San Isidro',
              subtitle: '11:00 • Transporte',
              amount: '- S/ 145.00',
            ),
            const SizedBox(height: 20),

            // Grupo de Gastos: ANTERIORES
            const Text(
              'Octubre 2023',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001529),
              ),
            ),
            const SizedBox(height: 12),
            _buildExpenseItem(
              icon: Icons.school,
              title: 'Matrícula de Curso',
              subtitle: '25 Oct • Educación',
              amount: '- S/ 600.00',
            ),
            _buildExpenseItem(
              icon: Icons.bolt,
              title: 'Factura Luz del Sur',
              subtitle: '22 Oct • Servicios',
              amount: '- S/ 210.00',
            ),
            const SizedBox(height: 30),
          ],
        ),
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