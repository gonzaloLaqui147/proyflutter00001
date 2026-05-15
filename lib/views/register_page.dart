import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../models/register_model.dart'; // Asegúrate de tener el modelo creado

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiService _apiService = ApiService();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Paso 1: Credenciales
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Paso 2: Presupuesto Global
  final _presupuestoCtrl = TextEditingController(text: "0");

  // Paso 3: Límites por Categoría
  final Map<String, TextEditingController> _limitCtrls = {
    'Comida': TextEditingController(text: '0'),
    'Transporte': TextEditingController(text: '0'),
    'Ocio': TextEditingController(text: '0'),
    'Salud': TextEditingController(text: '0'),
    'Educación': TextEditingController(text: '0'),
  };

  // Lógica Matemática: ¿Cuánto queda por repartir?
  double get _restante {
    double total = double.tryParse(_presupuestoCtrl.text) ?? 0;
    double sumaLimites = _limitCtrls.values
        .map((c) => double.tryParse(c.text) ?? 0)
        .reduce((a, b) => a + b);
    return total - sumaLimites;
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finalizarRegistro() async {
    // 1. Verificación de seguridad antes de disparar
    if (_restante < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La suma de los límites no puede exceder el presupuesto.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2. Empaquetado de datos para el ApiService
    final datos = RegisterRequest(
      username: _userCtrl.text,
      email: _emailCtrl.text,
      password: _passCtrl.text,
      presupuesto: double.parse(_presupuestoCtrl.text),
      limites: _limitCtrls.map((k, v) => MapEntry(k, double.parse(v.text))),
    );

    // 3. Llamada al backend
    bool exito = await _apiService.registrarUsuarioCompleto(datos);

    if (exito) {
      if (mounted) {
        // Mensaje de éxito para el usuario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro completado con éxito! Bienvenido a Bille.'),
            backgroundColor: Color(0xFF006C35),
          ),
        );

        // REDIRECCIÓN: Aquí es donde lo llevamos de vuelta al Login
        // Usamos pushNamedAndRemoveUntil para limpiar el historial de navegación
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al procesar el registro. Inténtalo de nuevo.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentStep = i),
                children: [
                  _stepCredentials(),
                  _stepGlobalBudget(),
                  _stepCategoryLimits(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Bille',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF001529)),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF001529),
          ),
        ],
      ),
    );
  }

  // PASO 1: USER, EMAIL, PASS
  Widget _stepCredentials() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Crea tu cuenta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _inputField('Usuario', _userCtrl, Icons.person_outline),
          _inputField('Email', _emailCtrl, Icons.email_outlined),
          _inputField('Contraseña', _passCtrl, Icons.lock_outline, obscure: true),
          const Spacer(),
          _btnPrincipal('Continuar', _nextPage),
        ],
      ),
    );
  }

  // PASO 2: PRESUPUESTO GLOBAL
  Widget _stepGlobalBudget() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tu meta mensual', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('¿Cuánto planeas gastar en total este mes?', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          _inputField('Monto Total S/', _presupuestoCtrl, Icons.account_balance_wallet, isNumber: true),
          const Spacer(),
          _btnPrincipal('Siguiente', _nextPage),
        ],
      ),
    );
  }

  // PASO 3: LÍMITES POR CATEGORÍA
  Widget _stepCategoryLimits() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Distribuye tus gastos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _restante >= 0 ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Restante: S/ $_restante',
                  style: TextStyle(color: _restante >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              children: _limitCtrls.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _inputField(entry.key, entry.value, Icons.label_outline, isNumber: true, mini: true),
                );
              }).toList(),
            ),
          ),
          _btnPrincipal('Finalizar Registro', _finalizarRegistro, disabled: _restante < 0),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // WIDGETS REUTILIZABLES
  Widget _inputField(String label, TextEditingController ctrl, IconData icon, {bool obscure = false, bool isNumber = false, bool mini = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: mini ? 0 : 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF001529)),
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _btnPrincipal(String text, VoidCallback onPress, {bool disabled = false}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: disabled ? null : onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF001529),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}