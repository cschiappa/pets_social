import 'package:flutter/material.dart';
import 'package:pets_social/core/utils/language.g.dart';

List<Locale> supportedLocales = const [
  Locale('en', 'GB'),
  Locale('de', 'DE'),
  Locale('pt', 'PT'),
  Locale('es', 'ES'),
  Locale('ko', 'KR'),
  Locale('ru', 'RU'),
  Locale('zh', 'CN'),
];

List<String> languagesOriginal = const [
  'English',
  'Deutsch',
  'Português',
  'Español',
  '한국어',
  'Русский',
  '简体中文',
];

List<String> languagesTranslated = [
  LocaleKeys.english,
  LocaleKeys.german,
  LocaleKeys.portuguese,
  LocaleKeys.spanish,
  LocaleKeys.korean,
  LocaleKeys.russian,
  LocaleKeys.chinese,
];

class LiquidKeys {
  static const liquidKey1 = Key('__LIQUIDKEY1__');
  static const liquidKey2 = Key('__LIQUIDKEY2__');
  static const liquidKey3 = Key('__LIQUIDKEY3__');
  static const liquidKey4 = Key('__LIQUIDKEY4__');
}
