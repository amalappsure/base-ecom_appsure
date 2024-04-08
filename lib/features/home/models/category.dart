import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' hide Category;

@immutable
class GetCategoryListResp {
  final bool status;
  final String statusCode;
  final String message;
  final List<Category> categories;

  const GetCategoryListResp({
    required this.status,
    required this.statusCode,
    required this.message,
    this.categories = const [],
  });

  @override
  String toString() {
    return 'GetCategoryListResp(status: $status, statusCode: $statusCode, message: $message, result: $categories)';
  }

  factory GetCategoryListResp.fromJson(Map<String, dynamic> json) {
    return GetCategoryListResp(
      status: json['status'] as bool,
      statusCode: json['statusCode'] as String,
      message: json['message'] as String,
      categories: (json['result'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': categories.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! GetCategoryListResp) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      status.hashCode ^
      statusCode.hashCode ^
      message.hashCode ^
      categories.hashCode;
}

@immutable
class Category {
  final int id;
  final int? parentId;
  final int? level;
  final String? code;
  final String title;
  final int? categoryCount;
  final String? imagePath;
  final String? longDescription;
  final String? arabicLongDescription;

  const Category({
    required this.id,
    this.parentId,
    this.level,
    this.code,
    required this.title,
    this.categoryCount,
    this.imagePath,
    this.longDescription,
    this.arabicLongDescription,
  });

  @override
  String toString() {
    return 'SubCategory(id: $id, parentId: $parentId, level: $level, code: $code, title: $title, categoryCount: $categoryCount, image: $imagePath)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id && other.parentId == parentId && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ parentId.hashCode ^ title.hashCode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'parentID': parentId,
      'level': level,
      'code': code,
      'title': title,
      'categoryCount': categoryCount,
      'imagePath': imagePath,
      'longDescription': longDescription,
      'arabicLongDescription': arabicLongDescription,
    };
  }

  factory Category.fromJson(Map<String, dynamic> map) => Category(
    id: map['id'] as int,
    parentId: map['parentID'] as int?,
    level: map['level'] as int?,
    code: map['code'] as String?,
    title: map['title'] as String,
    categoryCount: map['categoryCount'] as int?,
    imagePath:
    (map['categoryImage'] as String?) ?? (map['imagePath'] as String?),
    longDescription: map['longDescription'] as String?,
    arabicLongDescription: map['arabicLongDescription'] as String?,
  );
}
