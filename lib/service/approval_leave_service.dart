import 'package:http/http.dart' as http;
import 'package:worksync/utils/globals.dart';

class ApiApproveLeave {
  final String apiApproveLeave = '$apiBaseUrl?function=post_approval_leave';

  Future<void> approveData(String attLeaveId, int nstatrecord) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl?function=post_approval_leave'),
      body: {
        'lineuid': attLeaveId,
        'nstatrecord': nstatrecord.toString(),
      },
    );
  }
}