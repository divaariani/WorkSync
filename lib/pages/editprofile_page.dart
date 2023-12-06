import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'refresh_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String selectedThemeType = 'Light Theme';
  Locale _currentLocale = globalLanguage;

  void _changeLanguage(Locale? newLocale) {
    if (newLocale != null) {
      setState(() {
        _currentLocale = newLocale;
      });
    }
  }

  void _saveChanges() {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => const RefreshHomepage()
      )
    );

    setState(() {
      globalLanguage = _currentLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("Edit Profile"),
            style: const TextStyle(color: AppColors.deepGreen, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.deepGreen),
            onPressed: () {
              Navigator.of(context).pop();
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
                              SessionManager().namaUser ?? 'Unknown',
                              style: const TextStyle(color: AppColors.deepGreen),
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
                            DropdownButton<String>(
                              value: selectedThemeType,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedThemeType = newValue;
                                  });
                                }
                              },
                              items: <String>['Light Theme', 'Dark Theme']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: AppColors.deepGreen)),
                                );
                              }).toList(),
                            ),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 50),
                            child: Text(
                              AppLocalizations(globalLanguage)
                                  .translate("save"),
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
        ));
  }

  Widget _buildLanguageDropdown() {
    return DropdownButton<Locale>(
      value: _currentLocale,
      style: const TextStyle(color: AppColors.deepGreen),
      items: <DropdownMenuItem<Locale>>[
        DropdownMenuItem(
          value: const Locale('en', 'US'),
          child: Text(AppLocalizations(globalLanguage).translate("languageEn"),
              style: const TextStyle(color: AppColors.deepGreen)),
        ),
        DropdownMenuItem(
          value: const Locale('id', 'ID'),
          child: Text(AppLocalizations(globalLanguage).translate("languageId"),
              style: const TextStyle(color: AppColors.deepGreen)),
        ),
        DropdownMenuItem(
          value: const Locale('ko', 'KR'),
          child: Text(AppLocalizations(globalLanguage).translate("languageKr"),
              style: const TextStyle(color: AppColors.deepGreen)),
        ),
      ],
      onChanged: _changeLanguage,
    );
  }
}
