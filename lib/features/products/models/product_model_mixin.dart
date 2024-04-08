import 'dart:math';

import 'product.dart';

mixin ProductModelMixin {
  double? get sellingPrice;
  double? get promotionPrice;
  int get stock;
  int get qtyPerCustomer;
  Product get product;

  double? get currentPrice => promotionPrice ?? sellingPrice;

  int? get discountPercentage {
    if ((sellingPrice ?? 0) <= 0) {
      return null;
    }

    if ((promotionPrice ?? 0) <= 0) {
      return null;
    }

    if (sellingPrice == promotionPrice) {
      return null;
    }

    return ((((sellingPrice! - promotionPrice!) / sellingPrice!) * 100) + 0.01).floor();
  }

  int get maxAllowedCount {
    return min(
      stock,
      (qtyPerCustomer < 1 ? stock : qtyPerCustomer),
    );
  }

  bool get quantityPerCustomerEnabled => qtyPerCustomer > 0;
}
