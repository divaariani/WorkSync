import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'choose': 'Choose Language :',
      'languageEn': 'English',
      'languageId': 'Indonesian',
      'languageKr': 'Korean',
      'hello': 'Hello !',
      'helloDesc': 'Welcome to the app to monitor your work activity',
      'login': 'Login',
      'register': 'Register',
    },
    'id': {
      'languageEn': 'Inggris',
      'languageId': 'Indonesia',
      'languageKr': 'Korea',
      'choose': 'Pilih Bahasa :',
      'hello': 'Hai !',
      'helloDesc': 'Selamat datang di aplikasi monitoring aktivitas kerja Anda',
      'login': 'Masuk',
      'register': 'Daftar',
    },
    'ko': {
      'languageEn': '영어',
      'languageId': '인도네시아',
      'languageKr': '한국',
      'choose': '언어 선택 :',
      'hello': '안녕하세요 !',
      'helloDesc': '일하다 활동 모니터링하는 앱에 오신 것을 환영합니다',
      'login': '로그인',
      'register': '회원가입',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}