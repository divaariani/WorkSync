class ResponseModel {
  final int status;
  final String message;
  final List<dynamic> data;

  ResponseModel({required this.status, required this.message, required this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] ?? []
    );
  }
}