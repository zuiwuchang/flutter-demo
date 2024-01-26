import 'package:demo/language/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Language {
  final Locale locale;
  final String name;
  const Language(this.locale, this.name);
  String get id {
    return "$locale";
  }
}

class S {
  S._();
  static const supportedLocales = AppLocalizations.supportedLocales;
  static const delegate = AppLocalizations.delegate;
  static AppLocalizations of(BuildContext context) {
    final found = AppLocalizations.of(context);
    if (found == null) {
      throw Exception('AppLocalizations not found');
    }
    return found;
  }

  static const List<Language> list = <Language>[
    Language(Locale('en'), '🇺🇸 Engligh'),
    Language(Locale('zh'), '🇹🇼 正體中文'),
    Language(
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      '🇨🇳 简体中文',
    ),
  ];

  static Locale localeResolutionCallback(
      Locale? locale, Iterable<Locale>? supportedLocales) {
    Locale? result = const Locale('en');
    // 依據系統語言自動選擇合適的語言環境
    if (locale != null) {
      switch (locale.languageCode) {
        case 'zh':
          String? val = locale.countryCode?.toLowerCase();
          if (val?.contains('cn') ?? false) {
            return const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hans');
          }
          val = locale.scriptCode?.toLowerCase();
          if (val?.contains('hans') ?? false) {
            return const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hans');
          }
          result = const Locale('zh');
      }
    }
    debugPrint("localeResolutionCallback $locale -> $result");
    return result;
  }

  static Locale? get locale {
    // 如果用戶目前選擇了語言
    final choose = LanguageSetting.instance.value;
    if (choose != defaultLanguage) {
      for (var val in list) {
        // 返回查找到的用戶指定語言
        if (choose == val.id) {
          debugPrint("build locale: ${val.locale}");
          return val.locale;
        }
      }
    }
    debugPrint("build locale: null");
    return null;
  }
}
