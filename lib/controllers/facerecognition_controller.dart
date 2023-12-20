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
}