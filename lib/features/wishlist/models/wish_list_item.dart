import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class WishListItems {
  final bool? status;
  final String? statusCode;
  final String? message;
  final List<WishListItem> items;

  const WishListItems({
    this.status,
    this.statusCode,
    this.message,
    this.items = const [],
  });

  @override
  String toString() {
    return 'WishListItem(status: $status, statusCode: $statusCode, message: $message, result: $items)';
  }

  factory WishListItems.fromJson(Map<String, dynamic> json) => WishListItems(
    status: json['status'] as bool?,
    statusCode: json['statusCode'] as String?,
    message: json['message'] as String?,
    items: (json['result'] as List<dynamic>?)
        ?.map((e) => WishListItem.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': items.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! WishListItems) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      status.hashCode ^ statusCode.hashCode ^ message.hashCode ^ items.hashCode;
}

@immutable
class WishListItem {
  final int id;
  final DateTime? createdDatetime;
  final int? quantity;
  final int itemId;
  final dynamic brandId;
  final String? itemName;
  final String? urlName;
  final double? sellingPrice;
  final dynamic brandName;
  final int? count;
  final dynamic itemImage;
  final int stock;
  final int unitId;
  final String? unit;
  final bool? weightedItem;
  final bool? isDigitalCard;
  final int? existInCart;
  final int? cartQuantity;
  final int? existInWishlist;

  const WishListItem({
    required this.id,
    this.createdDatetime,
    this.quantity,
    required this.itemId,
    this.brandId,
    this.itemName,
    this.urlName,
    this.sellingPrice,
    this.brandName,
    this.count,
    this.itemImage,
    this.stock = 0,
    required this.unitId,
    this.unit,
    this.weightedItem,
    this.isDigitalCard,
    this.existInCart,
    this.cartQuantity,
    this.existInWishlist,
  });

  @override
  String toString() {
    return 'Result(id: $id, createdDatetime: $createdDatetime, quantity: $quantity, itemId: $itemId, brandId: $brandId, itemName: $itemName, urlName: $urlName, sellingPrice: $sellingPrice, brandName: $brandName, count: $count, itemImage: $itemImage, stock: $stock, unitId: $unitId, unit: $unit, weightedItem: $weightedItem, isDigitalCard: $isDigitalCard, existInCart: $existInCart, cartQuantity: $cartQuantity, existInWishlist: $existInWishlist)';
  }

  factory WishListItem.fromJson(Map<String, dynamic> json) => WishListItem(
    id: json['id'] as int,
    createdDatetime: json['createdDatetime'] == null
        ? null
        : DateTime.parse(json['createdDatetime'] as String),
    quantity: (json['quantity'] as num? ?? 0).toInt(),
    itemId: json['itemID'] as int,
    brandId: json['brandID'] as dynamic,
    itemName: json['itemName'] as String?,
    urlName: json['urlName'] as String?,
    sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
    brandName: json['brandName'] as dynamic,
    count: json['count'] as int?,
    itemImage: json['itemImage'] as dynamic,
    stock: (json['stock'] as num? ?? 0).toInt(),
    unitId: json['unitID'] as int,
    unit: json['unit'] as String?,
    weightedItem: json['weightedItem'] as bool?,
    isDigitalCard: json['isDigitalCard'] as bool?,
    existInCart: json['existInCart'] as int?,
    cartQuantity: (json['cartQuantity'] as num? ?? 0).toInt(),
    existInWishlist: json['existInWishlist'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdDatetime': createdDatetime?.toIso8601String(),
    'quantity': quantity,
    'itemID': itemId,
    'brandID': brandId,
    'itemName': itemName,
    'urlName': urlName,
    'sellingPrice': sellingPrice,
    'brandName': brandName,
    'count': count,
    'itemImage': itemImage,
    'stock': stock,
    'unitID': unitId,
    'unit': unit,
    'weightedItem': weightedItem,
    'isDigitalCard': isDigitalCard,
    'existInCart': existInCart,
    'cartQuantity': cartQuantity,
    'existInWishlist': existInWishlist,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! WishListItem) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      createdDatetime.hashCode ^
      quantity.hashCode ^
      itemId.hashCode ^
      brandId.hashCode ^
      itemName.hashCode ^
      urlName.hashCode ^
      sellingPrice.hashCode ^
      brandName.hashCode ^
      count.hashCode ^
      itemImage.hashCode ^
      stock.hashCode ^
      unitId.hashCode ^
      unit.hashCode ^
      weightedItem.hashCode ^
      isDigitalCard.hashCode ^
      existInCart.hashCode ^
      cartQuantity.hashCode ^
      existInWishlist.hashCode;
}
