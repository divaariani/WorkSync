import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';

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
        primaryColor: const Color(0xFFE2E3D5), 
        primarySwatch: const MaterialColor(
          0xFFE2E3D5,
          <int, Color>{
            50: Color(0xFFE2E3D5),
            100: Color(0xFFE2E3D5),
            200: Color(0xFFE2E3D5),
            300: Color(0xFFE2E3D5),
            400: Color(0xFFE2E3D5),
            500: Color(0xFFE2E3D5),
            600: Color(0xFFE2E3D5),
            700: Color(0xFFE2E3D5),
            800: Color(0xFFE2E3D5),
            900: Color(0xFFE2E3D5),
          },
        ),
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme), 
      ),
      home: const SplashScreen(),
    );
  }
}