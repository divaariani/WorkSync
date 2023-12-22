import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class FaceRecognitionController extends ChangeNotifier {
  Future<void> sendFaceRecognition(List<dynamic>? e1) async {
    String userId = SessionManager().getUserId() ?? '';
    String textFaceDetection = e1.toString();

    Map<String, dynamic> requestBody = {
      'userid': userId,
      'text_face_detection': textFaceDetection,
    };

    final response = await http.post(
      Uri.parse('$apiBaseUrl?function=post_regist_face_detection'),
      body: requestBody,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      int status = responseBody['status'];
      String message = responseBody['message'];

      if (status == 1) {
        print('API request successful: $message');
      } else {
        print('API request failed: $message');
      }
    } else {
      print('API request failed with status code: ${response.statusCode}');
    }
  }

  Future<List<FaceRecognitionData>> getFaceRecognition() async {
    String userId = SessionManager().getUserId() ?? '';
    final url = '$apiBaseUrl?function=get_list_face_detection&userid=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 1) {
          final List<dynamic> dataList = jsonData['data'];
          return dataList.map((data) => FaceRecognitionData.fromJson(data)).toList();
        } else {
          throw Exception(jsonData['message']);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class FaceRecognitionData {
  final String userId;
  final String userName;
  final String kodeFace;

  FaceRecognitionData({
    required this.userId,
    required this.userName,
    required this.kodeFace,
  });

  factory FaceRecognitionData.fromJson(Map<String, dynamic> json) {
    return FaceRecognitionData(
      userId: json['User_Id'],
      userName: json['UserName'],
      kodeFace: json['Kodeface'],
    );
  }
}
