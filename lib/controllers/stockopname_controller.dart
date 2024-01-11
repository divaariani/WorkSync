import 'package:http/http.dart' as http;
import 'dart:convert';
import 'response_model.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class StockOpnameController{
  final String? userId = SessionManager().getUserId();

  static Future<ResponseModel> viewData({
    required String Lokasi,
    required String NoLot,
    required String NamaBarang,
    required String Merk,
    required String Stock,
    required String Unit,
    required String Status,

  }) async {
    final String? userId = SessionManager().getUserId();
    final response = await http.post(
      Uri.parse('$apiBaseUrl2?function=get_list_stockopname&userid=$userId'),
      body: {
        'Lokasi': Lokasi,
        'NoLot': NoLot,
        'NamaBarang': NamaBarang,
        'Merk': Merk,
        'Stock': Stock,
        'Unit': Unit,
        'Status': Status,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to view form data - Status Code: ${response.statusCode}');
    }
  }

  static Future<ResponseModel> postConfirmStock({
    required String userid,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl2?function=post_hasilopname'),
      body: {
        'userid': userid,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to post form data');
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
      throw Exception('Failed to view form data - Status Code: ${response.statusCode}');
    }
  }
}
