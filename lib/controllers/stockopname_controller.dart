import 'package:http/http.dart' as http;
import 'dart:convert';
import 'response_model.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class StockOpnameController{
  static Future<ResponseModel> viewData({
    required String lokasi,
    required String noLot,
    required String namaBarang,
    required String merk,
    required String stock,
    required String unit,
    required String status,
  }) async {
    final String? userId = SessionManager().getUserId();
    final response = await http.post(
      Uri.parse('$apiBaseUrl2?function=get_list_stockopname&userid=$userId'),
      body: {
        'Lokasi': lokasi,
        'NoLot': noLot,
        'NamaBarang': namaBarang,
        'Merk': merk,
        'Stock': stock,
        'Unit': unit,
        'Status': status,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to view data - Status Code: ${response.statusCode}');
    }
  }

  static Future<ResponseModel> postConfirmStock() async {
    final String? userId = SessionManager().getUserId();

    final response = await http.post(
      Uri.parse('$apiBaseUrl2?function=post_hasilopname'),
      body: {
        'userid': userId,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to post confirm data');
    }
  }

  static Future<ResponseModel> postFormStock({
    required String hasilscan,
    required String userid,
    required String lokasi,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl2?function=post_stockopname'),
      body: {
        'hasilscan': hasilscan,
        'userid': userid,
        'lokasi': lokasi,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to post data - Status Code: ${response.statusCode}');
    }
  }
}