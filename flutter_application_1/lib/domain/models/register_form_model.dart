class RegisterFormModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterFormModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  bool get passwordsMatch => password == confirmPassword;
}
