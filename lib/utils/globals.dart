library worksync.globals;
import 'package:flutter/material.dart';

const String apiBaseUrl = '{API}';
const String apiBaseUrl2 = '{API}';
String globalLat = '';
String globalLong = '';
String globalLocationName = '';
String globalFaceDetection = 'Not Recognized';
String globalTheme = 'Light Theme';
Locale globalLanguage = const Locale('en', 'US');

String globalBarcodeLokasiResult = '';
String globalBarcodeMobilResult = '';
String globalBarcodeBarangResult = '';
String globalBarcodeGudangResult = '';
String globalBarcodeCheckpointResult = ''; 
String globalBarcodeScanLokasiResult = '';
List<String> globalBarcodeBarangResults = [];
List<String> globalBarcodeGudangResults = [];
List<String> globalBarcodeCheckpointResults = [];

void setGlobalBarcodeLokasiResult(String barcodeStockResult){
  globalBarcodeLokasiResult = barcodeStockResult;
}

void setGlobalBarcodeBarangResult(String barcodeBarangResult) { 
  globalBarcodeBarangResult = barcodeBarangResult;
}

void setGlobalBarcodeCheckpointResult(String barcodeCheckpointResult) {
  globalBarcodeCheckpointResult = barcodeCheckpointResult;
}

void setGlobalBarcodeMobilResult(String barcodeMobilResult) {
  globalBarcodeMobilResult = barcodeMobilResult;
}

void setGlobalBarcodeGudangResult(String barcodeGudangResult) { 
  globalBarcodeGudangResult = barcodeGudangResult;
}
