import 'package:flutter/material.dart';
import '../controllers/prediction_controller.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key, required this.title});

  final String title;

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final PredictionController _controller = PredictionController();
  final TextEditingController _celsiusController = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _makePrediction() async {
    final text = _celsiusController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _result = 'Ingrese un valor.';
      });
      return;
    }
    final number = double.tryParse(text);
    if (number == null) {
      setState(() {
        _result = 'Ingrese un número válido.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _result = '';
    });
    try {
      final prediction = await _controller.makePrediction(number);
      setState(() {
        _result =
        'Valor previsto en Fahrenheit:\n${prediction.fahrenheit.toStringAsFixed(6)}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7eef7),
      appBar: AppBar(
        title: const Text('Predicción Celsius → Fahrenheit'),
        centerTitle: true,
        backgroundColor: const Color(0xfff7eef7),
        elevation: 0,
        foregroundColor: Colors.black87,
      ), // AppBar
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ingrese valor en Celsius:',
                  style: TextStyle(fontSize: 16),
                ), // Text
                const SizedBox(height: 10),
                TextField(
                  controller: _celsiusController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ), // TextInputType.numberWithOptions
                  decoration: const InputDecoration(
                    labelText: 'Celsius',
                    border: OutlineInputBorder(),
                  ), // InputDecoration
                ), // TextField
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loading ? null : _makePrediction,
                  child: _loading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ) // SizedBox
                      : const Text('Predict'),
                ), // ElevatedButton
                const SizedBox(height: 25),
                Text(
                  _result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ), // TextStyle
                ), // Text
              ],
            ), // Column
          ), // Padding
        ), // SingleChildScrollView
      ), // Center
    ); // Scaffold
  }

  @override
  void dispose() {
    _celsiusController.dispose();
    super.dispose();
  }
}