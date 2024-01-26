import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Themes {
  static Themes? _instance;
  static Themes get instance {
    return _instance ??= Themes._();
  }

  Themes._();

  // 返回支持的主題
  get supported => const <String>[
        'default',
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

  final _subject = BehaviorSubject<String>()..add('default');

  // 返回當前主題
  String get value {
    return _subject.value;
  }

  // 設置主題
  set value(String val) {
    if (_subject.value == val) {
      return;
    }
    _save(val);
    _subject.add(val);
  }

  // 返回主題廣播
  ValueStream<String> get stream {
    return _subject.stream;
  }

  //  加載設定
  load(SharedPreferences db) {
    String? theme;
    try {
      theme = db.getString('theme');
    } catch (e) {
      debugPrint("load theme fail: $e");
    }
    value = theme ?? 'default';
  }

  String? _saveValue;
  // 存儲設定
  Future<void> _save(String val) async {
    if (_saveValue == val) {
      // 正在存儲同樣的值
      return;
    }
    _saveValue = val;
    while (_saveValue != null) {
      try {
        final db = await SharedPreferences.getInstance();
        await db.setString('theme', val);
        debugPrint("save theme=$val");
      } catch (e) {
        debugPrint("save theme fail: $val $e");
      } finally {
        if (_saveValue == val) {
          _saveValue = null;
        } else if (_saveValue != null) {
          val = _saveValue!;
        }
      }
    }
  }
}
