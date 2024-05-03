import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../utils/photos.dart';

class LeaveUrlController {
  late final String? noAbsen;
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  LeaveUrlController() {
    noAbsen = SessionManager().getNoAbsen();
  }

  String buildApiUrl() {
    return '$apiBaseUrl?function=get_list_leave&noabsen=$noAbsen';
  }

  Future<LeaveController> fetchData() async {
    final String apiUrl = buildApiUrl();
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return LeaveController.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
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
      if (pickedFile != null) {
        final path = 'files/${pickedFile.path}';
        final file = File(pickedFile.path);

        final ref = storage.ref().child(path);
        final uploadTask = ref.putFile(file);
        await uploadTask.whenComplete(() {});

        final urlDownload = await ref.getDownloadURL();

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

  final String apiEditSubmitLeave = '$apiBaseUrl?function=post_leave';

  Future<void> submitEditData(
    String attLeaveId,
    String noAbsen,
    String idLeaveType,
    String startDate,
    String endDate,
    String leavenote,
    String attachment,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(apiEditSubmitLeave),
        body: {
          'lineuid': attLeaveId,
          'noabsen': noAbsen,
          'statleave': idLeaveType,
          'tgldari': startDate,
          'tglsampai': endDate,
          'leavenote': leavenote,
          'attachment': attachment,
        },
      );

      if (response.statusCode == 200) {
        print('submit leave success');
      } else {
        throw Exception('Failed to submit leave');
      }
    } catch (error) {
      print('Error submitting leave data: $error');
      throw Exception('Failed to submit leave');
    }
  }
}

class LeaveListController {
  late final String? noAbsen;

  LeaveListService() {
    noAbsen = SessionManager().getNoAbsen();
  }

  String buildApiUrl() {
    return '$apiBaseUrl?function=get_list_leave&noabsen=$noAbsen';
  }

  Future<LeaveController> fetchData() async {
    final String apiUrl = buildApiUrl();
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return LeaveController.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class LeaveController {
  final int status;
  final String message;
  final List<LeaveData> data;

  LeaveController({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LeaveController.fromRawJson(String str) => LeaveController.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeaveController.fromJson(Map<String, dynamic> json) => LeaveController(
        status: json["status"],
        message: json["message"],
        data: List<LeaveData>.from(json["data"].map((x) => LeaveData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LeaveTypeController {
    final int status;
    final String message;
    final List<LeaveTypeData> data;

    LeaveTypeController({
        required this.status,
        required this.message,
        required this.data,
    });

    factory LeaveTypeController.fromRawJson(String str) => LeaveTypeController.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LeaveTypeController.fromJson(Map<String, dynamic> json) => LeaveTypeController(
        status: json["status"],
        message: json["message"],
        data: List<LeaveTypeData>.from(json["data"].map((x) => LeaveTypeData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class LeaveData {
  final String attLeaveId;
  final String workTimeStatusId;
  final DateTime dari;
  final DateTime sampai;
  final String keterangan;
  final String status;
  final String? imageUrl;

  LeaveData({
    required this.attLeaveId,
    required this.workTimeStatusId,
    required this.dari,
    required this.sampai,
    required this.keterangan,
    required this.status,
    this.imageUrl, 
  });

  factory LeaveData.fromRawJson(String str) =>
      LeaveData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeaveData.fromJson(Map<String, dynamic> json) => LeaveData(
        attLeaveId: json["Att_Leave_Id"],
        workTimeStatusId: json["WorkTimeStatus_Id"],
        dari: DateTime.parse(json["Dari"]),
        sampai: DateTime.parse(json["Sampai"]),
        keterangan: json["Keterangan"],
        status: json["Status"],
        imageUrl: json['Att_Leave_Picture_File']
      );

  Map<String, dynamic> toJson() => {
        "Att_Leave_Id": attLeaveId,
        "WorkTimeStatus_Id": workTimeStatusId,
        "Dari": "${dari.year.toString().padLeft(4, '0')}-${dari.month.toString().padLeft(2, '0')}-${dari.day.toString().padLeft(2, '0')}",
        "Sampai": "${sampai.year.toString().padLeft(4, '0')}-${sampai.month.toString().padLeft(2, '0')}-${sampai.day.toString().padLeft(2, '0')}",
        "Keterangan": keterangan,
        "Status": status,
      };
}

class LeaveTypeData {
    final String statusAbsensi;
    final String id;

    LeaveTypeData({
        required this.statusAbsensi,
        required this.id,
    });

    factory LeaveTypeData.fromRawJson(String str) => LeaveTypeData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LeaveTypeData.fromJson(Map<String, dynamic> json) => LeaveTypeData(
        statusAbsensi: json["StatusAbsensi"],
        id: json["Id"],
    );

    Map<String, dynamic> toJson() => {
        "StatusAbsensi": statusAbsensi,
        "Id": id,
    };
}

class ApiProvider {
  final String apiUrl = '$apiBaseUrl?function=get_status_leave'; 

  Future<LeaveTypeController> fetchLeaveTypes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return LeaveTypeController.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil data tipe cuti');
    }
  }
}
