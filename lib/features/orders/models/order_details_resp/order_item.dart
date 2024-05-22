import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class OrderItem {
  final int? itemId;
  final dynamic unitId;
  final String? itemImage;
  final String? itemName;
  final String? unit;
  final double? quantity;

  final double? sellingPrice;
  final double? actualPrice;
  final double? subTotal;
  final double? total;

  final dynamic brandId;
  final dynamic brandName;
  final int? qtyPerCustomer;
  final String? date;
  final bool? processed;

  final int? count;
  final double? stock;
  final dynamic orderDid;
  final dynamic deliveryCharge;
  final String? deliveryOption;
  final bool? weightedItem;
  final bool? isDigitalCard;
  final String? serialNo;
  final double? digiCardTodayAmount;
  final String? urlName;
  final dynamic varSizeId;
  final dynamic varColourId;
  final dynamic varDailColourId;
  final bool? isDirectBuy;
  final dynamic cartDiscount;
  final String? itemCode;
  final double? promoCodeDisc;
  final int? id;
  final int? menuId;
  final int? companyId;

  const OrderItem({
    this.itemId,
    this.itemImage,
    this.brandId,
    this.brandName,
    this.itemName,
    this.quantity,
    this.qtyPerCustomer,
    this.date,
    this.sellingPrice,
    this.processed,
    this.subTotal,
    this.total,
    this.count,
    this.stock,
    this.orderDid,
    this.deliveryCharge,
    this.deliveryOption,
    this.unitId,
    this.unit,
    this.weightedItem,
    this.isDigitalCard,
    this.serialNo,
    this.digiCardTodayAmount,
    this.urlName,
    this.varSizeId,
    this.varColourId,
    this.varDailColourId,
    this.isDirectBuy,
    this.cartDiscount,
    this.actualPrice,
    this.itemCode,
    this.promoCodeDisc,
    this.id,
    this.menuId,
    this.companyId,
  });

  @override
  String toString() {
    return 'OrderItem(itemId: $itemId, itemImage: $itemImage, brandId: $brandId, brandName: $brandName, itemName: $itemName, quantity: $quantity, qtyPerCustomer: $qtyPerCustomer, date: $date, sellingPrice: $sellingPrice, processed: $processed, subTotal: $subTotal, total: $total, count: $count, stock: $stock, orderDid: $orderDid, deliveryCharge: $deliveryCharge, deliveryOption: $deliveryOption, unitId: $unitId, unit: $unit, weightedItem: $weightedItem, isDigitalCard: $isDigitalCard, serialNo: $serialNo, digiCardTodayAmount: $digiCardTodayAmount, urlName: $urlName, varSizeId: $varSizeId, varColourId: $varColourId, varDailColourId: $varDailColourId, isDirectBuy: $isDirectBuy, cartDiscount: $cartDiscount, actualPrice: $actualPrice, itemCode: $itemCode, promoCodeDisc: $promoCodeDisc, id: $id, menuId: $menuId, companyId: $companyId)';
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    itemId: json['itemID'] as int?,
    itemImage: json['itemImage'] as String?,
    brandId: json['brandID'] as dynamic,
    brandName: json['brandName'] as dynamic,
    itemName: json['itemName'] as String?,
    quantity: (json['quantity'] as num? ?? 0).toDouble(),
    qtyPerCustomer: json['qtyPerCustomer'] as int?,
    date: json['date'] as String?,
    sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
    processed: json['processed'] as bool?,
    subTotal: (json['subTotal'] as num?)?.toDouble(),
    total: (json['total'] as num?)?.toDouble(),
    count: json['count'] as int?,
    stock: (json['stock'] as num? ?? 0).toDouble(),
    orderDid: json['orderDID'] as dynamic,
    deliveryCharge: json['deliveryCharge'] as dynamic,
    deliveryOption: json['deliveryOption'] as String?,
    unitId: json['unitID'] as dynamic,
    unit: json['unit'] as String?,
    weightedItem: json['weightedItem'] as bool?,
    isDigitalCard: json['isDigitalCard'] as bool?,
    serialNo: json['serialNo'] as String?,
    digiCardTodayAmount:
    (json['digiCardTodayAmount'] as num? ?? 0).toDouble(),
    urlName: json['urlName'] as String?,
    varSizeId: json['varSizeID'] as dynamic,
    varColourId: json['varColourID'] as dynamic,
    varDailColourId: json['varDailColourID'] as dynamic,
    isDirectBuy: json['isDirectBuy'] as bool?,
    cartDiscount: json['cartDiscount'] as dynamic,
    actualPrice: (json['actualPrice'] as num? ?? 0).toDouble(),
    itemCode: json['itemCode'] as String?,
    promoCodeDisc: (json['promoCodeDisc'] as num? ?? 0).toDouble(),
    id: json['id'] as int?,
    menuId: json['menuID'] as int?,
    companyId: json['companyID'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'itemID': itemId,
    'itemImage': itemImage,
    'brandID': brandId,
    'brandName': brandName,
    'itemName': itemName,
    'quantity': quantity,
    'qtyPerCustomer': qtyPerCustomer,
    'date': date,
    'sellingPrice': sellingPrice,
    'processed': processed,
    'subTotal': subTotal,
    'total': total,
    'count': count,
    'stock': stock,
    'orderDID': orderDid,
    'deliveryCharge': deliveryCharge,
    'deliveryOption': deliveryOption,
    'unitID': unitId,
    'unit': unit,
    'weightedItem': weightedItem,
    'isDigitalCard': isDigitalCard,
    'serialNo': serialNo,
    'digiCardTodayAmount': digiCardTodayAmount,
    'urlName': urlName,
    'varSizeID': varSizeId,
    'varColourID': varColourId,
    'varDailColourID': varDailColourId,
    'isDirectBuy': isDirectBuy,
    'cartDiscount': cartDiscount,
    'actualPrice': actualPrice,
    'itemCode': itemCode,
    'promoCodeDisc': promoCodeDisc,
    'id': id,
    'menuID': menuId,
    'companyID': companyId,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderItem) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      itemId.hashCode ^
      itemImage.hashCode ^
      brandId.hashCode ^
      brandName.hashCode ^
      itemName.hashCode ^
      quantity.hashCode ^
      qtyPerCustomer.hashCode ^
      date.hashCode ^
      sellingPrice.hashCode ^
      processed.hashCode ^
      subTotal.hashCode ^
      total.hashCode ^
      count.hashCode ^
      stock.hashCode ^
      orderDid.hashCode ^
      deliveryCharge.hashCode ^
      deliveryOption.hashCode ^
      unitId.hashCode ^
      unit.hashCode ^
      weightedItem.hashCode ^
      isDigitalCard.hashCode ^
      serialNo.hashCode ^
      digiCardTodayAmount.hashCode ^
      urlName.hashCode ^
      varSizeId.hashCode ^
      varColourId.hashCode ^
      varDailColourId.hashCode ^
      isDirectBuy.hashCode ^
      cartDiscount.hashCode ^
      actualPrice.hashCode ^
      itemCode.hashCode ^
      promoCodeDisc.hashCode ^
      id.hashCode ^
      menuId.hashCode ^
      companyId.hashCode;
}
