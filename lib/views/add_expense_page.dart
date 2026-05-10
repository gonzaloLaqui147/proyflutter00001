import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String _amount = "0.00";
  String _selectedCategory = "Transporte";

  // Definición de categorías
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Comida', 'icon': Icons.restaurant_menu},
    {'name': 'Transporte', 'icon': Icons.directions_car},
    {'name': 'Ocio', 'icon': Icons.movie_creation_outlined},
    {'name': 'Salud', 'icon': Icons.medical_services_outlined},
    {'name': 'Educación', 'icon': Icons.school_outlined},
    {'name': 'Otro', 'icon': Icons.more_horiz},
  ];

  void _onKeyTap(String key) {
    setState(() {
      if (key == "back") {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = "0.00";
        }
      } else {
        if (_amount == "0.00") {
          _amount = key;
        } else {
          _amount += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.network('https://cdn-icons-png.flaticon.com/512/6073/6073873.png', width: 30), // Placeholder del logo Bille
        ),
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Bille',
            style: TextStyle(
              color: Color(0xFF001529),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.grey)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Registrar Gasto', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF001529))),
            const Text('Ingresa los detalles de tu transacción', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 30),

            // Sección de Monto
            Center(
              child: Column(
                children: [
                  const Text('MONTO TOTAL', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 5),
                  Text('\$ $_amount', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF001529))),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Grid de Categorías
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categoría', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('REQUERIDO', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedCategory == _categories[index]['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = _categories[index]['name']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF001529) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [if (!isSelected) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_categories[index]['icon'], color: isSelected ? Colors.white : Colors.grey, size: 28),
                        const SizedBox(height: 8),
                        Text(_categories[index]['name'], style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Descripción y otros campos
            const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ej. Almuerzo con el equipo',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // Teclado Numérico Custom
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  _buildKeyboardRow(['1', '2', '3']),
                  _buildKeyboardRow(['4', '5', '6']),
                  _buildKeyboardRow(['7', '8', '9']),
                  _buildKeyboardRow(['.', '0', 'back']),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botón Guardar
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text('Guardar Gasto', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001529),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return Expanded(
          child: TextButton(
            onPressed: () => _onKeyTap(key),
            child: key == 'back'
                ? const Icon(Icons.backspace_outlined, color: Colors.black)
                : Text(key, style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w400)),
          ),
        );
      }).toList(),
    );
  }
}