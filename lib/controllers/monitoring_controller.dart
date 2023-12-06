import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/globals.dart';

class MonitoringController {

  Future<List<Map<String, dynamic>>> fetchMonitoringData() async {
    final url = '$apiBaseUrl?function=get_list_checkpoint_tour_monitoring&caritahun=2023';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 1) {
          final List<Map<String, dynamic>> overtimeList = List.from(data['data']);
          return overtimeList;
        } else {
          print('API Error: ${data['message']}');
          return [];
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
}