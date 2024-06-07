class OTPResponse {
  bool status;
  String statusCode;
  String message;
  String result;

  OTPResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.result,
  });

  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      result: json['result'],
    );
  }
}
