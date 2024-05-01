import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class ApprovalsController extends ChangeNotifier {

  Future<void> postApproveOvertime(String ovtId) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_approve_overtime');

      final response = await http.post(
        url,
        body: {
          'lineuid': ovtId,
          'nstatrecord': '11'
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.toLowerCase().contains('application/json') != true) {
          throw Exception('Invalid content type: ${response.headers['content-type']}');
        }

        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('status')) {
          if (responseData['status'] == 1) {
            print('Overtime posted successfully');
          } else {
            throw Exception('Failed to approve overtime: ${responseData['message']}');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to approve overtime. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting approve: $error');
      rethrow;
    }
  }

  Future<void> postRejectOvertime(String ovtId) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_approve_overtime');

      final response = await http.post(
        url,
        body: {
          'lineuid': ovtId,
          'nstatrecord': '22'
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.toLowerCase().contains('application/json') != true) {
          throw Exception('Invalid content type: ${response.headers['content-type']}');
        }

        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('status')) {
          if (responseData['status'] == 1) {
            print('Overtime rejected successfully');
          } else {
            throw Exception('Failed to reject overtime: ${responseData['message']}');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to reject overtime. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting reject: $error');
      rethrow;
    }
  }

  Future<void> postApproveLeave(String ovtId) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_approve_overtime');

      final response = await http.post(
        url,
        body: {
          'lineuid': ovtId,
          'nstatrecord': '11'
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.toLowerCase().contains('application/json') != true) {
          throw Exception('Invalid content type: ${response.headers['content-type']}');
        }

        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('status')) {
          if (responseData['status'] == 1) {
            print('Overtime posted successfully');
          } else {
            throw Exception('Failed to approve overtime: ${responseData['message']}');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to approve overtime. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting approve: $error');
      rethrow;
    }
  }

  Future<void> postRejectLeave(String ovtId) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_approve_overtime');

      final response = await http.post(
        url,
        body: {
          'lineuid': ovtId,
          'nstatrecord': '22'
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.toLowerCase().contains('application/json') != true) {
          throw Exception('Invalid content type: ${response.headers['content-type']}');
        }

        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('status')) {
          if (responseData['status'] == 1) {
            print('Overtime rejected successfully');
          } else {
            throw Exception('Failed to reject overtime: ${responseData['message']}');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to reject overtime. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting reject: $error');
      rethrow;
    }
  }

  late final String? noAbsen;

  ApprovalsController() {
    noAbsen = SessionManager().getNoAbsen();
  }

  String buildApiUrl() {
    return '$apiBaseUrl?function=get_list_leave_waitapprove&noabsen=$noAbsen';
  }

  Future<ApprovalsStatusController> fetchData() async {
    final String apiUrl = buildApiUrl();
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return ApprovalsStatusController.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  final String apiApproveLeave = '$apiBaseUrl?function=post_approval_leave';

  Future<void> approveData(String attLeaveId, int nstatrecord) async {
    await http.post(
      Uri.parse('$apiBaseUrl?function=post_approval_leave'),
      body: {
        'lineuid': attLeaveId,
        'nstatrecord': nstatrecord.toString(),
      },
    );
  }
}

class ApprovalsStatusController {
  final int status;
  final String message;
  final List<LeaveApprovalData> data;

  ApprovalsStatusController({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApprovalsStatusController.fromRawJson(String str) =>
      ApprovalsStatusController.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApprovalsStatusController.fromJson(Map<String, dynamic> json) =>
      ApprovalsStatusController(
        status: json["status"],
        message: json["message"],
        data: List<LeaveApprovalData>.from(json["data"].map((x) => LeaveApprovalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LeaveApprovalData {
  final String attLeaveId;
  final String namaKaryawan;
  final DateTime tglAjuan;
  final String leaveDesc;
  final DateTime dari;
  final DateTime sampai;
  final String attLeaveNote;
  final String actionStatusPost;
  final String? attachment; 

  LeaveApprovalData({
    required this.attLeaveId,
    required this.namaKaryawan,
    required this.tglAjuan,
    required this.leaveDesc,
    required this.dari,
    required this.sampai,
    required this.attLeaveNote,
    required this.actionStatusPost,
    this.attachment,
  });

  factory LeaveApprovalData.fromRawJson(String str) => LeaveApprovalData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeaveApprovalData.fromJson(Map<String, dynamic> json) => LeaveApprovalData(
        attLeaveId: json["Att_Leave_Id"],
        namaKaryawan: json["NamaKaryawan"],
        tglAjuan: DateTime.parse(json["TglAjuan"]),
        leaveDesc: json["LeaveDesc"],
        dari: DateTime.parse(json["Dari"]),
        sampai: DateTime.parse(json["Sampai"]),
        attLeaveNote: json["Att_Leave_Note"],
        actionStatusPost: json["Action_Status_Post"],
        attachment: json['Att_Leave_Picture_File'] ?? "", 
      );

  Map<String, dynamic> toJson() => {
        "Att_Leave_Id": attLeaveId,
        "NamaKaryawan": namaKaryawan,
        "TglAjuan": tglAjuan.toIso8601String(),
        "LeaveDesc": leaveDesc,
        "Dari": "${dari.year.toString().padLeft(4, '0')}-${dari.month.toString().padLeft(2, '0')}-${dari.day.toString().padLeft(2, '0')}",
        "Sampai": "${sampai.year.toString().padLeft(4, '0')}-${sampai.month.toString().padLeft(2, '0')}-${sampai.day.toString().padLeft(2, '0')}",
        "Att_Leave_Note": attLeaveNote,
        "Action_Status_Post": actionStatusPost,
        "Att_Leave_Picture_File": attachment ?? "null data", 
      };
}