import 'package:http/http.dart' as http;
import 'dart:convert';
import 'response_model.dart';
import '../utils/globals.dart';
//import '../utils/session_manager.dart';

class ReportController{
  //final String? userId = SessionManager().getUserId();
  static Future<ResponseModel> postFormData({
    required int nomor_kp,
    required DateTime tgl_kp,
    required int userid,
    required String dibuatoleh,
    required DateTime dibuattgl,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=get_laporan_produksi_2'),
      body: {
        'nomor_kp': nomor_kp.toString(),
        'tgl_kp': tgl_kp.toString(),
        'userid': userid.toString(),
        'dibuatoleh': dibuatoleh,
        'dibuattgl' : dibuattgl.toString(),
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      print("=======================");
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to view form data');
    }
  }

  //reportAdd
  static Future<ResponseModel> postFormDataLaporanTambah({
    required DateTime p_tgl_kp,
    required int p_userid,
    required String p_uid,
    required DateTime p_createdate,
    required List<Map<String, String?>> p_inventory_details,
  }) async {
    final List<Map<String, String>> inventoryDetails = p_inventory_details
        .map((detail) => {
              'lotnumber': detail['lotnumber'] ?? '',
              'state': detail['state'] ?? '',
            })
        .toList();

    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=insert_inventory_data'),
      body: {
        'p_tgl_kp': p_tgl_kp.toIso8601String(),
        'p_userid': p_userid.toString(),
        'p_uid': p_uid,
        'p_createdate': p_createdate.toIso8601String(),
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
