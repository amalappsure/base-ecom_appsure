import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'package:base_ecom_appsure/features/reviews/models/reviews_list/rating.dart';

import 'product_model_mixin.dart';
import 'unit.dart';

@immutable
class Product with ProductModelMixin {
  final int? id;
  final int? panelId;
  final int itemId;
  final String? itemName;
  final String? imagePath;
  @override
  final double? sellingPrice;
  @override
  final double? promotionPrice;
  final dynamic discPercentage;
  final dynamic lastPurchaseDate;
  final dynamic startDate;
  final DateTime? endDate;
  final dynamic orderNo;
  final bool? active;
  final int? rowState;
  @override
  final int stock;
  @override
  final int qtyPerCustomer;
  final List<Unit>? units;
  final bool? existInCart;
  final bool? weightedItem;
  final num? cartQuantity;
  final bool existInWishlist;
  final String? urlName;
  final dynamic brandName;
  final List<Rating>? userRatings;
  final bool? disableAddToCart;
  final bool? disableReserveAndCollect;
  final bool? isServiceItem;
  final String? itemCode;
  final int unitId;
  final dynamic itemSizes;
  final dynamic itemStages;

  @override
  Product get product => this;

  const Product({
    this.id,
    this.panelId,
    required this.itemId,
    this.itemName,
    this.imagePath,
    this.sellingPrice,
    this.promotionPrice,
    this.discPercentage,
    this.lastPurchaseDate,
    this.startDate,
    this.endDate,
    this.orderNo,
    this.active,
    this.rowState,
    this.stock = 0,
    this.qtyPerCustomer = 0,
    this.units,
    this.existInCart,
    this.weightedItem,
    this.cartQuantity,
    this.existInWishlist = false,
    this.urlName,
    this.brandName,
    this.userRatings,
    this.disableAddToCart,
    this.disableReserveAndCollect,
    this.isServiceItem,
    this.itemCode,
    required this.unitId,
    this.itemSizes,
    this.itemStages,
  });

  @override
  String toString() {
    return 'Product(id: $id, panelId: $panelId, itemId: $itemId, itemName: $itemName, imagePath: $imagePath, sellingPrice: $sellingPrice, promotionPrice: $promotionPrice, discPercentage: $discPercentage, lastPurchaseDate: $lastPurchaseDate, startDate: $startDate, endDate: $endDate, orderNo: $orderNo, active: $active, rowState: $rowState, stock: $stock, qtyPerCustomer: $qtyPerCustomer, units: $units, existInCart: $existInCart, weightedItem: $weightedItem, cartQuantity: $cartQuantity, existInWishlist: $existInWishlist, urlName: $urlName, brandName: $brandName, userRatings: $userRatings, disableAddToCart: $disableAddToCart, disableReserveAndCollect: $disableReserveAndCollect, isServiceItem: $isServiceItem, itemCode: $itemCode, unitId: $unitId, itemSizes: $itemSizes, itemStages: $itemStages)';
  }

  double get rating {
    if (userRatings == null || userRatings!.isEmpty) {
      return 0;
    }
    return userRatings!.first.average;
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int?,
    panelId: json['panelID'] as int?,
    itemId: json['itemID'] as int,
    itemName: json['itemName'] as String?,
    imagePath: json['imagePath'] as String?,
    sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
    promotionPrice: (json['promotionPrice'] as num?)?.toDouble(),
    discPercentage: json['discPercentage'] as dynamic,
    lastPurchaseDate: json['lastPurchaseDate'] as dynamic,
    startDate: json['startDate'] as dynamic,
    endDate: json['endDate'] is String
        ? DateTime.parse(json['endDate'] as String)
        : null,
    orderNo: json['orderNo'] as dynamic,
    active: json['active'] as bool?,
    rowState: json['rowState'] as int?,
    stock: (json['stock'] as num? ?? 0).toInt(),
    qtyPerCustomer: (json['qtyPerCustomer'] as int?) ?? 0,
    units: (json['units'] as List<dynamic>?)
        ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
        .toList(),
    existInCart: json['existInCart'] as bool?,
    weightedItem: json['weightedItem'] as bool?,
    cartQuantity: json['cartQuantity'] as num?,
    existInWishlist: json['existInWishlist'] as bool? ?? false,
    urlName: json['urlName'] as String?,
    brandName: json['brandName'] as dynamic,
    userRatings: (json['userRatings'] as List<dynamic>?)
        ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
    disableAddToCart: json['disableAddToCart'] as bool?,
    disableReserveAndCollect: json['disableReserveAndCollect'] as bool?,
    isServiceItem: json['isServiceItem'] as bool?,
    itemCode: json['itemCode'] as String?,
    unitId: json['unitID'] as int,
    itemSizes: json['itemSizes'] as dynamic,
    itemStages: json['itemStages'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'panelID': panelId,
    'itemID': itemId,
    'itemName': itemName,
    'imagePath': imagePath,
    'sellingPrice': sellingPrice,
    'promotionPrice': promotionPrice,
    'discPercentage': discPercentage,
    'lastPurchaseDate': lastPurchaseDate,
    'startDate': startDate,
    'endDate': endDate?.toString(),
    'orderNo': orderNo,
    'active': active,
    'rowState': rowState,
    'stock': stock,
    'qtyPerCustomer': qtyPerCustomer,
    'units': units?.map((e) => e.toJson()).toList(),
    'existInCart': existInCart,
    'weightedItem': weightedItem,
    'cartQuantity': cartQuantity,
    'existInWishlist': existInWishlist,
    'urlName': urlName,
    'brandName': brandName,
    'userRatings': userRatings?.map((e) => e.toJson()).toList(),
    'disableAddToCart': disableAddToCart,
    'disableReserveAndCollect': disableReserveAndCollect,
    'isServiceItem': isServiceItem,
    'itemCode': itemCode,
    'unitID': unitId,
    'itemSizes': itemSizes,
    'itemStages': itemStages,
  };

  Map<String, dynamic> asMapForAnalytics(int quantity) => {
    if (itemName != null) 'item_name': itemName,
    'item_id': itemId.toString(),
    'item_category2': unitId.toString(),
    if (currentPrice != null) 'price': currentPrice,
    'quantity': quantity,
  };

  AnalyticsEventItem asAnalyticsEventItem(int quantity) => AnalyticsEventItem(
    itemName: itemName,
    itemId: itemId.toString(),
    itemCategory2: unitId.toString(),
    price: currentPrice,
    quantity: quantity,
  );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Product) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      panelId.hashCode ^
      itemId.hashCode ^
      itemName.hashCode ^
      imagePath.hashCode ^
      sellingPrice.hashCode ^
      promotionPrice.hashCode ^
      discPercentage.hashCode ^
      lastPurchaseDate.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      orderNo.hashCode ^
      active.hashCode ^
      rowState.hashCode ^
      stock.hashCode ^
      qtyPerCustomer.hashCode ^
      units.hashCode ^
      existInCart.hashCode ^
      weightedItem.hashCode ^
      cartQuantity.hashCode ^
      existInWishlist.hashCode ^
      urlName.hashCode ^
      brandName.hashCode ^
      userRatings.hashCode ^
      disableAddToCart.hashCode ^
      disableReserveAndCollect.hashCode ^
      isServiceItem.hashCode ^
      itemCode.hashCode ^
      unitId.hashCode ^
      itemSizes.hashCode ^
      itemStages.hashCode;
}
