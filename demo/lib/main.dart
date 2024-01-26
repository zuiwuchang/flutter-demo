import 'package:demo/language/s.dart';
import 'package:demo/language/setting.dart';
import 'package:demo/theme/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final db = await SharedPreferences.getInstance();
    // 初始化主題設定
    ThemeSetting.instance.init(db, defaultTheme);
    // 初始化語言設定
    LanguageSetting.instance.init(db, defaultLanguage);
  } catch (e) {
    debugPrint("SharedPreferences.getInstance fail: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeSetting = ThemeSetting.instance;
    // 訂閱流，依據流內容創建 MaterialApp
    return StreamBuilder(
      stream: MergeStream([
        // 合併多個廣播
        themeSetting.stream,
        LanguageSetting.instance.stream,
      ]),
      initialData: themeSetting.value,
      builder: (context, snapshot) => MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.supportedLocales,
        localeResolutionCallback: S.localeResolutionCallback,
        locale: S.locale,
        // 設置主題
        theme: themeSetting.getThemeData(context, snapshot.data),
        home: const MyHomePage(),
      ),
    );
  }
}
