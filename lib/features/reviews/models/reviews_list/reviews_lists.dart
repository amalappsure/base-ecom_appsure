import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'rating.dart';

@immutable
class ReviewsLists {
  final List<dynamic>? table;
  final List<Rating> table1;

  const ReviewsLists({this.table, required this.table1});

  @override
  String toString() => 'Result(table: $table, table1: $table1)';

  factory ReviewsLists.fromJson(Map<String, dynamic> json) => ReviewsLists(
    table: json['table'] as List<dynamic>?,
    table1: (json['table1'] as List<dynamic>?)
        ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'table': table,
    'table1': table1.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ReviewsLists) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => table.hashCode ^ table1.hashCode;
}
