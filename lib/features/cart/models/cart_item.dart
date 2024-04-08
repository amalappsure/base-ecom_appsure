import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class CartItem {
  final int id;
  final String? username;
  final DateTime? date;
  int quantity;
  final int itemId;
  final dynamic brandId;
  final int? qtyPerCustomer;
  final String? itemName;
  final String? urlName;
  final double sellingPrice;
  final dynamic brandName;
  final double? subTotal;
  final double? total;
  final int count;
  final String? itemImage;
  final dynamic string1;
  final int stock;
  final int? deliveryCharge;
  final dynamic deliveryOption;
  final dynamic orderDid;
  final int unitId;
  final String? unit;
  final bool? weightedItem;
  final bool? isDigitalCard;
  final int? cartDiscount;
  final double actualPrice;
  final String? itemCode;
  final double? promoCodeDisc;

  CartItem({
    required this.id,
    this.username,
    this.date,
    this.quantity = 0,
    required this.itemId,
    this.brandId,
    this.qtyPerCustomer,
    this.itemName,
    this.urlName,
    this.sellingPrice = 0,
    this.brandName,
    this.subTotal,
    this.total,
    this.count = 0,
    this.itemImage,
    this.string1,
    this.stock = 0,
    this.deliveryCharge,
    this.deliveryOption,
    this.orderDid,
    required this.unitId,
    this.unit,
    this.weightedItem,
    this.isDigitalCard,
    this.cartDiscount,
    this.actualPrice = 0,
    this.itemCode,
    this.promoCodeDisc,
  });

  @override
  String toString() {
    return 'CartItem(id: $id, username: $username, date: $date, quantity: $quantity, itemId: $itemId, brandId: $brandId, qtyPerCustomer: $qtyPerCustomer, itemName: $itemName, urlName: $urlName, sellingPrice: $sellingPrice, brandName: $brandName, subTotal: $subTotal, total: $total, count: $count, itemImage: $itemImage, string1: $string1, stock: $stock, deliveryCharge: $deliveryCharge, deliveryOption: $deliveryOption, orderDid: $orderDid, unitId: $unitId, unit: $unit, weightedItem: $weightedItem, isDigitalCard: $isDigitalCard, cartDiscount: $cartDiscount, actualPrice: $actualPrice, itemCode: $itemCode, promoCodeDisc: $promoCodeDisc)';
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'] as int,
    username: json['username'] as String?,
    date: json['date'] == null
        ? null
        : DateTime.parse(json['date'] as String),
    quantity: (json['quantity'] as num? ?? 0.0).toInt(),
    itemId: json['itemID'] as int,
    brandId: json['brandID'] as dynamic,
    qtyPerCustomer: json['qtyPerCustomer'] as int?,
    itemName: json['itemName'] as String?,
    urlName: json['urlName'] as String?,
    sellingPrice: (json['sellingPrice'] as num? ?? 0).toDouble(),
    brandName: json['brandName'] as dynamic,
    subTotal: (json['subTotal'] as num?)?.toDouble(),
    total: (json['total'] as num?)?.toDouble(),
    count: json['count'] as int? ?? 0,
    itemImage: json['itemImage'] as String?,
    string1: json['string1'] as dynamic,
    stock: (json['stock'] as num? ?? 0).toInt(),
    deliveryCharge: json['deliveryCharge'] as int?,
    deliveryOption: json['deliveryOption'] as dynamic,
    orderDid: json['orderDID'] as dynamic,
    unitId: json['unitID'] as int,
    unit: json['unit'] as String?,
    weightedItem: json['weightedItem'] as bool?,
    isDigitalCard: json['isDigitalCard'] as bool?,
    cartDiscount: (json['cartDiscount'] as num? ?? 0).toInt(),
    actualPrice: (json['actualPrice'] as num? ?? 0).toDouble(),
    itemCode: json['itemCode'] as String?,
    promoCodeDisc: (json['promoCodeDisc'] as num? ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'date': date?.toIso8601String(),
    'quantity': quantity,
    'itemID': itemId,
    'brandID': brandId,
    'qtyPerCustomer': qtyPerCustomer,
    'itemName': itemName,
    'urlName': urlName,
    'sellingPrice': sellingPrice,
    'brandName': brandName,
    'subTotal': subTotal,
    'total': total,
    'count': count,
    'itemImage': itemImage,
    'string1': string1,
    'stock': stock,
    'deliveryCharge': deliveryCharge,
    'deliveryOption': deliveryOption,
    'orderDID': orderDid,
    'unitID': unitId,
    'unit': unit,
    'weightedItem': weightedItem,
    'isDigitalCard': isDigitalCard,
    'cartDiscount': cartDiscount,
    'actualPrice': actualPrice,
    'itemCode': itemCode,
    'promoCodeDisc': promoCodeDisc,
  };

  bool get isOnOffer => sellingPrice < actualPrice;

  Map<String, dynamic> asMapForAnalytics() => {
    if (itemName != null) 'item_name': itemName,
    'item_id': itemId.toString(),
    'item_category2': unitId.toString(),
    'price': sellingPrice,
    'quantity': quantity,
  };

  AnalyticsEventItem get analyticsEventItem => AnalyticsEventItem(
    itemName: itemName,
    itemId: itemId.toString(),
    itemCategory2: unitId.toString(),
    price: sellingPrice,
    quantity: quantity,
  );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CartItem) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      date.hashCode ^
      quantity.hashCode ^
      itemId.hashCode ^
      brandId.hashCode ^
      qtyPerCustomer.hashCode ^
      itemName.hashCode ^
      urlName.hashCode ^
      sellingPrice.hashCode ^
      brandName.hashCode ^
      subTotal.hashCode ^
      total.hashCode ^
      count.hashCode ^
      itemImage.hashCode ^
      string1.hashCode ^
      stock.hashCode ^
      deliveryCharge.hashCode ^
      deliveryOption.hashCode ^
      orderDid.hashCode ^
      unitId.hashCode ^
      unit.hashCode ^
      weightedItem.hashCode ^
      isDigitalCard.hashCode ^
      cartDiscount.hashCode ^
      actualPrice.hashCode ^
      itemCode.hashCode ^
      promoCodeDisc.hashCode;
}
