import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';

import 'package:base_ecom_appsure/features/home/models/category.dart';

class CustomLocale {
  CustomLocale({
    required this.name,
    required this.locale,
    required this.displayName,
    this.translations = const [],
    this.subCategories = const [],
  });

  final String name;
  final String displayName;
  final Locale locale;
  final List<Map<String, dynamic>> translations;
  final List<Category> subCategories;

  bool get isArabic => name == 'Arabic';

  bool get isEnglish => name == 'English';

  List<Category> subCategoriesOf(int of) =>
      subCategories.where((element) => element.parentId == of).toList();

  factory CustomLocale.fromSettingsJson({
    required String name,
    required Locale locale,
    required Map<String, dynamic> json,
    required List<Category> subCategories,
    required String displayName,
  }) =>
      CustomLocale(
        name: name,
        locale: locale,
        translations: (json['result']['table'] as List<dynamic>?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
            [],
        subCategories: subCategories,
        displayName: displayName,
      );

  String translate(String key) {
    try {
      return (translations.firstWhere(
            (element) => element['fieldName'] == key,
      )['fieldText'])
          .toString();
    } catch (e) {
      return key;
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'displayName': displayName,
      'locale': locale.languageCode,
      'translations': translations,
      'subCategories': subCategories.map((x) => x.toJson()).toList(),
    };
  }

  factory CustomLocale.fromJson(Map<String, dynamic> map) {
    return CustomLocale(
      name: map['name'] as String,
      displayName: map['displayName'] as String,
      locale: Locale(map['locale']),
      translations: (map['translations'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
          [],
      subCategories: (map['subCategories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  @override
  bool operator ==(covariant CustomLocale other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.locale == locale &&
        listEquals(other.translations, translations) &&
        listEquals(other.subCategories, subCategories);
  }

  @override
  int get hashCode {
    return name.hashCode ^
    locale.hashCode ^
    translations.hashCode ^
    subCategories.hashCode;
  }
}
