import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../models/gastos_model.dart';
import 'add_expense_page.dart';
import 'settings_page.dart';
import 'reports_page.dart';
import 'expenses_page.dart';

class DashboardPage extends StatefulWidget {
  final String nombre;
  final int usuarioId;

  const DashboardPage({super.key, required this.nombre, required this.usuarioId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundColor: Colors.grey),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hola,', style: TextStyle(color: Colors.grey, fontSize: 10)),
            Text(
                widget.nombre,
                style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FUTUREBUILDER EXCLUSIVO PARA EL SALDO DISPONIBLE
            FutureBuilder<Map<String, dynamic>>(
              future: _apiService.getSaldoDisponible(widget.usuarioId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF001529),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar saldo: ${snapshot.error}');
                }

                final datos = snapshot.data;
                double saldoReal = 0.0;
                if (datos != null && datos['saldo_disponible'] != null) {
                  saldoReal = double.tryParse(datos['saldo_disponible'].toString()) ?? 0.0;
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF001529),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saldo Disponible', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 10),
                      Text(
                          'S/ ${saldoReal.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 20),

                    ],
                  ),
                );
              },
            ),

            // Espaciado directo hacia las transacciones (Removidas tarjetas de ingresos/gastos)
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transacciones Recientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('VER TODAS', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),

            // HISTORIAL DE TRANSACCIONES EN EL DASHBOARD
            FutureBuilder<List<Gasto>>(
              future: _apiService.fetchGastosRecientes(widget.usuarioId), // CAMBIADO AQUÍ
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Sin transacciones recientes');
                }

                final gastos = snapshot.data!;
                return Column(
                  children: gastos.map<Widget>((gasto) {
                    return _TransactionItem(
                      icon: _getIconForCategory(gasto.categoria),
                      title: gasto.descripcion,
                      subtitle: '${gasto.fecha} • ${gasto.categoria}',
                      amount: '- S/ ${gasto.monto.toStringAsFixed(2)}',
                      isNegative: true,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpensePage(usuarioId: widget.usuarioId)),
          ).then((value) {
            setState(() {}); // Gatilla la actualización del balance al regresar
          });
        },
        backgroundColor: const Color(0xFF001529),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF001529),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpensesPage(usuarioId: widget.usuarioId))
            );
          } else if (index == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportsPage(usuarioId: widget.usuarioId))
            );
          } else if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(usuarioId: widget.usuarioId)
                )
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Gastos'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reportes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'comida': return Icons.restaurant;
      case 'transporte': return Icons.directions_car;
      case 'ocio': return Icons.celebration; // Agregada categoría Ocio
      case 'compras': return Icons.shopping_bag;
      case 'salud': return Icons.medical_services;
      case 'educación': return Icons.school;
      default: return Icons.monetization_on_outlined;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, amount;
  final Color color;
  final bool isUp;
  const _SummaryCard({required this.label, required this.amount, required this.color, required this.isUp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isUp ? Icons.trending_up : Icons.trending_down, color: color),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, amount;
  final bool isNegative;
  const _TransactionItem({required this.icon, required this.title, required this.subtitle, required this.amount, required this.isNegative});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.grey[100], child: Icon(icon, color: Colors.black54)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Text(amount, style: TextStyle(color: isNegative ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
    );
  }
}