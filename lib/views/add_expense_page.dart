import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final int usuarioId;

  const AddExpensePage({super.key, required this.usuarioId});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _descriptionController = TextEditingController();

  String _amount = "0.00";
  String _selectedCategory = "Transporte"; // Categoría por defecto
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  // Lista de categorías con sus iconos
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Comida', 'icon': Icons.restaurant_menu},
    {'name': 'Transporte', 'icon': Icons.directions_car},
    {'name': 'Ocio', 'icon': Icons.movie_creation_outlined},
    {'name': 'Salud', 'icon': Icons.medical_services_outlined},
    {'name': 'Educación', 'icon': Icons.school_outlined},
    {'name': 'Otro', 'icon': Icons.more_horiz},
  ];

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF001529)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

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

  Future<void> _saveExpense() async {
    if (_amount == "0.00" || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa monto y descripción")),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Formato para MySQL: YYYY-MM-DD HH:MM:SS
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDate);

    bool success = await _apiService.agregarGasto(
      widget.usuarioId,
      _descriptionController.text,
      double.parse(_amount),
      _selectedCategory,
      formattedDate,
    );

    setState(() => _isSaving = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gasto guardado con éxito"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al conectar con el servidor"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Registrar Gasto', style: TextStyle(color: Color(0xFF001529), fontWeight: FontWeight.bold)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text('S/ $_amount', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF001529))),
            ),
            const SizedBox(height: 15),

            // SECCIÓN FECHA
            const Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd / MM / yyyy').format(_selectedDate), style: const TextStyle(fontSize: 16)),
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF001529)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // SECCIÓN CATEGORÍAS (LOS CUADRITOS)
            const Text('Categoría', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 1.2, crossAxisSpacing: 10, mainAxisSpacing: 10,
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
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_categories[index]['icon'], color: isSelected ? Colors.white : Colors.grey),
                        const SizedBox(height: 4),
                        Text(_categories[index]['name'], style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 11)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Ej. Taxi al centro',
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 20),
            // TECLADO NUMÉRICO
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001529),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar Gasto', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
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
                ? const Icon(Icons.backspace_outlined, color: Colors.black, size: 20)
                : Text(key, style: const TextStyle(fontSize: 20, color: Colors.black)),
          ),
        );
      }).toList(),
    );
  }
}