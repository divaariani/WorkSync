import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'app_colors.dart';
import 'home_page.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class MachineMonitoringPage extends StatelessWidget {
  const MachineMonitoringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.99, -0.14),
              end: Alignment(-0.99, 0.14),
              colors: [AppColors.deepGreen, AppColors.lightGreen],
            ),
          ),
        ),
        title: Text(
            AppLocalizations(globalLanguage).translate("Machine Monitoring"),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: const WebView(
        initialUrl: 'https://bierp.sutrakabel.com/#/monitoring-machine',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}