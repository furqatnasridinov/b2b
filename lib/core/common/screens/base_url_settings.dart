import 'dart:async';

import 'package:b2b_seller/core/common/screens/splash_screen.dart';
import 'package:b2b_seller/core/common/widget/base_url_examples_sheet.dart';
import 'package:b2b_seller/core/common/widget/primary_button.dart';
import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:b2b_seller/core/injection/instances/dio_http_client.dart';
import 'package:b2b_seller/core/services/app_snackbar.dart';
import 'package:b2b_seller/core/services/local_data_storage.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/health_check/health_check_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BaseUrlSettingsScreen extends StatefulWidget {
  const BaseUrlSettingsScreen({
    super.key,
    this.navigatePathAfterSuccess,
  });

  static const path = '/base-url-settings';
  static const name = 'base-url-settings';

  final String? navigatePathAfterSuccess;

  @override
  State<BaseUrlSettingsScreen> createState() => _BaseUrlSettingsScreenState();
}

class _BaseUrlSettingsScreenState extends State<BaseUrlSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _apiBaseUrlController;
  late bool _isFromSplash;
  int _titleTapCount = 0;
  Timer? _titleTapTimer;

  @override
  void initState() {
    super.initState();
    _isFromSplash =
        LocalDataStorage.getString(LocalDataStorageKeys.baseUrl).isEmpty;
    _apiBaseUrlController = TextEditingController(
      text: LocalDataStorage.getString(LocalDataStorageKeys.baseUrl).trim(),
    );
  }

  @override
  void dispose() {
    _apiBaseUrlController.dispose();
    super.dispose();
  }

  void _onTitleTap() {
    _titleTapCount++;
    _titleTapTimer?.cancel();
    if (_titleTapCount >= 3) {
      _titleTapCount = 0;
      unawaited(_showBaseUrlExamples());
      return;
    }
    _titleTapTimer = Timer(const Duration(milliseconds: 450), () {
      _titleTapCount = 0;
    });
  }

  Future<void> _showBaseUrlExamples() async {
    unawaited(HapticFeedback.selectionClick());
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        minWidth: context.width,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (sheetContext) {
        return BaseUrlExamplesBottomSheet(
          onSelect: (url) {
            _apiBaseUrlController.text = url;
            unawaited(_save());
          },
        );
      },
    );
  }

  String? _baseUrlValidator(String? value) {
    final normalized = (value ?? '').trim();
    if (normalized.isEmpty) {
      return 'Введите base url';
    }
    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'Некорректный URL';
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return 'URL должен начинаться с http или https';
    }
    if (normalized.endsWith('/')) {
      return 'URL не должен заканчиваться на /';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final normalized = _apiBaseUrlController.text.trim();
    await context.read<HealthCheckCubit>().healthCheck(normalized);
  }

  Future<void> _persistBaseUrl(String normalized) async {
    await LocalDataStorage.setString(LocalDataStorageKeys.baseUrl, normalized);
    DioHttpClient.refreshInstance();
    if (!mounted) {
      return;
    }

    unawaited(HapticFeedback.mediumImpact());
    AppSnackBar.showInfo(
      context,
      message: _isFromSplash ? 'Сервер доступен' : 'Сервер сохранён!',
      displayDuration: const Duration(milliseconds: 1000),
    );

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) {
        return;
      }
    if (widget.navigatePathAfterSuccess != null) {
      final path = widget.navigatePathAfterSuccess!;
      if (path == SplashScreen.path) {
        context.go(
          '/splashScreen?t=${DateTime.now().millisecondsSinceEpoch}',
        );
      } else {
        context.go(path);
      }
    } else {
      context.pop();
    }
  }

  // Future<void> _scanQrCode() async {
  //   final scanned = await context.push<String>(ScannerScreen.path);
  //   if (scanned != null && scanned.isNotEmpty && mounted) {
  //     setState(() => _apiBaseUrlController.text = scanned);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return BlocListener<HealthCheckCubit, HealthCheckState>(
      listenWhen: (previous, current) =>
          previous.status != current.status && !current.isLoading,
      listener: (context, state) {
        if (state.isCompleted) {
          unawaited(_persistBaseUrl(state.connectedUrl ?? ''));
        } else if (state.isFailed) {
          AppSnackBar.showError(
            context,
            message: state.errorMessage ?? 'Не удалось подключиться к серверу',
          );
        }
      },
      child: Scaffold(
      appBar: AppBar(
          title: GestureDetector(
            onTap: _onTitleTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              _isFromSplash ? 'Подключение к серверу' : 'Адрес сервера',
              style: context.textTheme.titleMedium,
            ),
          ),
          centerTitle: true,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          foregroundColor: colorScheme.onSurface,
        ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              24,
            ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isFromSplash
                      ? 'Введите адрес сервера вручную или отсканируйте QR-код, '
                          'чтобы начать работу с приложением.'
                      : 'Базовый URL сохраняется локально и используется '
                          'для всех сетевых запросов.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _apiBaseUrlController,
                  validator: _baseUrlValidator,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    hintText: 'Например: http://192.168.20.96:8002',
                    /* hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                    ), */
                    //prefixIcon: const Icon(Icons.link_rounded),
                    //filled: true,
                    //fillColor: colorScheme.surfaceContainerHighest.withValues(
                    //  alpha: 0.35,
                    //),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _OrDivider(color: colorScheme.outlineVariant),
                const SizedBox(height: 28),
                Material(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.35,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.qr_code_scanner_rounded,
                              size: 28,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Сканировать QR-код',
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Быстрое подключение без ручного ввода',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                16,
              ),
            child: BlocBuilder<HealthCheckCubit, HealthCheckState>(
              builder: (context, state) {
                final bool showWelcomeText = state.isCompleted && _isFromSplash;
                return PrimaryButton(
                  onPressed: showWelcomeText ? (){} : _save,
                  isLoading: state.isLoading,
                  isDisabled: showWelcomeText,
                    title: showWelcomeText
                        ? 'Добро пожаловать!'
                        : (_isFromSplash ? 'Продолжить' : 'Сохранить'),
                );
              },
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'или',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}
