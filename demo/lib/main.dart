import 'package:demo/theme/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final db = await SharedPreferences.getInstance();
    // 加載主題設定
    Themes.instance.load(db);
  } catch (e) {
    debugPrint("SharedPreferences.getInstance fail: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themes = Themes.instance;
    // 訂閱流，依據流內容創建 MaterialApp
    return StreamBuilder(
      stream: themes.stream,
      initialData: themes.value,
      builder: (context, snapshot) => MaterialApp(
        title: 'Flutter Demo',
        // 設置主題
        theme: themes.getThemeData(context, snapshot.data),
        home: const MyHomePage(),
      ),
    );
  }
}
