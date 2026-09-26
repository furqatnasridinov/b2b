import 'dart:async';

import 'package:b2b_seller/core/common/screens/base_url_settings.dart';
import 'package:b2b_seller/core/common/screens/error_screen.dart';
import 'package:b2b_seller/core/common/screens/main_screen.dart';
import 'package:b2b_seller/core/common/widget/custom_loader.dart';
import 'package:b2b_seller/core/resources/resources.dart';
import 'package:b2b_seller/core/services/local_data_storage.dart';
import 'package:b2b_seller/src/auth/presentation/bloc/me/me_cubit.dart';
import 'package:b2b_seller/src/auth/presentation/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const path = '/splashScreen';
  static const name = 'splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _animationCompleted = false;
  bool _navigateToBaseUrlSettings = false;
  bool _hasNavigated = false;
  MeCubitState? _completedMeState;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(_handleAnimationStatus);

    final baseUrlFromLocal = LocalDataStorage.getString(
      LocalDataStorageKeys.baseUrl,
    ).trim();
    if (baseUrlFromLocal.isEmpty) {
      _navigateToBaseUrlSettings = true;
    } else {
      unawaited(_requestCurrentUser());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _requestCurrentUser() async {
    final meCubit = context.read<MeCubit>();
    await meCubit.get();
    if (!mounted) return;

    _completedMeState = meCubit.state;
    _navigateIfReady();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;

    setState(() => _animationCompleted = true);
    _navigateIfReady();
  }

  void _navigateIfReady() {
    if (!_animationCompleted || _hasNavigated || !mounted) return;

    if (_navigateToBaseUrlSettings) {
      _hasNavigated = true;
      context.go(
        BaseUrlSettingsScreen.path,
        extra: {
          'navigatePathAfterSuccess': LoginScreen.path,
        },
      );
      return;
    }

    final state = _completedMeState;
    if (state == null) return;

    if (state.isCompleted) {
      if (state.user?.role == null) {
        _hasNavigated = true;
        context.go(
          ErrorScreen.path,
          extra: 'Роль пользователя не определена',
        );
        return;
      }
      _hasNavigated = true;
      context.go(MainScreen.path);
      return;
    }

    if (state.isFailed && state.statusCode == 401) {
      _hasNavigated = true;
      context.go(LoginScreen.path);
      return;
    }

    if (state.isFailed) {
      _hasNavigated = true;
      context.go(
        ErrorScreen.path,
        extra: state.errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // color identical with flutter native splash`s color property
    const Color bgColor = Colors.white;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // works android only
        statusBarColor: bgColor, // top
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: bgColor, // bottom
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        floatingActionButton: _animationCompleted && !_navigateToBaseUrlSettings
            ? _buildLoadingStatus()
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
        body: Center(
          child: Transform.scale(
            scale: 0.8,
            child: Lottie.asset(
              Media.rockLottie,
              decoder: LottieComposition.decodeGZip,
              controller: _controller,
              onLoaded: (composition) {
                _controller.duration = composition.duration;
                unawaited(_controller.forward());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingStatus() {
    return BlocBuilder<MeCubit, MeCubitState>(
      builder: (context, state) {
        if (!state.isLoading) return const SizedBox.shrink();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 40),
                const Spacer(),
                const Text('Загрузка профиля...'),
                const SizedBox(width: 10),
                const CustomLoader(radius: 8),
                const Spacer(),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    onPressed: () {
                      unawaited(
                        context.push(
                          BaseUrlSettingsScreen.path,
                          extra: {
                            'navigatePathAfterSuccess': SplashScreen.path,
                          },
                        ),
                      );
                    },
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.settings_rounded, size: 20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
