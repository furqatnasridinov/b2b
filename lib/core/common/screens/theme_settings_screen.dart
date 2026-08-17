import 'package:b2b_seller/core/common/bloc/app_settings_cubit.dart';
import 'package:b2b_seller/core/common/entities/entities.dart';
import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  static const path = '/settings';
  static const name = 'settings';

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {

  Future<void> _setDarkTheme(bool value) async {
    await context.read<AppSettingsCubit>().setIsDarkThemeState(
      valueIsDarkTheme: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 5,
          children: [
            Text(
              'Font Family ${context.textTheme.bodyLarge?.fontFamily ?? ''}',
            ),

            // display 
            _textBlock(context.textTheme.displayLarge),
            _textBlock(context.textTheme.displayMedium),
            _textBlock(context.textTheme.displaySmall),

            // headline
            _textBlock(context.textTheme.headlineLarge),
            _textBlock(context.textTheme.headlineMedium),
            _textBlock(context.textTheme.headlineSmall),

            // title
            _textBlock(context.textTheme.titleLarge),
            _textBlock(context.textTheme.titleMedium),
            _textBlock(context.textTheme.titleMedium),

            // body
            _textBlock(context.textTheme.bodyLarge),
            _textBlock(context.textTheme.bodyMedium),
            _textBlock(context.textTheme.bodySmall),

            // label 
            _textBlock(context.textTheme.labelLarge),
            _textBlock(context.textTheme.labelMedium),
            _textBlock(context.textTheme.labelSmall), 

            // toggle 
            _darkThemeToggle(),

          ],
        ),
      ),
      
      
    );
  }

  Widget _textBlock(TextStyle? style) {
    return Row(
      children: [
        Text(
          _getStyleName(style),
          style: style,
        ),
      ],
    );
  }

  String _getStyleName(TextStyle? style){
    String result = 'error getting style name';
    try {
      result = style?.debugLabel?.split('.merge').first.split(' ')[1] ?? '';
    } catch (e) {
      return result;
    }
    return result;
  }

  Widget _darkThemeToggle() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: ListTile(
        title: Text(
          'Dark theme enabled',
          style: context.textTheme.headlineSmall,
        ),
        trailing: BlocBuilder<AppSettingsCubit, AppSettingEntity>(
          builder: (context, state) {
            return CupertinoSwitch(
              value: state.isDarkTheme,
              onChanged: _setDarkTheme,
            );
          },
        ),
      ),
    );
  }

}