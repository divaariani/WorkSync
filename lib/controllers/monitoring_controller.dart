import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/globals.dart';

class MonitoringController {

  Future<List<Map<String, dynamic>>> fetchMonitoringData({int? searchYear}) async {
    final url = '$apiBaseUrl?function=get_list_checkpoint_tour_monitoring&caritahun=$searchYear';

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
}
