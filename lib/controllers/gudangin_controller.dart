import 'package:http/http.dart' as http;
import 'dart:convert';
import 'response_model.dart';
import '../utils/globals.dart';

class GudangInController{

  //menampilkan database Gudang In pada table
  static Future<ResponseModel> viewGudangIn({
    required String checked,
    required int id,
    required DateTime tgl_kp,
    required String lotnumber,
    required String namabarang,
    required int qty,
    required String uom,
  }) async {
    //final String? userid = SessionManager().getUserId();

    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=get_warehouse_views_in'),
      body: {
        'checked': checked,
        'id': id.toString(),
        'tgl_kp': tgl_kp.toIso8601String(),
        'lotnumber': lotnumber,
        'name': namabarang,
        'qty': qty.toString(),
        'state': uom,
      },
    );
    
    print('${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      print("=======================");
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to view gudang data');
    }
  }

  //Update Status Gudang In
  static Future<ResponseModel> updateWarehouseInScan({required String lotnumber}) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=update_warehouse_in_scan'),
      body: {
        'lotnumber': lotnumber,
      },
    );

    print('${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Gagal mengupdate data gudang');
    }
  }

  //Upload Data Gudang In
  Future<Map<String, dynamic>> uploadDataToGudang() async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl3?function=update_warehouse_in_upload'), 
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body); 
        return responseData;
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
