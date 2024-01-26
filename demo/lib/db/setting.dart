import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Setting {
  final String key;
  Setting(this.key);
  final _subject = PublishSubject<String>();
  String _value = '';
  SharedPreferences? _db;
  //  初始化
  void init(SharedPreferences db, String defaultValue) {
    String? val;
    try {
      val = db.getString(key);
    } catch (e) {
      debugPrint("load $key fail: $e");
    }
    if (val == null) {
      debugPrint("load $key default: $defaultValue");
      _value = defaultValue;
    } else {
      debugPrint("load $key: $val");
      _value = val;
    }
    _db = db;
  }

  // 返回當前設定
  String get value {
    return _value;
  }

  // 存儲設定
  set value(String val) {
    if (_value == val) {
      return;
    }
    _value = val;
    if (_db != null) {
      _save(val);
    }
    _subject.add(val);
  }

  // 返回設定廣播
  Stream<String> get stream {
    return _subject.stream;
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
        await _db!.setString(key, val);
        debugPrint("save $key=$val");
      } catch (e) {
        debugPrint("save $key fail: $val $e");
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
