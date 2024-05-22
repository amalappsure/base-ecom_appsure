import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

@immutable
class TimeSlot {
  final int id;
  final DateTime date;
  final String slotDate;
  final String day;
  final String slot;

  const TimeSlot({
    required this.id,
    required this.date,
    required this.slotDate,
    required this.day,
    required this.slot,
  });

  @override
  String toString() {
    return 'TimeSlot(id: $id, date: $date, slotDate: $slotDate, day: $day, slot: $slot)';
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    id: json['id'] as int,
    date: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['date'] as String),
    slotDate: json['slotDate'] as String,
    day: json['day'] as String,
    slot: json['slot'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': DateFormat("yyyy-MM-ddTHH:mm:ss").format(date),
    'slotDate': slotDate,
    'day': day,
    'slot': slot,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! TimeSlot) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      slotDate.hashCode ^
      day.hashCode ^
      slot.hashCode;
}
