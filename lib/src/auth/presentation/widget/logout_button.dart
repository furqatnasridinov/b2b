import 'dart:async';

import 'package:b2b_seller/core/common/widget/custom_loader.dart';
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
        final colors = Theme.of(context).colorScheme;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: state.isLoading
              ? null
              : () => unawaited(context.read<LogOutCubit>().logOut()),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.error.withValues(alpha: 0.18),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: state.isLoading
                          ? CustomLoader(
                              radius: 8,
                              color: colors.error,
                            )
                          : Icon(
                              Icons.logout_rounded,
                              color: colors.error,
                              size: 22,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Выйти',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(
                            color: colors.error,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colors.error.withValues(alpha: 0.65),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
