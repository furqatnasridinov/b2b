import 'dart:async';

import 'package:b2b_seller/core/common/screens/main_screen.dart';
import 'package:b2b_seller/core/common/widget/widget.dart';
import 'package:b2b_seller/core/services/enums.dart';
import 'package:b2b_seller/core/services/validators.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:b2b_seller/src/auth/presentation/view/register_screen.dart';
import 'package:b2b_seller/src/auth/presentation/widget/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String path = '/login';
  static const String name = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Role _selectedRole = Role.seller;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    unawaited(
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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
          title: 'Вход',
          subtitle: 'Выберите роль и войдите в аккаунт',
          selectedRole: _selectedRole,
          onRoleChanged: (role) => setState(() => _selectedRole = role),
          form: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                    onFieldSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    onPressed: _login,
                    title: 'Войти',
                    height: 52,
                    isLoading: state.isLoading,
                  ),
                  if (state.isFailed) ...[
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage ?? 'Не удалось выполнить вход',
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
              const Text('Нет аккаунта?'),
              TextButton(
                onPressed: state.isLoading
                    ? null
                    : () => context.go(RegisterScreen.path),
                child: const Text('Зарегистрироваться'),
              ),
            ],
          ),
        );
      },
    );
  }
}
