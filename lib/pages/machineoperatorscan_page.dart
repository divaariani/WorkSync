import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'machineoperator_page.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class MachineOperatorScanPage extends StatefulWidget {
  const MachineOperatorScanPage({Key? key}) : super(key: key);

  @override
  State<MachineOperatorScanPage> createState() =>
      _MachineOperatorScanPageState();
}

class _MachineOperatorScanPageState extends State<MachineOperatorScanPage> {
  Future<void> _scanBarcode() async {
    String barcodeMachineResult = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    setGlobalBarcodeResult(barcodeMachineResult);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MachineOperatorPage(barcodeMachineResult: barcodeMachineResult),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations(globalLanguage).translate("machine"),
          style: TextStyle(
            color: globalTheme == 'Light Theme'
                ? AppColors.deepGreen
                : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            globalTheme == 'Light Theme' ? Colors.white : Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: globalTheme == 'Light Theme'
                  ? AppColors.deepGreen
                  : Colors.white),
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
                            child: const Image(
                                image: AssetImage("assets/qrcode.png")),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            textAlign: TextAlign.center,
                            AppLocalizations(globalLanguage)
                                .translate("machineScan"),
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
                                    AppLocalizations(globalLanguage)
                                        .translate("scan"),
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
