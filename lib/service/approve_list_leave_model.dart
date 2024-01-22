import 'dart:convert';

class ApproveListLeaveModel {
  final int status;
  final String message;
  final List<DatumApproveListLeave> data;

  ApproveListLeaveModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApproveListLeaveModel.fromRawJson(String str) =>
      ApproveListLeaveModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApproveListLeaveModel.fromJson(Map<String, dynamic> json) =>
      ApproveListLeaveModel(
        status: json["status"],
        message: json["message"],
        data: List<DatumApproveListLeave>.from(json["data"].map((x) => DatumApproveListLeave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumApproveListLeave {
  final String attLeaveId;
  final String namaKaryawan;
  final DateTime tglAjuan;
  final String leaveDesc;
  final DateTime dari;
  final DateTime sampai;
  final String attLeaveNote;
  final String actionStatusPost;
  final String? attachment; // Make it nullable

  DatumApproveListLeave({
    required this.attLeaveId,
    required this.namaKaryawan,
    required this.tglAjuan,
    required this.leaveDesc,
    required this.dari,
    required this.sampai,
    required this.attLeaveNote,
    required this.actionStatusPost,
    this.attachment, // Nullable property
  });

  factory DatumApproveListLeave.fromRawJson(String str) => DatumApproveListLeave.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumApproveListLeave.fromJson(Map<String, dynamic> json) => DatumApproveListLeave(
        attLeaveId: json["Att_Leave_Id"],
        namaKaryawan: json["NamaKaryawan"],
        tglAjuan: DateTime.parse(json["TglAjuan"]),
        leaveDesc: json["LeaveDesc"],
        dari: DateTime.parse(json["Dari"]),
        sampai: DateTime.parse(json["Sampai"]),
        attLeaveNote: json["Att_Leave_Note"],
        actionStatusPost: json["Action_Status_Post"],
        attachment: json['Att_Leave_Picture_File'] ?? "", // Treat it as an empty string if null
      );

  Map<String, dynamic> toJson() => {
        "Att_Leave_Id": attLeaveId,
        "NamaKaryawan": namaKaryawan,
        "TglAjuan": tglAjuan.toIso8601String(),
        "LeaveDesc": leaveDesc,
        "Dari": "${dari.year.toString().padLeft(4, '0')}-${dari.month.toString().padLeft(2, '0')}-${dari.day.toString().padLeft(2, '0')}",
        "Sampai": "${sampai.year.toString().padLeft(4, '0')}-${sampai.month.toString().padLeft(2, '0')}-${sampai.day.toString().padLeft(2, '0')}",
        "Att_Leave_Note": attLeaveNote,
        "Action_Status_Post": actionStatusPost,
        "Att_Leave_Picture_File": attachment ?? "null data", // Treat it as an empty string if null
      };
}