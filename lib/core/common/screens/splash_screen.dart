import 'package:b2b_seller/core/common/screens/screens.dart';
import 'package:b2b_seller/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        body: Center(
          child: Transform.scale(
            scale: 0.8,
            child: Lottie.asset(
              Media.rockLottie,
              decoder: LottieComposition.decodeGZip,
              controller: _controller,
              onLoaded: (composition) async {
                _controller
                  ..duration = composition.duration
                  ..forward().then(
                    (value) {
                      context.go(SnackbarCustomizationScreen.path);
                    },
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
