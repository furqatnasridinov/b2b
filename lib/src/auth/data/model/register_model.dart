import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/domain/entity/register_entity.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.role,
  });

  factory RegisterModel.fromEntity(RegisterEntity entity) {
    return RegisterModel(
      email: entity.email,
      password: entity.password,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      role: entity.role,
    );
  }

  factory RegisterModel.fromMap(DataMap map) {
    return RegisterModel(
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: Role.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => Role.seller,
      ),
    );
  }

  DataMap toMap() {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'role': role.name,
    };
  }
}
