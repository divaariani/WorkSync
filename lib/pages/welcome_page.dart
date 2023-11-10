import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'login_page.dart';
import 'register_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';

class WelcomePage extends StatefulWidget{
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>{
  Locale _currentLocale = const Locale('en', 'US');

  void _changeLanguage(Locale? newLocale) {
    if (newLocale != null) {
      setState(() {
        _currentLocale = newLocale;
        globalLanguage = newLocale; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations(_currentLocale).translate("choose"), style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.deepGreen,
        actions: <Widget>[
          _buildLanguageDropdown(),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.deepGreen, AppColors.lightGreen],
            stops: [0.1, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                AppLocalizations(_currentLocale).translate("hello"),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations(_currentLocale).translate("helloDesc"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  primary: Colors.transparent,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, AppColors.lightGreen],
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 36, minWidth: 88),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations(_currentLocale).translate("login"),
                      style: const TextStyle(color: AppColors.deepGreen),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        AppLocalizations(_currentLocale).translate("register"),
                        style: const TextStyle(color: AppColors.deepGreen),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<Locale>(
      value: _currentLocale,
      style: const TextStyle(color: Colors.white, backgroundColor: AppColors.deepGreen), 
      items: <DropdownMenuItem<Locale>>[
        DropdownMenuItem(
          value: const Locale('en', 'US'),
          child: Text(AppLocalizations(_currentLocale).translate("languageEn"), style: const TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: const Locale('id', 'ID'),
          child: Text(AppLocalizations(_currentLocale).translate("languageId"), style: const TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: const Locale('ko', 'KR'),
          child: Text(AppLocalizations(_currentLocale).translate("languageKr"), style: const TextStyle(color: Colors.white)),
        ),
      ],
      onChanged: _changeLanguage, 
    );
  }
}
