import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class Rating {
  final int itemId;
  final int one;
  final int two;
  final int three;
  final int four;
  final int five;
  final int totalUserRatings;
  final int totalUserReviews;

  const Rating({
    required this.itemId,
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
    required this.totalUserRatings,
    required this.totalUserReviews,
  });

  double get average {
    final total = one + two + three + four + five;
    if (total == 0) return 0;
    return (one + two * 2 + three * 3 + four * 4 + five * 5) / total;
  }

  int countOf(String rating) {
    switch (rating) {
      case '1':
        return one;
      case '2':
        return two;
      case '3':
        return three;
      case '4':
        return four;
      case '5':
        return five;
      default:
        return 0;
    }
  }

  @override
  String toString() {
    return 'Table1(itemId: $itemId, one: $one, two: $two, three: $three, four: $four, five: $five, totalUserRatings: $totalUserRatings, totalUserReviews: $totalUserReviews)';
  }

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    itemId: json['itemID'] as int,
    one: json['one'] as int? ?? 0,
    two: json['two'] as int? ?? 0,
    three: json['three'] as int? ?? 0,
    four: json['four'] as int? ?? 0,
    five: json['five'] as int? ?? 0,
    totalUserRatings: json['totalUserRatings'] as int? ?? 0,
    totalUserReviews: json['totalUserReviews'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'itemID': itemId,
    'one': one,
    'two': two,
    'three': three,
    'four': four,
    'five': five,
    'totalUserRatings': totalUserRatings,
    'totalUserReviews': totalUserReviews,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Rating) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      itemId.hashCode ^
      one.hashCode ^
      two.hashCode ^
      three.hashCode ^
      four.hashCode ^
      five.hashCode ^
      totalUserRatings.hashCode ^
      totalUserReviews.hashCode;
}
