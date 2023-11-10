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
      'loginSuccess' : 'Login Successful !',
      'loginSuccessMessage': 'Welcome to the WorkSync App',
      'loginFailed' : 'Login Failed !',
      'loginFailedMessage': 'Try again with your correct account',
      'register': 'Register',
      'registerDesc': 'Register to get started !',
      'welcome': 'Welcome !',
      'enterUsername' : 'Username...',
      'enterEmail' : 'Email...',
      'enterPassword' : 'Password...',
      'enterConfirmPassword' : 'Confirm password...',
      'forgotPassword': 'Forgot Password?',
      'anotherLogin' : 'or Login with',
      'anotherRegister' : 'or Register with',
      'dontHaveAccount' : "Don't have an account?",
      'alreadyHaveAccount' : "Already have an account?",
    },
    'id': {
      'languageEn': 'Inggris',
      'languageId': 'Indonesia',
      'languageKr': 'Korea',
      'choose': 'Pilih Bahasa :',
      'hello': 'Hai !',
      'helloDesc': 'Selamat datang di aplikasi monitoring aktivitas kerja Anda',
      'login': 'Masuk',
      'loginSuccess' : 'Berhasil Masuk !',
      'loginSuccessMessage': 'Selamat datang di aplikasi WorkSync',
      'loginFailed' : 'Gagal Masuk !',
      'loginFailedMessage': 'Coba lagi dengan akun yang benar',
      'register': 'Daftar',
      'registerDesc': 'Daftar untuk memulai !',
      'welcome': 'Selamat Datang !',
      'enterUsername' : 'Username...',
      'enterEmail' : 'Email...',
      'enterPassword' : 'Kata sandi...',
      'enterConfirmPassword' : 'Konfirmasi kata sandi...',
      'forgotPassword': 'Lupa kata sandi?',
      'anotherLogin' : 'atau Masuk dengan',
      'anotherRegister' : 'atau Daftar dengan',
      'dontHaveAccount' : "Belum memiliki akun?",
      'alreadyHaveAccount' : "Sudah memiliki akun?",
    },
    'ko': {
      'languageEn': '영어 (Eng)',
      'languageId': '인도네시아 (Ina)',
      'languageKr': '한국',
      'choose': '언어 선택 :',
      'hello': '안녕하세요 !',
      'helloDesc': '일하다 활동 모니터링하는 앱에 오신 것을 환영합니다',
      'login': '로그인',
      'loginSuccess' : '로그인 성공 !',
      'loginSuccessMessage': 'WorkSync앱에 환영합니다',
      'loginFailed' : '로그인 실패 !',
      'loginFailedMessage': '다른 계정으로 다시 시도하세요',
      'register': '회원가입',
      'registerDesc': '시작하려면 회원가입하세요 !',
      'welcome': '환영합니다 !',
      'enterUsername' : '아이디...',
      'enterEmail' : '이메일...',
      'enterPassword' : '비밀번호...',
      'enterConfirmPassword' : '비밀번호 확인...',
      'forgotPassword': '비밀번호 찾기?',
      'anotherLogin' : '다른 로그인',
      'anotherRegister' : '다른 회원가입',
      'dontHaveAccount' : "계정이 없는 경우?",
      'alreadyHaveAccount' : "이미 계정니 있습니다?",
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}
