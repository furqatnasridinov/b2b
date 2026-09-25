import 'package:b2b_seller/core/common/screens/base_url_settings.dart';
import 'package:b2b_seller/core/common/screens/main_screen.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/me/me_cubit.dart';
import 'package:b2b_seller/src/auth/presentation/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    this.message,
    super.key,
  });

  static const String path = '/error';
  static const String name = 'error';

  final String? message;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeCubit, MeCubitState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.isCompleted || current.isFailed),
      listener: (context, state) {
        if (state.isCompleted) {
          context.go(MainScreen.path);
          return;
        }
        if (state.isFailed && state.statusCode == 401) {
          context.go(LoginScreen.path);
        }
      },
      child: Scaffold(
        floatingActionButton: IconButton(
          onPressed: () {
            context.push(BaseUrlSettingsScreen.path);
          },
          icon: const Icon(Icons.settings),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Что-то пошло не так',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<MeCubit, MeCubitState>(
                      builder: (context, state) {
                        final cubitMessage = state.errorMessage?.trim() ?? '';
                        final extraMessage = message?.trim() ?? '';
                        final text = cubitMessage.isNotEmpty
                            ? cubitMessage
                            : (extraMessage.isNotEmpty
                                ? extraMessage
                                : 'Не удалось загрузить данные');
                        return Text(
                          text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<MeCubit, MeCubitState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: state.isLoading
                                ? null
                                : () => context.read<MeCubit>().get(),
                            child: state.isLoading
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Повторить'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
