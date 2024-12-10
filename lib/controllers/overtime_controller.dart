import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class OvertimeController extends ChangeNotifier {
  late Future<List<OvertimeData>> futureData;

  OvertimeController() {
    final String? noAbsen = SessionManager().getNoAbsen();
    futureData = fetchData(noAbsen);
  }

  Future<List<OvertimeData>> fetchData(String? noAbsen) async {
    try {
      if (noAbsen == null) {
        throw Exception('No noAbsen available');
      }

      final Uri url = Uri.parse('$apiBaseUrl?function=get_list_overtime_waitapprove&noabsen=$noAbsen');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.toLowerCase().contains('application/json') != true) {
          throw Exception('Invalid content type: ${response.headers['content-type']}');
        }

        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          final List<dynamic> rawData = responseData['data'];
          return rawData.map((data) => OvertimeData.fromJson(data)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching data: $error');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOvertimeUser() async {
    final String? noAbsen = SessionManager().getNoAbsen();
    final url = '$apiBaseUrl?function=get_list_overtime&noabsen=$noAbsen';

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

  Future<void> postOvertime(String noAbsen, DateTime tglDari, DateTime tglSampai, String note) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_overtime');

      final response = await http.post(
        url,
        body: {
          'noabsen': noAbsen,
          'tgldari': DateFormat('yyyy-MM-dd HH:mm:ss').format(tglDari),
          'tglsampai': DateFormat('yyyy-MM-dd HH:mm:ss').format(tglSampai),
          'overtimenote': note,
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.toLowerCase().contains('application/json') != true) {
          throw Exception('Invalid content type: ${response.headers['content-type']}');
        }

        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('status')) {
          if (responseData['status'] == 1) {
            debugPrint('Overtime posted successfully');
          } else {
            throw Exception('Failed to post overtime: ${responseData['message']}');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to post overtime. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error posting overtime: $error');
      rethrow;
    }
  }

  Future<void> postOvertimeEdit(String ovtid, String noAbsen, DateTime tglDari, DateTime tglSampai, String note) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_overtime');

      final response = await http.post(
        url,
        body: {
          'lineuid': ovtid,
          'noabsen': noAbsen,
          'tgldari': DateFormat('yyyy-MM-dd HH:mm:ss').format(tglDari),
          'tglsampai': DateFormat('yyyy-MM-dd HH:mm:ss').format(tglSampai),
          'overtimenote': note,
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.toLowerCase().contains('application/json') != true) {
          throw Exception('Invalid content type: ${response.headers['content-type']}');
        }

        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('status')) {
          if (responseData['status'] == 1) {
            debugPrint('Overtime posted successfully');
          } else {
            throw Exception('Failed to post overtime: ${responseData['message']}');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to post overtime. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error posting overtime: $error');
      rethrow;
    }
  }

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
            debugPrint('Overtime posted successfully');
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
      debugPrint('Error posting approve: $error');
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
            debugPrint('Overtime rejected successfully');
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
      debugPrint('Error posting reject: $error');
      rethrow;
    }
  }
}

class OvertimeData {
  final String ovtId;
  final String employeeName;
  final String ovtDateStart;
  final String ovtDateEnd;
  final String ovtNoted;
  final String actionStatusPost;

  OvertimeData({
    required this.ovtId,
    required this.employeeName,
    required this.ovtDateStart,
    required this.ovtDateEnd,
    required this.ovtNoted,
    required this.actionStatusPost,
  });

  factory OvertimeData.fromJson(Map<String, dynamic> json) {
    String ovtDateStart = json['Ovt_Date_Start']?.substring(0, 16);
    String ovtDateEnd = json['Ovt_Date_End']?.substring(0, 16);

    return OvertimeData(
      ovtId: json['Ovt_Id'],
      employeeName: json['EmployeeName'],
      ovtDateStart: ovtDateStart,
      ovtDateEnd: ovtDateEnd,
      ovtNoted: json['Ovt_Noted'],
      actionStatusPost: json['Action_Status_Post'],
    );
  }
}
