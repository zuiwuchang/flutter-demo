# 多語言支持

flutter 提供了對 i18n 的支持，並且默認組件都已經支持了，只需要開啓功能即可

1. 增加依賴

    ```
    flutter pub add flutter_localizations --sdk=flutter
    flutter pub add intl:any
    ```

2. 在 MaterialApp 中爲 localizationsDelegates 屬性設置 flutter 的語言資源，爲 supportedLocales 屬性設置要支持的語言環境

    ```
    MaterialApp(
        localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
            Locale('en'), // English
            Locale('es'), // Spanish
        ],
    )
    ```

# 自定義內容

你可以支持自定義的本地化內容

1. 在 pubspec.yaml 中爲 flutter 區塊新增 generate 內容

    ```
    flutter:
        generate: true # Add this line
    ```

2. 在項目目錄下創建一個 l10n.yaml 檔案並寫入如下內容

    ```
    arb-dir: lib/l10n
    template-arb-file: app_en.arb
    output-localization-file: app_localizations.dart
    ```

3. 在 ${FLUTTER_PROJECT}/lib/l10n 下創建一個英文的語言資源 app_en.arb

    ```
    {
        "appTitle": "Flutter Demo",
        "@helloWorld": {
            "description": "this app main title"
        }
    }
    ```

    你可以繼續創建更多語言資源， arb 更多的詳細使用方法你可以查看[這裏](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#placeholders-plurals-and-selects)

4. `flutter pub get` 或 `flutter run` 會在 ${FLUTTER_PROJECT}/.dart_tool/flutter_gen/gen_l10n 中生成翻譯代碼

5. 在 MaterialApp 中添加語言資源

    ```
    import 'package:flutter_gen/gen_l10n/app_localizations.dart';
    ```

    ```
    MaterialApp(
        localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
    )
    ```

6. 你現在可以使用 AppLocalizations.of(context) 來訪問本地化的語言

# 語言選擇

flutter 支持了 115 種語言，通常自定義的內容很難也支持如此完整，故讓用戶能夠選擇顯示的語言很有必要。它的實現方式和[選擇主題](../theme/README.md)類似，你可以參考原理，下文直接介紹例子

1. setting.dart 代碼中的 單件 class LanguageSetting 包裝了語言廣告和持久化用戶選擇
2. s.dart 包裝了對自動生成的代碼 AppLocalizations 的訪問(更好的項目代碼提示以及一些功能設定)
3. language.dart 提供了一個例子，一個供用戶選擇使用語言的頁面
4. 在 MaterialApp 中設置 locale 屬性爲用戶選擇的語言或 null
5. 可選的設置 MaterialApp 中的 localeResolutionCallback 用於在同一語言中選擇默認的區域語言