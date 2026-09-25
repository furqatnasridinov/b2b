import 'dart:async';

import 'package:b2b_seller/core/common/screens/main_screen.dart';
import 'package:b2b_seller/core/common/widget/widget.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/services/validators.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:b2b_seller/src/auth/presentation/view/login_screen.dart';
import 'package:b2b_seller/src/auth/presentation/widget/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String path = '/register';
  static const String name = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Role _selectedRole = Role.supplier;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _requiredName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Обязательное поле';
    }
    if (value.trim().length < 2) {
      return 'Минимум 2 символа';
    }
    return null;
  }

  String? _confirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  void _register() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    unawaited(
      context.read<AuthCubit>().register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state.isCompleted) {
          unawaited(HapticFeedback.mediumImpact());
          context.go(MainScreen.path);
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          title: 'Регистрация',
          subtitle: 'Выберите роль и создайте аккаунт',
          selectedRole: _selectedRole,
          onRoleChanged: (role) => setState(() => _selectedRole = role),
          form: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextfield(
                          controller: _firstNameController,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.givenName],
                          validator: _requiredName,
                          labelText: 'Имя',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextfield(
                          controller: _lastNameController,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.familyName],
                          validator: _requiredName,
                          labelText: 'Фамилия',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    validator: (value) =>
                        Validators.validatePhoneNumber(value ?? ''),
                    labelText: 'Телефон',
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.validateEmail,
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    controller: _passwordController,
                    label: 'Пароль',
                    validator: Validators.validatePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Повторите пароль',
                    validator: _confirmPassword,
                    onFieldSubmitted: (_) => _register(),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    onPressed: _register,
                    title: 'Создать аккаунт',
                    height: 52,
                    isLoading: state.isLoading,
                  ),
                  if (state.isFailed) ...[
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Не удалось создать аккаунт',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Уже есть аккаунт?'),
              TextButton(
                onPressed: state.isLoading
                    ? null
                    : () => context.go(LoginScreen.path),
                child: const Text('Войти'),
              ),
            ],
          ),
        );
      },
    );
  }
}
