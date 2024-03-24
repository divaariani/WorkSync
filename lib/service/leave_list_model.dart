import 'dart:convert';

class LeaveListModel {
  final int status;
  final String message;
  final List<DatumLeaveList> data;

  LeaveListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LeaveListModel.fromRawJson(String str) =>
      LeaveListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeaveListModel.fromJson(Map<String, dynamic> json) => LeaveListModel(
        status: json["status"],
        message: json["message"],
        data: List<DatumLeaveList>.from(
            json["data"].map((x) => DatumLeaveList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumLeaveList {
  final String attLeaveId;
  final String workTimeStatusId;
  final DateTime dari;
  final DateTime sampai;
  final String keterangan;
  final String status;
  final String? imageUrl;

  DatumLeaveList({
    required this.attLeaveId,
    required this.workTimeStatusId,
    required this.dari,
    required this.sampai,
    required this.keterangan,
    required this.status,
    this.imageUrl, 
  });

  factory DatumLeaveList.fromRawJson(String str) =>
      DatumLeaveList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumLeaveList.fromJson(Map<String, dynamic> json) => DatumLeaveList(
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
