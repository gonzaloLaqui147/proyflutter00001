import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Estados para los switches
  bool _alertLimitEnabled = true;
  bool _weeklyReportEnabled = false;

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
              'Configuración',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001529),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Controla tus gastos con precisión arquitectónica.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 25),

            // Tarjeta: Preferencias de Alerta
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
                  const Text(
                    'Preferencias de Alerta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001529),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSwitchTile(
                    title: 'Alerta por límite de gasto',
                    subtitle: 'Notificar cuando excedas el 80% de tu meta.',
                    value: _alertLimitEnabled,
                    onChanged: (val) => setState(() => _alertLimitEnabled = val),
                  ),
                  const Divider(height: 30, color: Color(0xFFF1F3F5)),
                  _buildSwitchTile(
                    title: 'Reporte semanal automático',
                    subtitle: 'Recibe un PDF detallado cada lunes a las 8 AM.',
                    value: _weeklyReportEnabled,
                    onChanged: (val) => setState(() => _weeklyReportEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tarjeta: Visión Inteligente (Banner Azul)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF001529),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visión Inteligente',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tus límites se ajustan automáticamente basados en tu comportamiento de los últimos 3 meses.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Sección: Límites por Categoría
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Límites por\nCategoría',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001529),
                    height: 1.2,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF001529)),
                  label: const Text(
                    'Añadir\ncategoría',
                    style: TextStyle(
                      color: Color(0xFF001529),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),

            // Categorías de Presupuesto
            _buildBudgetCard(
              categoryCode: 'ALIMENTACIÓN',
              categoryTitle: 'Food',
              icon: Icons.restaurant,
              budget: '800',
              spent: 540,
              total: 800,
              progressColor: const Color(0xFF006C35),
            ),
            _buildBudgetCard(
              categoryCode: 'MOVILIDAD',
              categoryTitle: 'Transport',
              icon: Icons.directions_car,
              budget: '300',
              spent: 245,
              total: 300,
              progressColor: Colors.redAccent,
            ),
            _buildBudgetCard(
              categoryCode: 'OCIO',
              categoryTitle: 'Entretenimiento',
              icon: Icons.movie_creation_outlined,
              budget: 'Establecer límite',
              spent: 0,
              total: 0,
              progressColor: Colors.grey,
              isSet: false,
            ),
            const SizedBox(height: 25),

            // Botón: Guardar configuración
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  'Guardar configuración',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001529),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF001529)),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.3),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF006C35),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildBudgetCard({
    required String categoryCode,
    required String categoryTitle,
    required IconData icon,
    required String budget,
    required double spent,
    required double total,
    required Color progressColor,
    bool isSet = true,
  }) {
    double progressValue = (total > 0) ? (spent / total) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF1F3F5),
                radius: 20,
                child: Icon(icon, color: const Color(0xFF001529), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryCode,
                    style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  Text(
                    categoryTitle,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'S/',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text(
                  budget,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSet ? const Color(0xFF001529) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isSet) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Gastado: S/ ${spent.toInt()} de S/ ${total.toInt()}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Sin límite establecido',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ]
        ],
      ),
    );
  }
}