class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final double presupuesto;
  final Map<String, double> limites;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.presupuesto,
    required this.limites,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "password": password,
    "presupuesto": presupuesto,
    "limites": limites,
  };
}