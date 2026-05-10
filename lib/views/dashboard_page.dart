import 'package:flutter/material.dart';
import 'add_expense_page.dart';
import 'settings_page.dart';
import 'reports_page.dart';
import 'expenses_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundColor: Colors.grey), // Simula la foto de perfil
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HOLA,', style: TextStyle(color: Colors.grey, fontSize: 10)),
            Text('Carlos', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
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
            // Card de Saldo
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
            // Fila de Ingresos / Gastos
            const Row(
              children: [
                Expanded(child: _SummaryCard(label: 'INGRESOS', amount: 'S/ 5,800.00', color: Colors.green, isUp: true)),
                SizedBox(width: 15),
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
            // Lista de transacciones
            _TransactionItem(icon: Icons.restaurant, title: 'Restaurante La Mar', subtitle: 'Hoy • Comida', amount: '- S/ 120.00', isNegative: true),
            _TransactionItem(icon: Icons.directions_car, title: 'Uber Perú', subtitle: 'Ayer • Transporte', amount: '- S/ 25.50', isNegative: true),
            _TransactionItem(icon: Icons.shopping_bag, title: 'H&M Jockey Plaza', subtitle: '23 Oct • Compras', amount: '- S/ 249.00', isNegative: true),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        backgroundColor: const Color(0xFF001529),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF001529),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) { // El índice 1 corresponde a "Gastos"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExpensesPage()),
            );
          } else if (index == 2) { // Reportes
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportsPage()),
            );
          } else if (index == 3) { // Perfil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
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