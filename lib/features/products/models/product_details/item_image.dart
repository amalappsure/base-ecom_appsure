import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class ItemImage {
  final int? id;
  final int? itemId;
  final String? imagePathSmall;
  final dynamic imagePathMedium;
  final String? imagePathLarge;
  final dynamic title;
  final dynamic arabicTitle;
  final String? imageSize;
  final bool? isDefault;
  final int? orderNo;
  final bool? active;
  final int? rowState;

  const ItemImage({
    this.id,
    this.itemId,
    this.imagePathSmall,
    this.imagePathMedium,
    this.imagePathLarge,
    this.title,
    this.arabicTitle,
    this.imageSize,
    this.isDefault,
    this.orderNo,
    this.active,
    this.rowState,
  });

  @override
  String toString() {
    return 'ItemImage(id: $id, itemId: $itemId, imagePathSmall: $imagePathSmall, imagePathMedium: $imagePathMedium, imagePathLarge: $imagePathLarge, title: $title, arabicTitle: $arabicTitle, imageSize: $imageSize, isDefault: $isDefault, orderNo: $orderNo, active: $active, rowState: $rowState)';
  }

  factory ItemImage.fromJson(Map<String, dynamic> json) => ItemImage(
    id: json['id'] as int?,
    itemId: json['itemID'] as int?,
    imagePathSmall: json['imagePathSmall'] as String?,
    imagePathMedium: json['imagePathMedium'] as dynamic,
    imagePathLarge: json['imagePathLarge'] as String?,
    title: json['title'] as dynamic,
    arabicTitle: json['arabicTitle'] as dynamic,
    imageSize: json['imageSize'] as String?,
    isDefault: json['isDefault'] as bool?,
    orderNo: json['orderNo'] as int?,
    active: json['active'] as bool?,
    rowState: json['rowState'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemID': itemId,
    'imagePathSmall': imagePathSmall,
    'imagePathMedium': imagePathMedium,
    'imagePathLarge': imagePathLarge,
    'title': title,
    'arabicTitle': arabicTitle,
    'imageSize': imageSize,
    'isDefault': isDefault,
    'orderNo': orderNo,
    'active': active,
    'rowState': rowState,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ItemImage) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      itemId.hashCode ^
      imagePathSmall.hashCode ^
      imagePathMedium.hashCode ^
      imagePathLarge.hashCode ^
      title.hashCode ^
      arabicTitle.hashCode ^
      imageSize.hashCode ^
      isDefault.hashCode ^
      orderNo.hashCode ^
      active.hashCode ^
      rowState.hashCode;
}
