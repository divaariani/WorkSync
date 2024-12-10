import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import 'response_model.dart';

class CheckPointController {

  Future<List<Map<String, dynamic>>> fetchCheckPointUser() async {
    final String? userId = SessionManager().getUserId();
    final url = '$apiBaseUrl?function=get_list_checkpoint_tour&userid=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 1) {
          final List<Map<String, dynamic>> overtimeList = List.from(data['data']);
          return overtimeList;
        } else {
          debugPrint('API Error: ${data['message']}');
          return [];
        }
      } else {
        debugPrint('HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return [];
    }
  }

   static Future<ResponseModel> fetchDataScan({required String cpBarcode, required String cpNote}) async {
    SessionManager sessionManager = SessionManager();
    String? userIdString = sessionManager.getUserId();

    if (userIdString == null) {
      throw Exception('User ID tidak tersedia.');
    }

    int userId = int.parse(userIdString);

    final response = await http.post(
      Uri.parse('$apiBaseUrl?function=post_checkpoint_tour'), 
      body: {
        'userid': userId.toString(),
        'cp_barcode': cpBarcode,
        'cp_whattodo': cpNote
      },
    );

    debugPrint(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Gagal upload data');
    }
  }
}
