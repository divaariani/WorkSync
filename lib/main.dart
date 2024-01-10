import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'pages/app_colors.dart';
import 'pages/home_page.dart';
import 'pages/nointernet_page.dart';
import 'utils/session_manager.dart';
import 'utils/globals.dart';
import 'utils//firebase_options.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sessionManager = SessionManager();
  await sessionManager.initPrefs();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
        Locale('ko', 'KR'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'WorkSync',
      theme: ThemeData(
        useMaterial3: false,
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
      home: FutureBuilder<bool>(
        future: isConnectedToInternet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: AppColors.mainGreen);
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error checking internet connection'));
          } else {
            return snapshot.data == true
              ? (isLoggedIn ? const HomePage() : const SplashScreen())
              : const NoInternetPage();
          }
        },
      ),
    );
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
