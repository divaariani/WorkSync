import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class AttendanceController extends ChangeNotifier {
  late Future<List<AttendanceData>> futureData;

  AttendanceController() {
    final String? noAbsen = SessionManager().getNoAbsen();
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
      debugPrint('Error fetching data: $error');
      rethrow;
    }
  }

  String getTodayIn(List<AttendanceData> data) {
    final todayData = data.firstWhere(
      (element) => element.tglAbsen == DateFormat('yyyy-MM-dd').format(DateTime.now()),
      orElse: () => AttendanceData(
        jamMasuk: 'N/A',
        jamPulang: 'N/A',
        namaPegawai: '',
        batasTgl: '',
        tglAbsen: '',
        statusAbsen: '',
        latitude: '',
        longitude: '',
        attendancePhoto: '',
      ),
    );

    return todayData.jamMasuk ?? 'N/A';
  }

  String getTodayOut(List<AttendanceData> data) {
    final todayData = data.firstWhere(
      (element) => element.tglAbsen == DateFormat('yyyy-MM-dd').format(DateTime.now()),
      orElse: () => AttendanceData(
        jamMasuk: 'N/A',
        jamPulang: 'N/A',
        namaPegawai: '',
        batasTgl: '',
        tglAbsen: '',
        statusAbsen: '',
        latitude: '',
        longitude: '',
        attendancePhoto: '',
      ),
    );

    return todayData.jamPulang ?? 'N/A';
  }

  String getTodayState(List<AttendanceData> data) {
    final todayData = data.firstWhere(
      (element) => element.tglAbsen == DateFormat('yyyy-MM-dd').format(DateTime.now()),
      orElse: () => AttendanceData(
        jamMasuk: '',
        jamPulang: '',
        namaPegawai: '',
        batasTgl: '',
        tglAbsen: '',
        statusAbsen: 'N/A',
        latitude: '',
        longitude: '',
        attendancePhoto: '',
      ),
    );

    return todayData.statusAbsen;
  }

  String calculatePerformance(List<AttendanceData> data) {
    final latest30Entries = data.take(30).toList();

    final validEntries = latest30Entries.where((entry) => entry.jamMasuk != null && entry.jamPulang != null).toList();
    final totalValidEntries = validEntries.length;

    final percentage = totalValidEntries > 0 ? ((totalValidEntries / 20) * 100).round().toString() : '0';

    return '$percentage%';
  }

  Future<void> postAttendance(String noAbsen, DateTime tglAbsen, String tap, String latitude, String longitude, String linkPhoto) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_absensi');
      
      final response = await http.post(
        url,
        body: {
          'noabsen': noAbsen,
          'tglabsen': DateFormat('yyyy-MM-dd HH:mm:ss').format(tglAbsen),
          'tap': tap,
          'lintang': globalLat,
          'bujur': globalLong,
          'linkphoto': ''
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['status'] == 1) {
          debugPrint('Attendance posted successfully');
        } else {
          throw Exception('Failed to post attendance: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to post attendance');
      }
    } catch (error) {
      debugPrint('Error posting attendance: $error');
      rethrow;
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
  final String? latitude;
  final String? longitude;
  final String? attendancePhoto;

  AttendanceData({
    required this.namaPegawai,
    required this.batasTgl,
    required this.tglAbsen,
    required this.statusAbsen,
    this.jamMasuk,
    this.jamPulang,
    this.latitude,
    this.longitude,
    this.attendancePhoto
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
      latitude: json['lintang'],
      longitude: json['bujur'],
      attendancePhoto: json['linkphoto'],
    );
  }
}