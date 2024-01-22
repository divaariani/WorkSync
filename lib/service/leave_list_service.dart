import 'dart:convert';
import 'package:http/http.dart' as http;
import 'leave_list_model.dart';
import 'package:worksync/utils/globals.dart';
import 'package:worksync/utils/session_manager.dart';

class LeaveListService {
  late final String? noAbsen;

  LeaveListService() {
    noAbsen = SessionManager().getNoAbsen();
  }

  String buildApiUrl() {
    return '$apiBaseUrl?function=get_list_leave&noabsen=$noAbsen';
  }

  Future<LeaveListModel> fetchData() async {
    final String apiUrl = buildApiUrl();
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return LeaveListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}