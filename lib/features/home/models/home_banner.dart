import 'package:flutter/foundation.dart';

@immutable
class HomeBannerResp {
  final bool status;
  final String statusCode;
  final String message;
  final List<HomeBanner> banners;

  const HomeBannerResp({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.banners,
  });

  factory HomeBannerResp.fromJson(Map<String, dynamic> map) {
    return HomeBannerResp(
      status: map['status'] as bool,
      statusCode: map['statusCode'] as String,
      message: map['message'] as String,
      banners: (map['result'] as List<dynamic>?)
          ?.map(
            (e) => HomeBanner.fromJson(e as Map<String, dynamic>),
      )
          .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'HomeBannerResp(status: $status, statusCode: $statusCode, message: $message, banners: $banners)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'result': banners.map((x) => x.toJson()).toList(),
    };
  }
}

@immutable
class HomeBanner {
  final int id;
  final String description;
  final String arabicDescription;
  final String imagePath;
  final String? bannerImage;
  final String imagePath1;
  final String? bannerImage1;
  final bool isJPEG;
  final int sortOrder;
  final bool active;
  final String? linkToValue;
  final String? linkToType;

  const HomeBanner({
    required this.id,
    required this.description,
    required this.arabicDescription,
    required this.imagePath,
    this.bannerImage,
    required this.imagePath1,
    this.bannerImage1,
    required this.isJPEG,
    required this.sortOrder,
    required this.active,
    this.linkToValue,
    this.linkToType,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['id'] as int,
      description: json['description'] as String,
      arabicDescription: json['arabicDescription'] as String,
      imagePath: json['imagePath'] as String,
      bannerImage: json['bannerImage'] as String?,
      imagePath1: json['imagePath1'] as String,
      bannerImage1: json['bannerImage1'] as String?,
      isJPEG: json['isJPEG'] as bool,
      sortOrder: json['sortOrder'] as int,
      active: json['active'] as bool,
      linkToValue: json['linkToValue'] as String?,
      linkToType: json['linkToType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'arabicDescription': arabicDescription,
      'imagePath': imagePath,
      'bannerImage': bannerImage,
      'imagePath1': imagePath1,
      'bannerImage1': bannerImage1,
      'isJPEG': isJPEG,
      'sortOrder': sortOrder,
      'active': active,
      'linkToValue': linkToValue,
      'linkToType': linkToType,
    };
  }
}
