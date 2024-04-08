import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class SearchResults {
  final bool? status;
  final String? statusCode;
  final String? message;
  final List<SearchResult> results;

  const SearchResults({
    this.status,
    this.statusCode,
    this.message,
    this.results = const [],
  });

  @override
  String toString() {
    return 'SearchResult(status: $status, statusCode: $statusCode, message: $message, result: $results)';
  }

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
    status: json['status'] as bool?,
    statusCode: json['statusCode'] as String?,
    message: json['message'] as String?,
    results: (json['result'] as List<dynamic>?)
        ?.map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': results.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SearchResults) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      status.hashCode ^
      statusCode.hashCode ^
      message.hashCode ^
      results.hashCode;
}

@immutable
class SearchResult {
  final int id;
  final String? description;
  final String? urlName;
  final int? unitId;
  final String? type;

  const SearchResult({
    required this.id,
    this.description,
    this.urlName,
    this.unitId,
    this.type,
  });

  @override
  String toString() {
    return 'Result(id: $id, description: $description, urlName: $urlName, unitId: $unitId, type: $type)';
  }

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
    id: json['id'] as int,
    description: json['description'] as String?,
    urlName: json['urlName'] as String?,
    unitId: json['unitID'] as int?,
    type: json['type'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'urlName': urlName,
    'unitID': unitId,
    'type': type,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SearchResult) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      description.hashCode ^
      urlName.hashCode ^
      unitId.hashCode ^
      type.hashCode;
}
