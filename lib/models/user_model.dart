class UserModel {
  String name;
  String email;
  String phone;
  String birthDate;
  String password;
  String role; // 'mitra' | 'produsen' | 'admin'

  UserModel({
    required this.name,
    required this.email,
    this.phone = '',
    this.birthDate = '',
    required this.password,
    this.role = 'mitra', // default mitra hilir
  });
}