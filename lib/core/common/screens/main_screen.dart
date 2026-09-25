import 'package:b2b_seller/core/common/screens/base_url_settings.dart';
import 'package:b2b_seller/src/auth/presentation/widget/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const path = '/';
  static const name = 'main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          context.push(BaseUrlSettingsScreen.path);
        },
        icon: const Icon(Icons.settings),
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Главная'),
              SizedBox(height: 24),
              LogOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
