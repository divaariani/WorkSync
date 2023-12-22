library worksync.globals;
import 'package:flutter/material.dart';

const String apiBaseUrl = '{API}';
const String apiBaseUrl2 = '{API}';
String globalLat = '';
String globalLong = '';
String globalLocationName = '';
Locale globalLanguage = const Locale('en', '');

String globalBarcodeLokasiResult = '';
String globalBarcodeBarangResult = '';
String globalBarcodeCheckpointResult = ''; 
String globalBarcodeScanLokasiResult = '';
List<String> globalBarcodeBarangResults = [];
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
