class RegisterFormModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  const RegisterFormModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  bool get passwordsMatch => password == confirmPassword;
}
