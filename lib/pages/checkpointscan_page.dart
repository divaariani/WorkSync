import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../utils/globals.dart';
import 'checkpoint_page.dart';
import 'app_colors.dart';
import '../controllers/response_model.dart';
import '../controllers/checkpoint_controller.dart';

class CheckPointScanPage extends StatefulWidget {
  const CheckPointScanPage({Key? key}) : super(key: key);

  @override
  State<CheckPointScanPage> createState() => _CheckPointScanPageState();
}

class _CheckPointScanPageState extends State<CheckPointScanPage> {
  
 String scannedData = ''; 

  Future<void> _scanBarcode() async {
    String barcodeCheckpointResult = '';

    barcodeCheckpointResult = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    if (barcodeCheckpointResult.isNotEmpty) {
      try {
        // Update the scanned data
        setState(() {
          scannedData = barcodeCheckpointResult;
        });

        // Call the controller with the latest scanned data
        await CheckPointController.fetchDataScan(cp_barcode: scannedData);
      } catch (e) {
        print('Error: $e');
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckPointPage(
          result: '',
          resultCheckpoint: globalBarcodeCheckpointResults,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Choose Site',
              style: TextStyle(
                color: AppColors.deepGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                      padding: const EdgeInsets.all(40),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage("assets/qrcode.png"),
                              ),
                              SizedBox(height: 160),
                              const Text(
                                textAlign: TextAlign.center,
                                "Scan QR Room Code you want to patrol",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20),
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
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 50,
                                      ),
                                      child: Text(
                                        'Scan',
                                        style: TextStyle(
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