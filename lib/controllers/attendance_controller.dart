import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class AttendanceController extends ChangeNotifier {
  late Future<List<AttendanceData>> futureData;

  AttendanceController() {
    final String? noAbsen = SessionManager().noAbsen;
    futureData = fetchData(noAbsen);
  }

  Future<List<AttendanceData>> fetchData(String? noAbsen) async {
    try {
      if (noAbsen == null) {
        throw Exception('No noAbsen available');
      }

      final Uri url = Uri.parse('$apiBaseUrl?function=get_absensi&noabsen=$noAbsen');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> rawData = json.decode(response.body)['data'];
        return rawData.map((data) => AttendanceData.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  Future<void> postAttendance(String noAbsen, DateTime tglAbsen, String tap) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_absensi');
      
      final response = await http.post(
        url,
        body: {
          'noabsen': noAbsen,
          'tglabsen': DateFormat('yyyy-MM-dd HH:mm:ss').format(tglAbsen),
          'tap': tap,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['status'] == 1) {
          print('Attendance posted successfully');
        } else {
          throw Exception('Failed to post attendance: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to post attendance');
      }
    } catch (error) {
      print('Error posting attendance: $error');
      throw error;
    }
  }
}


class AttendanceData {
  final String namaPegawai;
  final String batasTgl;
  final String tglAbsen;
  final String statusAbsen;
  final String? jamMasuk;
  final String? jamPulang;

  AttendanceData({
    required this.namaPegawai,
    required this.batasTgl,
    required this.tglAbsen,
    required this.statusAbsen,
    this.jamMasuk,
    this.jamPulang,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    String? jamMasuk = json['JamMasuk']?.substring(0, 5);
    String? jamPulang = json['JamPulang']?.substring(0, 5);

    return AttendanceData(
      namaPegawai: json['NamaPegawai'],
      batasTgl: json['BatasTgl'],
      tglAbsen: json['TglAbsen'],
      statusAbsen: json['StatusAbsen'],
      jamMasuk: jamMasuk,
      jamPulang: jamPulang,
    );
  }
}
