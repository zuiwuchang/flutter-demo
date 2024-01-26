# theme

flutter 採用了 Material Design，默認帶有 dark 和 light 兩種主題

最簡單的方案是在 MyApp 的 build 方法中直接查詢系統的主題方案，然後將它設置到 MaterialApp 的 theme 屬性即可讓 ui 跟隨系統主題進行變更

```
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MediaQuery.platformBrightnessOf(context) == Brightness.dark
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}
```

# 選擇主題

如果要讓用戶選擇主題，則麻煩點

1. 需要存儲用戶設定，這可以使用 [shared_preferences](https://pub.dev/packages/shared_preferences)，它爲全平臺提供了支持
2. 需要一個廣播來通知 flutter ui 主題發生變化了，廣播可以使用 [rxdart](https://pub.dev/packages/rxdart)，它是 rxjs 的 dart 移植版本，因爲是 dart 庫所以同樣可以在全平臺使用
3. 在最外層的訂閱主題廣播並依據內容創建帶不同 ThmemeData 的 MaterialApp

  ```
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
  ```
4. 提供一個頁面供用戶選擇使用的主題 theme.dart 是一個示例

> settings.dart 中提供了一個單例 class Themes ，它包裝了廣播創建(rxdart) 和 數據持久化(shared_preferences) 相關的代碼

這個例子爲主題提供了三個選項

* **defualt** 它跟隨操作系統設定，當操作系統修改設定後會立刻跟隨系統改變主題，這是默認值通常也是大多用戶希望的表現
* **light** 使用高亮主題
* **dark** 使用暗黑主題

> 並不是所有系統都提供了主題切換的功能，所以讓用戶可以手動選擇 light/dark 還是很有必要的

得利於 Material Design 的優秀設計你也可以自定義 light/dark 外的更多主題(自定義 ThemeData 即可)，切換的主題的方式和本例類似只是需要增加更多的主題候選列表即可。但本喵通常不建議自定義主題，因爲工作量浩大且需要精心調配沒有完善強大的團隊和市場調研以及不斷是試錯改進很難調配出比 Material Design 自帶更好的效果