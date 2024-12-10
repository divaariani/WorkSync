import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'response_model.dart';
import '../utils/globals.dart';
//import '../utils/session_manager.dart';

class ReportController{
  //final String? userId = SessionManager().getUserId();
  static Future<ResponseModel> postFormData({
    required int nomorKp,
    required DateTime tglKp,
    required int userid,
    required String dibuatoleh,
    required DateTime dibuattgl,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=get_laporan_produksi_2'),
      body: {
        'nomor_kp': nomorKp.toString(),
        'tgl_kp': tglKp.toString(),
        'userid': userid.toString(),
        'dibuatoleh': dibuatoleh,
        'dibuattgl' : dibuattgl.toString(),
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      debugPrint("=======================");
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to view form data');
    }
  }

  //reportAdd
  static Future<ResponseModel> postFormDataLaporanTambah({
    required DateTime ptglkp,
    required int puserid,
    required String puid,
    required DateTime pcreatedate,
    required List<Map<String, String?>> pinventorydetails,
  }) async {
    final List<Map<String, String>> inventoryDetails = pinventorydetails
        .map((detail) => {
              'lotnumber': detail['lotnumber'] ?? '',
              'state': detail['state'] ?? '',
            })
        .toList();

    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=insert_inventory_data'),
      body: {
        'p_tgl_kp': ptglkp.toIso8601String(),
        'p_userid': puserid.toString(),
        'p_uid': puid,
        'p_createdate': pcreatedate.toIso8601String(),
        for (int i = 0; i < inventoryDetails.length; i++)
          ...{
            'p_inventory_details[$i][lotnumber]': inventoryDetails[i]['lotnumber'],
            'p_inventory_details[$i][state]': inventoryDetails[i]['state'],
          }
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to post form data');
    }
  }
}
