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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF001529),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saldo Disponible', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 10),
                  Text('S/ 4,250.00', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.credit_card, color: Colors.green, size: 18),
                      SizedBox(width: 10),
                      Text('CUENTA PRINCIPAL • 4492', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row( // Sin const aquí
              children: [
                Expanded(child: _SummaryCard(label: 'INGRESOS', amount: 'S/ 5,800.00', color: Colors.green, isUp: true)),
                const SizedBox(width: 15),
                Expanded(child: _SummaryCard(label: 'GASTOS', amount: 'S/ 1,550.00', color: Colors.red, isUp: false)),
              ],
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transacciones Recientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('VER TODAS', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            FutureBuilder<List<Gasto>>(
              future: _apiService.fetchGastos(widget.usuarioId),
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
            // Refresco de dash
            setState(() {});
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpensesPage()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsPage()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
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
      case 'compras': return Icons.shopping_bag;
      case 'salud': return Icons.medical_services;
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