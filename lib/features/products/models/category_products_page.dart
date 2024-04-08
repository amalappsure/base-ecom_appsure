// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'product.dart';

@immutable
class CategoryProductsResp {
  const CategoryProductsResp({required this.page});
  final CategoryProductsPage page;

  Map<String, dynamic> toJson() => {
    'result': page.toJson(),
  };

  factory CategoryProductsResp.fromJson(Map<String, dynamic> map) =>
      CategoryProductsResp(
        page: CategoryProductsPage.fromJson(
            map['result'] as Map<String, dynamic>),
      );

  @override
  String toString() => 'CategoryProductsResp(page: $page)';
}

@immutable
class CategoryProductsPage {
  final int? sortby;
  final String? type;
  final int? pageNo;
  final int? totalPages;
  final String? keyword;
  final String? title;
  final int? parentId;
  final String? parentTitle;
  final bool? inStock;
  final bool? outOfStock;
  final double? priceMin;
  final double? priceMax;
  final double filterPriceMin;
  final double filterPriceMax;
  final int? brandId;
  final List<Product> itemList;
  final double? listPriceMin;
  final int? id;
  final int? menuId;
  final int? companyId;
  final int? perPage;

  const CategoryProductsPage({
    this.sortby,
    this.type,
    this.pageNo,
    this.totalPages,
    this.keyword,
    this.title,
    this.parentId,
    this.parentTitle,
    this.inStock,
    this.outOfStock,
    this.priceMin,
    this.priceMax,
    required this.filterPriceMin,
    required this.filterPriceMax,
    this.brandId,
    this.itemList = const [],
    this.listPriceMin,
    this.id,
    this.menuId,
    this.companyId,
    this.perPage,
  });

  @override
  String toString() {
    return 'CategoryProductsPage(sortby: $sortby, type: $type, pageNo: $pageNo, totalPages: $totalPages, keyword: $keyword, title: $title, parentId: $parentId, parentTitle: $parentTitle, inStock: $inStock, outOfStock: $outOfStock, priceMin: $priceMin, priceMax: $priceMax, filterPriceMin: $filterPriceMin, filterPriceMax: $filterPriceMax, brandId: $brandId, itemList: $itemList, listPriceMin: $listPriceMin, id: $id, menuId: $menuId, companyId: $companyId, perPage: $perPage)';
  }

  factory CategoryProductsPage.fromJson(Map<String, dynamic> json) {
    return CategoryProductsPage(
      sortby: json['sortby'] as int?,
      type: json['type'] as dynamic,
      pageNo: json['pageNo'] as int?,
      totalPages: json['totalPages'] as int?,
      keyword: json['keyword'] as dynamic,
      title: json['title'] as String?,
      parentId: json['parentID'] as int?,
      parentTitle: json['parentTitle'] as String?,
      inStock: json['inStock'] as bool?,
      outOfStock: json['outOfStock'] as bool?,
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
      filterPriceMin: (json['filterPriceMin'] as num?)?.toDouble() ?? 0.0,
      filterPriceMax: (json['filterPriceMax'] as num?)?.toDouble() ?? 0.0,
      brandId: json['brandID'] as int?,
      itemList: (json['itemList'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      listPriceMin: (json['listPriceMin'] as num?)?.toDouble(),
      id: json['id'] as int?,
      menuId: json['menuID'] as int?,
      companyId: json['companyID'] as int?,
      perPage: json['perPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'sortby': sortby,
    'type': type,
    'pageNo': pageNo,
    'totalPages': totalPages,
    'keyword': keyword,
    'title': title,
    'parentID': parentId,
    'parentTitle': parentTitle,
    'inStock': inStock,
    'outOfStock': outOfStock,
    'priceMin': priceMin,
    'priceMax': priceMax,
    'filterPriceMin': filterPriceMin,
    'filterPriceMax': filterPriceMax,
    'brandID': brandId,
    'itemList': itemList.map((e) => e.toJson()).toList(),
    'listPriceMin': listPriceMin,
    'id': id,
    'menuID': menuId,
    'companyID': companyId,
    'perPage': perPage,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CategoryProductsPage) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      sortby.hashCode ^
      type.hashCode ^
      pageNo.hashCode ^
      totalPages.hashCode ^
      keyword.hashCode ^
      title.hashCode ^
      parentId.hashCode ^
      parentTitle.hashCode ^
      inStock.hashCode ^
      outOfStock.hashCode ^
      priceMin.hashCode ^
      priceMax.hashCode ^
      filterPriceMin.hashCode ^
      filterPriceMax.hashCode ^
      brandId.hashCode ^
      itemList.hashCode ^
      listPriceMin.hashCode ^
      id.hashCode ^
      menuId.hashCode ^
      companyId.hashCode ^
      perPage.hashCode;
}
