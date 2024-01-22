import 'dart:convert';

class LeaveTypeModel {
    final int status;
    final String message;
    final List<DatumLeaveType> data;

    LeaveTypeModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory LeaveTypeModel.fromRawJson(String str) => LeaveTypeModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LeaveTypeModel.fromJson(Map<String, dynamic> json) => LeaveTypeModel(
        status: json["status"],
        message: json["message"],
        data: List<DatumLeaveType>.from(json["data"].map((x) => DatumLeaveType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumLeaveType {
    final String statusAbsensi;
    final String id;

    DatumLeaveType({
        required this.statusAbsensi,
        required this.id,
    });

    factory DatumLeaveType.fromRawJson(String str) => DatumLeaveType.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DatumLeaveType.fromJson(Map<String, dynamic> json) => DatumLeaveType(
        statusAbsensi: json["StatusAbsensi"],
        id: json["Id"],
    );

    Map<String, dynamic> toJson() => {
        "StatusAbsensi": statusAbsensi,
        "Id": id,
    };
}



