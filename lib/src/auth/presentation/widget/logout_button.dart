import 'dart:async';

import 'package:b2b_seller/core/common/widget/primary_button.dart';
import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:b2b_seller/core/injection/injection.dart';
import 'package:b2b_seller/core/services/app_snackbar.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/logout/logout_cubit.dart';
import 'package:b2b_seller/src/auth/presentation/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LogOutCubit>(),
      child: const _LogOutButtonContent(),
    );
  }
}

class _LogOutButtonContent extends StatelessWidget {
  const _LogOutButtonContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state.isCompleted) {
          context.go(LoginScreen.path);
        } else if (state.isFailed) {
          AppSnackBar.showError(
            context,
            message: state.errorMessage ?? 'Не удалось выйти из аккаунта',
          );
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              onPressed: () {
                unawaited(context.read<LogOutCubit>().logOut());
              },
              title: 'Выйти',
              width: 180,
              height: 48,
              isLoading: state.isLoading,
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
            ),
            if (state.isFailed) ...[
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'Не удалось выйти из аккаунта',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
