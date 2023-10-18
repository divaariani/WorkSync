import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool loading = false.obs;

  Future<bool> login(String username, String password) async {
    loading.value = true;

    final url = Uri.parse('{API}');

    try {
      final response = await http.get(url);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        loading.value = false; 
        Get.snackbar('Login Successful', 'Congratulations');
        final responseData = jsonDecode(response.body);
        final token = responseData['data']['token'];
        final userId = responseData['data']['user_id'];
        return true;
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        loading.value = false; 
        return false;
      }
    } catch (error) {
      print('Error: $error');
      loading.value = false; 
      return false;
    }
  }
}