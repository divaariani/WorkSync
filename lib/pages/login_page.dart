import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'home_page.dart';
import 'app_colors.dart';
import '../controllers/login_controller.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final controller = LoginController();
  final formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  String username = '';
  String password = '';
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
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations(_currentLocale).translate("choose"), style: const TextStyle(color: AppColors.deepGreen)),
        backgroundColor: Colors.white,
        actions: <Widget>[
          _buildLanguageDropdown(),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.deepGreen, AppColors.lightGreen],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 100, bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations(globalLanguage).translate("welcome")} !',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: AppLocalizations(globalLanguage).translate("enterUsername"),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: AppLocalizations(globalLanguage).translate("enterPassword"),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {

                          if (formKey.currentState!.validate()) {
                            setState(() {
                              controller.isLoading = true;
                            });
                            final success = await controller.login(username, password);

                            setState(() {
                              controller.isLoading = false;
                            });

                            if (success) {
                              if (controller.userData.isNotEmpty) {
                                SessionManager().saveUserInfo(controller.userData);
                                SessionManager().setLoggedIn(true);
                              }

                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: AppLocalizations(globalLanguage).translate("loginSuccess"),
                                  message: AppLocalizations(globalLanguage).translate("loginSuccessMessage"),
                                  contentType: ContentType.success,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            } else {
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: AppLocalizations(globalLanguage).translate("loginFailed"),
                                  message: AppLocalizations(globalLanguage).translate("loginFailedMessage"),
                                  contentType: ContentType.failure,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          primary: Colors.transparent,
                        ),
                        child: controller.isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.grey),
                            )
                          : Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.white,
                                AppColors.lightGreen,
                              ],
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 50, minWidth: 88),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations(globalLanguage).translate("login"),
                              style: const TextStyle(color: AppColors.deepGreen),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<Locale>(
      value: _currentLocale,
      style: const TextStyle(color: AppColors.mainGreen), 
      items: <DropdownMenuItem<Locale>>[
        DropdownMenuItem(
          value: const Locale('en', 'US'),
          child: Text(AppLocalizations(_currentLocale).translate("languageEn"), style: const TextStyle(color: AppColors.mainGreen)),
        ),
        DropdownMenuItem(
          value: const Locale('id', 'ID'),
          child: Text(AppLocalizations(_currentLocale).translate("languageId"), style: const TextStyle(color: AppColors.mainGreen)),
        ),
        DropdownMenuItem(
          value: const Locale('ko', 'KR'),
          child: Text(AppLocalizations(_currentLocale).translate("languageKr"), style: const TextStyle(color: AppColors.mainGreen)),
        ),
      ],
      onChanged: _changeLanguage, 
    );
  }
}