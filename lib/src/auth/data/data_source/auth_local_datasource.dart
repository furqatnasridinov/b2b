import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {
  Future<String> getAccessToken();
  Future<void> saveAccessToken(String token);
  Future<void> removeAccessToken();
  Future<String> getRefreshToken();
  Future<void> saveRefreshToken(String token);
  Future<void> removeRefreshToken();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;
  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  // ----------------- Access Token Methods -------------------
  @override
  Future<String> getAccessToken() async {
    final token =
        _cachedAccessToken ??
        await _flutterSecureStorage.read(
          key: SecureDataStorageKeys.userAccessToken,
        ) ??
        '';
    return token;
  }

  @override
  Future<void> removeAccessToken() async {
    await _deleteFromSecureStorage(
      storageKey: SecureDataStorageKeys.userAccessToken,
    );
    _cachedAccessToken = null;
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _saveToSecureStorage(
      token: token,
      cachedValue: _cachedAccessToken,
      cacheSetter: (val) => _cachedAccessToken = val,
      storageKey: SecureDataStorageKeys.userAccessToken,
    );
  }

  // ----------------- Refresh Token Methods -------------------
  @override
  Future<String> getRefreshToken() async {
    final token =
        _cachedRefreshToken ??
        await _flutterSecureStorage.read(
          key: SecureDataStorageKeys.userRefreshToken,
        ) ??
        '';
    return token;
  }

  @override
  Future<void> removeRefreshToken() async {
    await _deleteFromSecureStorage(
      storageKey: SecureDataStorageKeys.userRefreshToken,
    );
    _cachedRefreshToken = null;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _saveToSecureStorage(
      token: token,
      cachedValue: _cachedRefreshToken,
      cacheSetter: (val) => _cachedRefreshToken = val,
      storageKey: SecureDataStorageKeys.userRefreshToken,
    );
  }

  // ----------------- Secure Storage Methods -------------------
  Future<void> _saveToSecureStorage({
    required String token,
    required String? cachedValue,
    required ValueSetter<String> cacheSetter,
    required String storageKey,
  }) async {
    // Use cached if available; otherwise read from storage
    final existingToken =
        cachedValue ?? await _flutterSecureStorage.read(key: storageKey);

    if (token != existingToken) {
      cacheSetter(token);
      await _flutterSecureStorage.write(key: storageKey, value: token);
    }
  }

  Future<void> _deleteFromSecureStorage({
    required String storageKey,
  }) async {
    await _flutterSecureStorage.delete(key: storageKey);
  }
}

class SecureDataStorageKeys {
  static const String userId = 'userId';
  static const String userAvatar = 'userAvatar';
  static const String userAccessToken = 'userAccessToken';
  static const String userRefreshToken = 'userRefreshToken';
}
