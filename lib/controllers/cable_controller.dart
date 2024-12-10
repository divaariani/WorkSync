import 'package:http/http.dart' as http;
import 'dart:convert';
import 'response_model.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class CableController{
  static Future<ResponseModel> viewData() async {
    final String? userId = SessionManager().getUserId();
    final response = await http.get(
      Uri.parse('$apiBaseUrl2?function=get_list_kp&userid=$userId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to view data - Status Code: ${response.statusCode}');
    }
  }

  static Future<ResponseModel> postFormStock({
    required String hasilscan,
    required String userid,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl2?function=post_kp_scan'),
      body: {
        'hasilscan': hasilscan,
        'userid': userid,
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