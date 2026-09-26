import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/utils/typedef.dart';
import 'package:b2b_seller/src/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.role,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromMap(DataMap map) {
    final rawId = map['id'];
    return UserModel(
      id: rawId is int ? rawId : int.tryParse('$rawId') ?? 0,
      email: map['email'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      phone: map['phone'] as String?,
      role: _roleFromValue(map['role']),
      status: map['status'] as String?,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? ''),
      updatedAt: DateTime.tryParse(map['updated_at'] as String? ?? ''),
    );
  }

  static Role? _roleFromValue(dynamic value) {
    if (value == null) return null;
    if (value == 'both') {
      return Role.supplier;
    }
    for (final role in Role.values) {
      if (role.name == value.toString().toLowerCase()) return role;
    }
    return null;
  }
}
