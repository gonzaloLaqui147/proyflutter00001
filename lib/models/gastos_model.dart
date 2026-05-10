class Gasto {
  final int id;
  final String descripcion;
  final double monto;
  final String categoria;
  final String fecha;

  Gasto({required this.id, required this.descripcion, required this.monto, required this.categoria, required this.fecha});

  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      id: json['id'],
      descripcion: json['descripcion'],
      monto: double.parse(json['monto'].toString()),
      categoria: json['categoria'],
      fecha: json['fecha'],
    );
  }
}