import 'package:b2b_seller/core/services/enums.dart';

class UserEntity{
  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final Role? role;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
