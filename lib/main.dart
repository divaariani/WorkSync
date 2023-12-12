import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'splash_screen.dart';
import 'utils/session_manager.dart';
import 'utils/globals.dart';
import 'pages/app_colors.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sessionManager = SessionManager();
  await sessionManager.initPrefs();

  final isLoggedIn = await sessionManager.isLoggedIn();
  final savedTheme = sessionManager.getTheme();
  final savedLanguage = sessionManager.getLanguage(); 

  globalTheme = savedTheme;  
  globalLanguage = savedLanguage; 

  runApp(WorkSyncApp(isLoggedIn: isLoggedIn, savedTheme: savedTheme));
}

class WorkSyncApp extends StatelessWidget {
  final bool isLoggedIn;
  final String savedTheme;

  const WorkSyncApp({Key? key, required this.isLoggedIn, required this.savedTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('id', 'ID'),
        Locale('ko', 'KR'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'WorkSync',
      theme: ThemeData(
        primaryColor: AppColors.lightGreen, 
        primarySwatch: const MaterialColor(
          0xFF93B1A6,
          <int, Color>{
            50: AppColors.lightGreen,
            100: AppColors.lightGreen,
            200: AppColors.lightGreen,
            300: AppColors.lightGreen,
            400: AppColors.lightGreen,
            500: AppColors.lightGreen,
            600: AppColors.lightGreen,
            700: AppColors.lightGreen,
            800: AppColors.lightGreen,
            900: AppColors.lightGreen,
          },
        ),
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme), 
      ),
      home: isLoggedIn ? const HomePage() : const SplashScreen(),
    );
  }
}
