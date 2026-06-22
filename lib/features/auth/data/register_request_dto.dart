class RegisterRequestDto {
  final String email;
  final String password;

  RegisterRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}