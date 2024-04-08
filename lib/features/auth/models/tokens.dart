// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthTokensResp {
  final bool status;
  final String statusCode;
  final String message;
  final AuthTokens? result;

  AuthTokensResp({
    required this.status,
    required this.statusCode,
    required this.message,
    this.result,
  });

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': result?.toJson(),
  };

  factory AuthTokensResp.fromJson(Map<String, dynamic> map) => AuthTokensResp(
    status: map['status'] as bool,
    statusCode: map['statusCode'] as String,
    message: map['message'] as String,
    result: map['result'] != null
        ? AuthTokens.fromJson(map['result'] as Map<String, dynamic>)
        : null,
  );

  @override
  String toString() {
    return 'AuthTokensResp(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };

  factory AuthTokens.fromJson(Map<String, dynamic> map) => AuthTokens(
    accessToken: map['accessToken'] as String? ?? '',
    refreshToken: map['refreshToken'] as String? ?? '',
  );

  @override
  String toString() =>
      'AuthTokens(accessToken: $accessToken, refreshToken: $refreshToken)';
}
