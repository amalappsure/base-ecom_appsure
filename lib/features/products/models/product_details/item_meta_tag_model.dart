import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class ItemMetaTagModel {
  final int? id;
  final int? itemId;
  final String? title;
  final String? arabicTitle;
  final String? keywords;
  final String? arabicKeywords;
  final String? description;
  final String? arabicDescription;
  final String? createdDate;
  final String? modifiedDate;
  final int? createdBy;
  final int? modifiedBy;
  final bool? active;

  const ItemMetaTagModel({
    this.id,
    this.itemId,
    this.title,
    this.arabicTitle,
    this.keywords,
    this.arabicKeywords,
    this.description,
    this.arabicDescription,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.active,
  });

  @override
  String toString() {
    return 'ItemMetaTagModel(id: $id, itemId: $itemId, title: $title, arabicTitle: $arabicTitle, keywords: $keywords, arabicKeywords: $arabicKeywords, description: $description, arabicDescription: $arabicDescription, createdDate: $createdDate, modifiedDate: $modifiedDate, createdBy: $createdBy, modifiedBy: $modifiedBy, active: $active)';
  }

  factory ItemMetaTagModel.fromJson(Map<String, dynamic> json) {
    return ItemMetaTagModel(
      id: json['id'] as int?,
      itemId: json['itemID'] as int?,
      title: json['title'] as String?,
      arabicTitle: json['arabicTitle'] as String?,
      keywords: json['keywords'] as String?,
      arabicKeywords: json['arabicKeywords'] as String?,
      description: json['description'] as String?,
      arabicDescription: json['arabicDescription'] as String?,
      createdDate: json['createdDate'] as String?,
      modifiedDate: json['modifiedDate'] as String?,
      createdBy: json['createdBy'] as int?,
      modifiedBy: json['modifiedBy'] as int?,
      active: json['active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemID': itemId,
    'title': title,
    'arabicTitle': arabicTitle,
    'keywords': keywords,
    'arabicKeywords': arabicKeywords,
    'description': description,
    'arabicDescription': arabicDescription,
    'createdDate': createdDate,
    'modifiedDate': modifiedDate,
    'createdBy': createdBy,
    'modifiedBy': modifiedBy,
    'active': active,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ItemMetaTagModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      itemId.hashCode ^
      title.hashCode ^
      arabicTitle.hashCode ^
      keywords.hashCode ^
      arabicKeywords.hashCode ^
      description.hashCode ^
      arabicDescription.hashCode ^
      createdDate.hashCode ^
      modifiedDate.hashCode ^
      createdBy.hashCode ^
      modifiedBy.hashCode ^
      active.hashCode;
}
