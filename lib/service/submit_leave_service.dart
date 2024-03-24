import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:worksync/utils/globals.dart';
import 'package:worksync/utils/session_manager.dart';

class CustomFile {
  final String path;
  final String name;

  CustomFile(this.path, this.name);
}

class ApiSubmitLeave {
  late final String? noAbsen;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  ApiSubmitLeave() {
    noAbsen = SessionManager().getNoAbsen();
  }

  final String apiSubmitLeave = '$apiBaseUrl?function=post_leave';

  Future<void> submitData(
    String attLeaveId,
    String noAbsen,
    String idLeaveType,
    String startDate,
    String endDate,
    String leavenote,
    CustomFile? pickedFile,
  ) async {
    try {
      // Upload file ke Firebase Storage
      if (pickedFile != null) {
        final path = 'files/${pickedFile.path}';
        final file = File(pickedFile.path);

        final ref = storage.ref().child(path);
        final uploadTask = ref.putFile(file);
        await uploadTask.whenComplete(() {});

        // Dapatkan URL gambar setelah berhasil diunggah
        final urlDownload = await ref.getDownloadURL();

        // Submit data ke API dengan URL gambar sebagai parameter attachment
        final response = await http.post(
          Uri.parse(apiSubmitLeave),
          body: {
            'lineuid': attLeaveId,
            'noabsen': noAbsen,
            'statleave': idLeaveType,
            'tgldari': startDate,
            'tglsampai': endDate,
            'leavenote': leavenote,
            'attachment': urlDownload,
          },
        );

        if (response.statusCode == 200) {
          print('submit leave success');
        } else {
          throw Exception('Failed to submit leave');
        }
      } else {
        throw Exception('Picked file is null');
      }
    } catch (error) {
      print('Error submitting leave: $error');
      throw Exception('Failed to submit leave');
    }
  }
}