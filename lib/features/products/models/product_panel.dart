import 'package:flutter/foundation.dart';

import 'product_panels.dart';

@immutable
class GetPanelResp {
  final bool status;
  final String statusCode;
  final String message;
  final ProductPanel? panel;

  const GetPanelResp({
    required this.status,
    required this.statusCode,
    required this.message,
    this.panel,
  });

  @override
  String toString() {
    return 'GetCategoryListResp(status: $status, statusCode: $statusCode, message: $message, result: $panel)';
  }

  factory GetPanelResp.fromJson(Map<String, dynamic> json) {
    return GetPanelResp(
      status: json['status'] as bool,
      statusCode: json['statusCode'] as String,
      message: json['message'] as String,
      // panel: (json['result'] as List<dynamic>?)
      //         ?.map((e) => ProductPanel.fromJson(e as Map<String, dynamic>))
      //         .toList() ??
      //     [],
      panel: json['result'] != null
          ? ProductPanel.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': panel?.toJson(),
  };
}
