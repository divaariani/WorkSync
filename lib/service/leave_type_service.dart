import 'dart:convert';
import 'package:http/http.dart' as http;
import 'leave_type_model.dart';
import 'package:worksync/utils/globals.dart';

class ApiProvider {
  final String apiUrl =
      '$apiBaseUrl?function=get_status_leave'; 

  Future<LeaveTypeModel> fetchLeaveTypes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return LeaveTypeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil data tipe cuti');
    }
  }
}



