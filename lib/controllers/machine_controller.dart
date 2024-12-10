import 'package:http/http.dart' as http;
import 'dart:convert';
import 'response_model.dart';
import '../utils/globals.dart';

class MachineController{

  static Future<ResponseModel> postOperatorInOut({
    required int idwc,
    required int userId,
    required String oprTap,
    required String tap,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=absensi_operator_id_2'),
      body: {
        'idwc': idwc.toString(),
        'userid': "20",
        'oprtap': oprTap,
        'tap': tap,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to post form data');
    }
  }

  static Future<ResponseModel> postFormOperator({
    required int id,
    required String name,
    required int userId,
    required String namaoperator,
    required String statusmesin,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=get_workcenter_list'),
      body: {
        'id': id.toString(),
        'name': name,
        'userid': "20",
        'namaoperator': "diva",
        'statusmesin': statusmesin,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to post form data');
    }
  }

  static Future<ResponseModel> postFormMachineState({
    required int id,
    required String state,
    required String timestate,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl3?function=insert_machine_status'),
      body: {
        'pidworkcenter': id.toString(),
        'pstatus': state,
        'pstatustime': timestate,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body); 
      return ResponseModel.fromJson(responseData);
    } else {
      throw Exception('Failed to post form data');
    }
  }

  static Future<Map<String, dynamic>> getWorkcenterList() async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl3?function=get_workcenter_list'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }
}