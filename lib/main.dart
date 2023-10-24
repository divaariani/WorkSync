import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';
import 'pages/app_colors.dart';

void main() {
  runApp(const WorkSyncApp());
}

class WorkSyncApp extends StatelessWidget {
  const WorkSyncApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorkSync',
      theme: ThemeData(
        primaryColor: AppColors.lightBrown, 
        primarySwatch: const MaterialColor(
          0xFF8D6E63,
          <int, Color>{
            50: AppColors.lightBrown,
            100: AppColors.lightBrown,
            200: AppColors.lightBrown,
            300: AppColors.lightBrown,
            400: AppColors.lightBrown,
            500: AppColors.lightBrown,
            600: AppColors.lightBrown,
            700: AppColors.lightBrown,
            800: AppColors.lightBrown,
            900: AppColors.lightBrown,
          },
        ),
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme), 
      ),
      home: const SplashScreen(),
    );
  }
}
