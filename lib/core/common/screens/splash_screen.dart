import 'package:b2b_seller/core/common/screens/error_screen.dart';
import 'package:b2b_seller/core/common/screens/main_screen.dart';
import 'package:b2b_seller/core/resources/resources.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleMeState(BuildContext context, MeCubitState state) {
    if (state.isCompleted) {
      context.go(MainScreen.path);
      return;
    }
    if (!state.isFailed) return;

    if (state.statusCode == 401) {
      context.go(LoginScreen.path);
      return;
    }

    context.go(
      ErrorScreen.path,
      extra: state.errorMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    // color identical with flutter native splash`s color property
    const Color bgColor = Colors.white;
    return BlocListener<MeCubit, MeCubitState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.isCompleted || current.isFailed),
      listener: _handleMeState,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          // works android only
          statusBarColor: bgColor, // top
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: bgColor, // bottom
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: bgColor,
          body: Center(
            child: Transform.scale(
              scale: 0.8,
              child: Lottie.asset(
                Media.rockLottie,
                decoder: LottieComposition.decodeGZip,
                controller: _controller,
                onLoaded: (composition) async {
                  _controller.duration = composition.duration;
                  await _controller.forward();
                  if (!context.mounted) return;
                  await context.read<MeCubit>().get();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
