import 'package:flutter/material.dart';


class Validators {
  // Phone number validation method
  static String? validatePhoneNumber(String phoneNumber) {
    const phonePattern = r'^\+?\d{9,15}$'; // 10-15 digits phone number
    final regex = RegExp(phonePattern);
    if (phoneNumber.isEmpty) {
      return 'Phone number is required';
    } else if (!regex.hasMatch(phoneNumber)) {
      return 'Enter a valid phone number';
    }
    return null; // Phone number is valid
  }

  // Email validation method
  static String? validateEmailWithErrorText({
    required String email,
    required BuildContext context,
  }) {
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regex = RegExp(emailPattern);
    if (email.isEmpty) {
      return 'Email Is Required';
    } else if (!regex.hasMatch(email)) {
      return 'Enter A Valid Email';
    }
    return null; // Email is valid
  }

  // Phone number validation method
  static String? validatePhoneNumberWithErrorText({
    required String phoneNumber,
    required BuildContext context,
  }) {
    const phonePattern = r'^\+?\d{9,15}$'; // 10-15 digits phone number
    final regex = RegExp(phonePattern);
    if (phoneNumber.isEmpty) {
      return 'Phone Number Is Required';
    } else if (!regex.hasMatch(phoneNumber)) {
      return 'Enter A Valid Phone Number';
    }
    return null; // Phone number is valid
  }

  // Email validation method
  static String? validateEmail(String? value) {
    const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    if (!regex.hasMatch(value)) {
      return 'Неверный формат email. Пример demouser@mail.ru';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    const String passwordPattern = r'^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?![.\n]).+$';
    final regex = RegExp(passwordPattern);
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 8) {
      return 'Минимум 8 символов';
    }
    if (!regex.hasMatch(value)) {
      return 'Пароль должен содержать:\n'
          '• заглавную букву\n'
          '• строчную букву\n'
          '• цифру\n'
          '• нельзя использовать точки и переносы строк';
    }
    return null;
  }
}
