import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'product.dart';

@immutable
class GetPanelsResp {
  final bool status;
  final String statusCode;
  final String message;
  final List<ProductPanel> panels;

  const GetPanelsResp({
    required this.status,
    required this.statusCode,
    required this.message,
    this.panels = const [],
  });

  @override
  String toString() {
    return 'GetCategoryListResp(status: $status, statusCode: $statusCode, message: $message, result: $panels)';
  }

  factory GetPanelsResp.fromJson(Map<String, dynamic> json) {
    return GetPanelsResp(
      status: json['status'] as bool,
      statusCode: json['statusCode'] as String,
      message: json['message'] as String,
      panels: (json['result'] as List<dynamic>?)
          ?.map((e) => ProductPanel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': panels.map((x) => x.toJson()).toList(),
  };
}

@immutable
class ProductPanel {
  final int id;
  final String title;
  final List<Product> panelProducts;

  const ProductPanel({
    required this.id,
    required this.title,
    this.panelProducts = const [],
  });

  @override
  String toString() {
    return 'ProductPanel(id: $id, title: $title, panelProducts: $panelProducts)';
  }

  factory ProductPanel.fromJson(Map<String, dynamic> json) => ProductPanel(
    id: json['id'] as int,
    title: json['title'] as String,
    panelProducts: (json['panelProducts'] as List<dynamic>?)
        ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'panelProducts': panelProducts.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ProductPanel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ panelProducts.hashCode;
}
