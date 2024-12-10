import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'app_colors.dart';
import 'home_page.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class CableScanPage extends StatefulWidget {
  const CableScanPage({Key? key}) : super(key: key);

  @override
  State<CableScanPage> createState() => _CableScanPageState();
}

class _CableScanPageState extends State<CableScanPage> {
  Future<void> _scanBarcode() async {
    bool finishScanning = false;

    while (!finishScanning) {
      String barcodeKabelResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        AppLocalizations(globalLanguage).translate("finish"),
        true,
        ScanMode.BARCODE,
      );

      if (barcodeKabelResult == '-1') {
        navigateBack();
        return;
      }

      if (barcodeKabelResult.isNotEmpty) {
        setState(() {
          globalBarcodeKabelResults.add(barcodeKabelResult);
        });
      }

      dialogHasil(barcodeKabelResult);

      if (!finishScanning) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void navigateBack() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CableScanPage(),
      ),
    );
  }

  void dialogHasil(String barcodeBarang) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16),
            title: const Center(
              child: CircularProgressIndicator(color: AppColors.mainGreen)
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  barcodeBarang,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),        
              ],
            ),
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations(globalLanguage).translate("Scan Stock"),
          style: TextStyle(
            color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
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
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Image(image: AssetImage("assets/qrcode.png")),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            textAlign: TextAlign.center,
                            AppLocalizations(globalLanguage).translate("scanlocation"),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              await _scanBarcode();
                            },
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.white,
                                      AppColors.lightGreen
                                    ],
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 50,
                                  ),
                                  child: Text(
                                    AppLocalizations(globalLanguage).translate("scan"),
                                    style: const TextStyle(
                                      color: AppColors.deepGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}