import 'package:demo/db/setting.dart';
import 'package:flutter/material.dart';

const defaultTheme = 'default';

class ThemeSetting extends Setting {
  static ThemeSetting? _instance;
  static ThemeSetting get instance {
    return _instance ??= ThemeSetting._();
  }

  ThemeSetting._() : super('theme');

  // 返回支持的主題
  get supported => const <String>[
        defaultTheme,
        'light',
        'dark',
      ];
  // 返回合適的主題數據
  ThemeData getThemeData(BuildContext context, String? name) {
    switch (name) {
      case "light":
        return ThemeData.light(useMaterial3: true);
      case 'dark':
        return ThemeData.dark(useMaterial3: true);
    }
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
  }
}
