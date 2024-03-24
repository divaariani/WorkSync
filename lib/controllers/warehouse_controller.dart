import 'package:http/http.dart' as http;
import 'dart:convert';
import 'response_model.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class WarehouseController{

  static Future<ResponseModel> postGudangOut({
    required String hasilscan,
    required String userid,
    required String mobil,

  }) async {

    final response = await http.post(
      Uri.parse('$apiBaseUrl2?function=post_do_checker'),
      body: {
        'hasilscan': hasilscan,
        'userid': userid,
        'nomobil': mobil,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to post gudang out data - Status Code: ${response.statusCode}');
    }
  }

  static Future<ResponseModel> viewGudangOut({
    required String noLot,
    required String namaBarang,
    required String merk,
    required String pack,
    required String stock,
    required String unit,
    required String status,
    required String mobil,

  }) async {
    final String? userid = SessionManager().getUserId();

    final response = await http.post(
      Uri.parse('$apiBaseUrl2?function=get_list_do_checker&userid=$userid'),
      body: {
        'NoMobil': mobil,
        'NoLot': noLot,
        'NamaBarang': namaBarang,
        'Merk': merk,
        'UnitPack': pack,
        'Stock': stock,
        'Unit': unit,
        'Status': status
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
}