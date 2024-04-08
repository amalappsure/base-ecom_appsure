import 'package:flutter/material.dart';

@immutable
class SortMethods {
  const SortMethods({required this.sortMethods});

  final List<SortMethod> sortMethods;

  Map<String, dynamic> toJson() => {
    'result': sortMethods.map((x) => x.toJson()).toList(),
  };

  factory SortMethods.fromJson(Map<String, dynamic> map) => SortMethods(
    sortMethods: (map['result'] as List<dynamic>?)
        ?.map((e) => SortMethod.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );
}

@immutable
class SortMethod {
  const SortMethod({
    required this.id,
    required this.value,
    this.remarks,
  });

  final int id;
  final String value;
  final String? remarks;

  SortMethod copyWith({
    int? id,
    String? value,
    String? remarks,
  }) =>
      SortMethod(
        id: id ?? this.id,
        value: value ?? this.value,
        remarks: remarks ?? this.remarks,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'value': value,
    'remarks': remarks,
  };

  factory SortMethod.fromJson(Map<String, dynamic> map) => SortMethod(
    id: map['id'] as int,
    value: map['value'] as String,
    remarks: map['remarks'] as String?,
  );

  @override
  String toString() => 'SortMethod(id: $id, value: $value, remarks: $remarks)';

  @override
  bool operator ==(covariant SortMethod other) {
    if (identical(this, other)) return true;

    return other.id == id && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ value.hashCode ^ remarks.hashCode;
}
