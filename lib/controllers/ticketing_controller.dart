import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class TicketingController {
  final String? userId = SessionManager().getUserId();

  Future<List<TicketingUser>> fetchTicketingUser() async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=get_list_ticketing&userid=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> rawData = json.decode(response.body)['data'];
        List<TicketingUser> ticketingUser = rawData.map((data) => TicketingUser.fromJson(data)).toList();
        return ticketingUser;
      } else {
        throw Exception('Failed to load ticketingUser');
      }
    } catch (error) {
      print('Error fetching ticketingUser data: $error');
      throw error;
    }
  }

  Future<void> postTicketing({
    required int lineuid,
    required int tiketingTo,
    required int signTo,
    required String subject,
    required String desk,
    required String userid,
    required int kat,
    required int subKat,
    required String priority,
    required String attachment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl?function=post_ticketing'),
        body: {
          'lineuid': lineuid.toString(),
          'tiketingTo': tiketingTo.toString(),
          'signTo': signTo.toString(),
          'subject': subject,
          'desk': desk,
          'userid': userid,
          'kat': kat.toString(),
          'subKat': subKat.toString(),
          'priority': priority,
          'attachment': attachment,
        },
      );

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      throw Exception('Error submitting ticket: $e');
    }
  }

  Future<void> postRateTicketing(String ticketingId, String score, String note) async {
    try {
      final Uri url = Uri.parse('$apiBaseUrl?function=post_achievement');

      final response = await http.post(
        url,
        body: {
          'lineuid': ticketingId,
          'score': score,
          'note': note
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.toLowerCase().contains('application/json') != true) {
          throw Exception('Invalid content type: ${response.headers['content-type']}');
        }

        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('status')) {
          if (responseData['status'] == 1) {
            print('Rate posted successfully');
          } else {
            throw Exception('Failed to rate ticketing: ${responseData['message']}');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to rate ticketing. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting rate: $error');
      rethrow;
    }
  }
}

class TicketingUser {
  final String? lineUID;
  final String? noTiket;
  final String? subjek;
  final String? prioritas;
  final String? kategori;
  final String? subkategori;
  final String? status;
  final String? description;
  final String? attachment;
  final String? score;
  final String? note;

  TicketingUser({
    this.lineUID, this.noTiket, this.subjek, this.prioritas, this.kategori, this.subkategori, this.status, this.description, this.attachment, this.score, this.note
  });

  factory TicketingUser.fromJson(Map<String, dynamic> json) {
    return TicketingUser(
      lineUID: json['LineUID'],
      noTiket: json['NoTiket'],
      subjek: json['Subjek'],
      prioritas: json['Prioritas'],
      kategori: json['kategori'],
      subkategori: json['subkategori'],
      status: json['Status'],
      description: json['KPI_AP_Desc'],
      attachment: json['KPI_AP_Task_Image'],
      score: json['KPI_AP_Achievement'],
      note: json['KPI_AP_Achievement_Note']
    );
  }
}