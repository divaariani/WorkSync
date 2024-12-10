import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'globals.dart';
import 'localizations.dart';
import '../pages/app_colors.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        width: 1 * MediaQuery.of(context).size.width,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/monitoring.png',
              width: 50,
              height: 50,
              color: AppColors.deepGreen,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                AppLocalizations(globalLanguage).translate("nodata"),
                style: GoogleFonts.poppins(
                  color: AppColors.deepGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
