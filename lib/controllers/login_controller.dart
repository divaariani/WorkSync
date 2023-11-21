import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/globals.dart';

class LoginController {
  bool isLoading = false;
  Map<String, dynamic> userData = {};
  
  Future<bool> login(String username, String password) async {
    isLoading = true;

    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl?function=get_login&userlogin=$username&userpwd=$password'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 1) {
          // Login successful
          userData = data['data'][0];
          isLoading = false;
          return true;
        } else {
          // Login failed
          isLoading = false;
          return false;
        }
      } else {
        // Handle other HTTP status codes
        isLoading = false;
        return false;
      }
    } catch (e) {
      // Handle network errors or exceptions
      isLoading = false;
      return false;
    }
  }
}
