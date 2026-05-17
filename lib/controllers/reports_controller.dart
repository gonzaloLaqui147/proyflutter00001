import '../models/gastos_model.dart';

class ReportsController {
  // LÓGICA TARJETA 1: Presupuesto Mensual
  Map<String, double> calcularPresupuesto(List<Gasto> todosLosGastos) {
    final DateTime now = DateTime.now();
    const double presupuestoDefinido = 4000.00;
    double totalGastadoMes = 0.0;

    for (var gasto in todosLosGastos) {
      try {
        DateTime fechaGasto = DateTime.parse(gasto.fecha);
        if (fechaGasto.month == now.month && fechaGasto.year == now.year) {
          totalGastadoMes += gasto.monto;
        }
      } catch (_) {}
    }

    double restante = presupuestoDefinido - totalGastadoMes;
    if (restante < 0) restante = 0;

    double porcentajeUtilizado = totalGastadoMes / presupuestoDefinido;
    if (porcentajeUtilizado > 1.0) porcentajeUtilizado = 1.0;

    return {
      'presupuesto': presupuestoDefinido,
      'gastado': totalGastadoMes,
      'restante': restante,
      'porcentaje': porcentajeUtilizado,
    };
  }

  // LÓGICA TARJETA 2: Distribución por Categorías
  Map<String, double> calcularDistribucionPorCategoria(List<Gasto> todosLosGastos) {
    Map<String, double> montosPorCategoria = {};

    for (var gasto in todosLosGastos) {
      String cat = gasto.categoria.isEmpty ? 'Otros' : gasto.categoria;
      if (cat.isNotEmpty) {
        cat = cat[0].toUpperCase() + cat.substring(1).toLowerCase();
      }

      montosPorCategoria[cat] = (montosPorCategoria[cat] ?? 0.0) + gasto.monto;
    }

    return montosPorCategoria;
  }

  double calcularTotalAbsoluto(Map<String, double> distribucion) {
    return distribucion.values.fold(0.0, (suma, monto) => suma + monto);
  }

  // === LÓGICA TARJETA 3: Histórico de 6 Meses (CORREGIDO) ===
  List<Map<String, dynamic>> calcularHistoricoSeisMeses(List<Gasto> todosLosGastos) {
    final DateTime now = DateTime.now();
    final List<String> mesesCortos = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];

    List<Map<String, dynamic>> mesesData = [];

    // Corregido el bucle i = 5 de forma simple
    for (int i = 5; i >= 0; i--) {
      DateTime mesCalculado = DateTime(now.year, now.month - i, 1);
      mesesData.add({
        'nombre': mesesCortos[mesCalculado.month - 1],
        'mes': mesCalculado.month,
        'year': mesCalculado.year,
        'total': 0.0,
      });
    }

    for (var gasto in todosLosGastos) {
      try {
        DateTime fechaGasto = DateTime.parse(gasto.fecha);
        for (var mesMap in mesesData) {
          if (fechaGasto.month == mesMap['mes'] && fechaGasto.year == mesMap['year']) {
            mesMap['total'] = (mesMap['total'] as double) + gasto.monto;
          }
        }
      } catch (_) {}
    }

    return mesesData;
  }


  List<Gasto> obtenerMayoresGastos(List<Gasto> todosLosGastos) {
    List<Gasto> listaOrdenada = List.from(todosLosGastos);
    listaOrdenada.sort((a, b) => b.monto.compareTo(a.monto));
    return listaOrdenada.take(3).toList();
  }


  // === LÓGICA TARJETA 3: Predicción única del próximo mes ===
  Future<Map<String, dynamic>?> obtenerPrediccionProximoMes(
      List<Gasto> todosLosGastos,
      int usuarioId,
      dynamic apiService
      ) async {
    if (todosLosGastos.isEmpty) return null;

    final DateTime now = DateTime.now();
    int proximoMes = now.month == 12 ? 1 : now.month + 1;

    // 1. Obtenemos las categorías y tomamos únicamente la TOP 1
    Map<String, double> distribucion = calcularDistribucionPorCategoria(todosLosGastos);
    if (distribucion.isEmpty) return null;

    String categoriaTop1 = distribucion.keys.first;

    try {
      // 2. Consultamos la API solo para esa categoría principal
      final respuesta = await apiService.fetchPrediccion(usuarioId, proximoMes, categoriaTop1.toLowerCase());

      return {
        'categoria': categoriaTop1,
        'monto': respuesta['gasto_predicho'] ?? 0.0,
      };
    } catch (_) {
      // Respaldo local si la IA está apagada
      return {
        'categoria': categoriaTop1,
        'monto': (distribucion[categoriaTop1] ?? 0.0) * 1.05,
      };
    }
  }
}