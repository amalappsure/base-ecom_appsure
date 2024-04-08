import 'package:base_ecom_appsure/features/products/models/product.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'package:base_ecom_appsure/features/products/models/product_model_mixin.dart';
import 'package:base_ecom_appsure/features/products/models/unit.dart';
import 'item_delivery_option.dart';
import 'item_image.dart';
import 'item_meta_tag_model.dart';

@immutable
class ProductDetails with ProductModelMixin {
  final ItemMetaTagModel? itemMetaTagModel;
  final int id;
  final String? itemCode;
  final String? itemName;
  final String? arabicName;
  final String? shortDescription;
  final String? arabicShortDescription;
  final String? longDescription;
  final String? arabicLongDescription;
  final String? urlName;
  final String? imagePath;
  final String? itemImage;
  final String? videoUrl;
  final String? brandName;
  @override
  final double sellingPrice;
  @override
  final double? promotionPrice;
  final bool? active;
  final bool? saleOnEcommerce;
  final DateTime? endDate;
  final List<ItemImage> itemImages;
  final List<dynamic>? itemAttributes;
  final ItemDeliveryOption? itemDeliveryOption;
  final List<ItemDeliveryOption> itemDeliveryOptions;
  final List<Unit> itemUnitsList;
  @override
  final int stock;
  final int? priorityNo;
  @override
  final int qtyPerCustomer;
  final bool? existInCart;
  final bool? weightedItem;
  final double? cartQuantity;
  final bool existInWishlist;
  final int unitId;

  const ProductDetails({
    this.itemMetaTagModel,
    required this.id,
    this.itemCode,
    this.itemName,
    this.arabicName,
    this.shortDescription,
    this.arabicShortDescription,
    this.longDescription,
    this.arabicLongDescription,
    this.urlName,
    this.imagePath,
    this.itemImage,
    this.videoUrl,
    this.brandName,
    this.sellingPrice = 0,
    this.promotionPrice,
    this.active,
    this.saleOnEcommerce,
    this.endDate,
    this.itemImages = const [],
    this.itemAttributes,
    this.itemDeliveryOption,
    this.itemDeliveryOptions = const [],
    this.itemUnitsList = const [],
    this.stock = 0,
    this.priorityNo,
    this.qtyPerCustomer = 0,
    this.existInCart,
    this.weightedItem,
    this.cartQuantity = 0,
    this.existInWishlist = false,
    this.unitId = 0,
  });

  AnalyticsEventItem get asAnalyticsEventItem => AnalyticsEventItem(
    itemName: itemName,
    itemId: id.toString(),
    itemCategory2: unitId.toString(),
    price: currentPrice,
  );

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    id: json['id'] as int,
    itemCode: json['itemCode'] as dynamic,
    itemName: json['itemName'] as String?,
    arabicName: json['arabicName'] as String?,
    shortDescription: json['shortDescription'] as String?,
    arabicShortDescription: json['arabicShortDescription'] as String?,
    longDescription: json['longDescription'] as String?,
    arabicLongDescription: json['arabicLongDescription'] as String?,
    urlName: json['urlName'] as String?,
    imagePath: json['imagePath'] as String?,
    itemImage: json['itemImage'] as String?,
    videoUrl: json['videoUrl'] as String?,
    brandName: json['brandName'] as dynamic,
    sellingPrice: (json['sellingPrice'] as num? ?? 0).toDouble(),
    promotionPrice: (json['promotionPrice'] as num?)?.toDouble(),
    active: json['active'] as bool?,
    saleOnEcommerce: json['saleOnEcommerce'] as bool?,
    endDate: json['endDate'] is String
        ? DateTime.tryParse(json['endDate'] as String)
        : null,
    itemImages: (json['itemImages'] as List<dynamic>?)
        ?.map((e) => ItemImage.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
    itemAttributes: json['itemAttributes'] as List<dynamic>?,
    itemDeliveryOption: json['itemDeliveryOption'] == null
        ? null
        : ItemDeliveryOption.fromJson(
      json['itemDeliveryOption'] as Map<String, dynamic>,
    ),
    itemDeliveryOptions: (json['itemDeliveryOptions'] as List<dynamic>?)
        ?.map((e) =>
        ItemDeliveryOption.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
    itemUnitsList: (json['itemUnitsList'] as List<dynamic>?)
        ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
    stock: (json['stock'] as num? ?? 0).toInt(),
    priorityNo: json['priorityNo'] as int?,
    qtyPerCustomer: json['qtyPerCustomer'] as int? ?? 0,
    existInCart: json['existInCart'] as bool?,
    weightedItem: json['weightedItem'] as bool?,
    cartQuantity: (json['cartQuantity'] as num? ?? 0).toDouble(),
    existInWishlist: json['existInWishlist'] as bool? ?? false,
    itemMetaTagModel: json['itemMetaTagModel'] == null
        ? null
        : ItemMetaTagModel.fromJson(
      json['itemMetaTagModel'] as Map<String, dynamic>,
    ),
    unitId: json['unitID'] as int? ?? 0,
  );

  @override
  Product get product => Product.fromJson(toJson());

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'itemMetaTagModel': itemMetaTagModel?.toJson(),
      'id': id,
      'itemCode': itemCode,
      'itemName': itemName,
      'arabicName': arabicName,
      'shortDescription': shortDescription,
      'arabicShortDescription': arabicShortDescription,
      'longDescription': longDescription,
      'arabicLongDescription': arabicLongDescription,
      'urlName': urlName,
      'imagePath': imagePath,
      'itemImage': itemImage,
      'videoUrl': videoUrl,
      'brandName': brandName,
      'sellingPrice': sellingPrice,
      'promotionPrice': promotionPrice,
      'active': active,
      'saleOnEcommerce': saleOnEcommerce,
      'endDate': endDate?.toString(),
      'itemImages': itemImages.map((x) => x.toJson()).toList(),
      'itemAttributes': itemAttributes,
      'itemDeliveryOption': itemDeliveryOption?.toJson(),
      'itemDeliveryOptions':
      itemDeliveryOptions.map((x) => x.toJson()).toList(),
      'itemUnitsList': itemUnitsList.map((x) => x.toJson()).toList(),
      'units': itemUnitsList.map((x) => x.toJson()).toList(),
      'stock': stock,
      'priorityNo': priorityNo,
      'qtyPerCustomer': qtyPerCustomer,
      'existInCart': existInCart,
      'weightedItem': weightedItem,
      'cartQuantity': cartQuantity,
      'existInWishlist': existInWishlist,
      'unitId': unitId,
      'itemID': id,
      'unitID': unitId,
    };
  }
}
