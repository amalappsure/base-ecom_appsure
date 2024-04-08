import 'package:flutter/foundation.dart';

@immutable
class CountryCode {
  final String countryName;
  final String code;

  const CountryCode({
    required this.countryName,
    required this.code,
  });

  @override
  String toString() {
    return 'CountryCode(countryName: $countryName, countryCode: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CountryCode) return false;
    return other.code == code;
  }

  @override
  int get hashCode => countryName.hashCode ^ code.hashCode;
}

final countryCodes = [
  const CountryCode(countryName: 'Kuwait', code: '965'),
  const CountryCode(countryName: 'India', code: '91'),
];
