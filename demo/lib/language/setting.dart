import 'package:demo/db/setting.dart';

const defaultLanguage = 'default';

class LanguageSetting extends Setting {
  static LanguageSetting? _instance;
  static LanguageSetting get instance {
    return _instance ??= LanguageSetting._();
  }

  LanguageSetting._() : super('language');
}
