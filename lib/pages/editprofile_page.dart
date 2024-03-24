import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'home_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String currentTheme = globalTheme;
  Locale currentLocale = globalLanguage;
  bool isLoading = false;
  
  void _changeTheme(String? newTheme) {
    if (newTheme != null) {
      setState(() {
        currentTheme = newTheme;
      });
    }
  }
  
  void _changeLanguage(Locale? newLocale) {
    if (newLocale != null) {
      setState(() {
        currentLocale = newLocale;
      });
    }
  }

  void _saveChanges() async {
    setState(() {
      isLoading = true;
    });

    try {
      setState(() {
        globalLanguage = currentLocale;
        globalTheme = currentTheme;
        SessionManager().setTheme(globalTheme);
        SessionManager().setLanguage(globalLanguage);
      });

      await Future.delayed(const Duration(seconds: 1));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 2)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("editProfile"),
            style: TextStyle(color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,),
          ),
          backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 2)),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.deepGreen, AppColors.lightGreen],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations(globalLanguage).translate("name"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset('assets/useradd.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            Text(
                              SessionManager().getNamaUser() ?? 'Unknown',
                              style: const TextStyle(color: AppColors.deepGreen, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("switchTheme"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          children: [
                            Image.asset('assets/attendancetype.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            _buildThemeDropdown()
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("language"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          children: [
                            Image.asset('assets/language.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            _buildLanguageDropdown(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Colors.white, AppColors.lightGreen],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            _saveChanges();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 50),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepGreen),
                                  )
                                : Text(
                                    AppLocalizations(globalLanguage).translate("save"),
                                    style: const TextStyle(
                                      color: AppColors.deepGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeDropdown() {
    return DropdownButton<String>(
      value: currentTheme,
      style: const TextStyle(color: AppColors.deepGreen),
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem(
          value: 'Light Theme',
          child: Text(AppLocalizations(globalLanguage).translate("Light Theme"),
              style: const TextStyle(color: AppColors.deepGreen, fontSize: 16)),
        ),
        DropdownMenuItem(
          value: 'Dark Theme',
          child: Text(AppLocalizations(globalLanguage).translate("Dark Theme"),
              style: const TextStyle(color: AppColors.deepGreen, fontSize: 16)),
        ),
      ],
      onChanged: _changeTheme,
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<Locale>(
      value: currentLocale,
      style: const TextStyle(color: AppColors.deepGreen),
      items: <DropdownMenuItem<Locale>>[
        DropdownMenuItem(
          value: const Locale('en', 'US'),
          child: Text(AppLocalizations(globalLanguage).translate("languageEn"),
              style: const TextStyle(color: AppColors.deepGreen, fontSize: 16)),
        ),
        DropdownMenuItem(
          value: const Locale('id', 'ID'),
          child: Text(AppLocalizations(globalLanguage).translate("languageId"),
              style: const TextStyle(color: AppColors.deepGreen, fontSize: 16)),
        ),
        DropdownMenuItem(
          value: const Locale('ko', 'KR'),
          child: Text(AppLocalizations(globalLanguage).translate("languageKr"),
              style: const TextStyle(color: AppColors.deepGreen, fontSize: 16)),
        ),
      ],
      onChanged: _changeLanguage,
    );
  }
}