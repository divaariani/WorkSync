import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:worksync/utils/globals.dart';
import 'package:worksync/utils/session_manager.dart';

class ApiEditSubmitLeave {
  late final String? noAbsen;

  ApiEditSubmitLeave() {
    noAbsen = SessionManager().getNoAbsen();
  }

  final String apiEditSubmitLeave = '$apiBaseUrl?function=post_leave';

  Future<void> submitEditData(
    String attLeaveId,
    String noAbsen,
    String idLeaveType,
    String startDate,
    String endDate,
    String leavenote,
    String attachment,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(apiEditSubmitLeave),
        body: {
          'lineuid': attLeaveId,
          'noabsen': noAbsen,
          'statleave': idLeaveType,
          'tgldari': startDate,
          'tglsampai': endDate,
          'leavenote': leavenote,
          'attachment': attachment,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('submit leave success');
      } else {
        throw Exception('Failed to submit leave');
      }
    } catch (error) {
      print('Error submitting leave data: $error');
      throw Exception('Failed to submit leave');
    }
  }
}