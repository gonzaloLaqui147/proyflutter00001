import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  // Ahora recibimos el ID del usuario que inició sesión
  final int usuarioId;

  const SettingsPage({super.key, required this.usuarioId});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController _controller = SettingsController();

  @override
  void initState() {
    super.initState();
    // Usamos widget.usuarioId para cargar los datos del usuario correcto
    _controller.loadSettings(widget.usuarioId, () {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF001529)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bille',
          style: TextStyle(color: Color(0xFF001529), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuración',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
            ),
            const SizedBox(height: 25),

            // Tarjeta de Preferencias (Switches)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Alerta por límite de gasto',
                    subtitle: 'Notificar cuando excedas el 80% de tu meta.',
                    value: _controller.alertLimitEnabled,
                    onChanged: (val) => setState(() => _controller.alertLimitEnabled = val),
                  ),
                  const Divider(height: 30),
                  _buildSwitchTile(
                    title: 'Reporte semanal automático',
                    subtitle: 'Recibe un PDF detallado cada lunes a las 8 AM.',
                    value: _controller.weeklyReportEnabled,
                    onChanged: (val) => setState(() => _controller.weeklyReportEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Presupuesto Mensual',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
            ),
            const SizedBox(height: 15),

            // Campo para el presupuesto global (Editable)
            _buildBudgetInput(
              title: 'Límite Global',
              controller: _controller.budgetController,
              icon: Icons.account_balance_wallet_outlined,
            ),

            const SizedBox(height: 40),

            // Botón: Guardar configuración
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Usamos widget.usuarioId para guardar los cambios en el registro correcto
                  bool exito = await _controller.saveSettings(widget.usuarioId);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(exito ? '¡Configuración actualizada!' : 'Error al guardar'),
                        backgroundColor: exito ? const Color(0xFF006C35) : Colors.redAccent,
                      ),
                    );
                    if (exito) Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                    'Guardar configuración',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001529),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001529))),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF006C35),
          activeTrackColor: const Color(0xFF006C35).withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildBudgetInput({required String title, required TextEditingController controller, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF001529)),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              cursorColor: const Color(0xFF001529),
              decoration: InputDecoration(
                labelText: title,
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                prefixText: 'S/ ',
                prefixStyle: const TextStyle(color: Color(0xFF001529), fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF001529)),
            ),
          ),
        ],
      ),
    );
  }
}