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
      home: const SplashScreen(),
    );
  }
}
