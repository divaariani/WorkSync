import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:worksync/service/approve_list_leave_model.dart';
import 'package:worksync/utils/globals.dart';
import 'package:worksync/utils/session_manager.dart';

class ApprovedListLeaveService {
  late final String? noAbsen;

  ApprovedListLeaveService() {
    noAbsen = SessionManager().getNoAbsen();
  }

  String buildApiUrl() {
    return '$apiBaseUrl?function=get_list_leave_waitapprove&noabsen=$noAbsen';
  }

  Future<ApproveListLeaveModel> fetchData() async {
    final String apiUrl = buildApiUrl();
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return ApproveListLeaveModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}