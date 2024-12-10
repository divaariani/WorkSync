library sisap.globals;
import 'package:flutter/material.dart';

//TODO SENSOR BEFORE COMMIT
const String apiBaseUrl = '{URL-API-1}';
const String apiBaseUrl2 = '{URL-API-2}';
const String apiBaseUrl3 = '{URL-API-3}';
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
String globalBarcodeMesinResult = '';
String globalBarcodeBarangqcResult = '';
String globalBarcodeKabelResult = '';
List<String> globalBarcodeBarangResults = [];
List<String> globalBarcodeGudangResults = [];
List<String> globalBarcodeCheckpointResults = [];
List<String> globalBarcodeBarangQcResults = [];
List<String> globalBarcodeKabelResults = [];

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

void setGlobalBarcodeResult(String barcodeMachineResult) {
  globalBarcodeMesinResult = barcodeMachineResult;
}

void setGlobalKabelResult(String barcodeKabelResult) {
  globalBarcodeKabelResult = barcodeKabelResult;
}