import 'package:b2b_seller/core/services/enums.dart';

class RegisterEntity{
  const RegisterEntity({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.role = Role.seller,
  });

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final Role role;
}
