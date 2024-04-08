import 'package:flutter/foundation.dart';

enum InfoType {
  about(2),
  privacy(13),
  returnAndExchange(10),
  contact(8);

  final int id;

  const InfoType(this.id);
}

@immutable
class CompanyInfoResp {
  final bool? status;
  final String? statusCode;
  final String? message;
  final CompanyInfo? info;

  const CompanyInfoResp({
    this.status,
    this.statusCode,
    this.message,
    this.info,
  });

  factory CompanyInfoResp.fromJson(Map<String, dynamic> json) =>
      CompanyInfoResp(
        status: json['status'] as bool?,
        statusCode: json['statusCode'] as String?,
        message: json['message'] as String?,
        info: json['result'] != null
            ? CompanyInfo.fromJson(
          json['result'] as Map<String, dynamic>,
        )
            : null,
      );
}

class CompanyInfo {
  CompanyInfo({
    required this.title,
    required this.content,
  });

  final String? title;
  final String? content;

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
  };

  factory CompanyInfo.fromJson(Map<String, dynamic> map) => CompanyInfo(
    title: map['title'] as String?,
    content: map['content'] as String?,
  );
}
