import 'cart_item.dart';

class CartItems {
  CartItems({required this.items});

  final List<CartItem> items;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'result': items.map((x) => x.toJson()).toList(),
    };
  }

  factory CartItems.fromJson(Map<String, dynamic> map) {
    return CartItems(
      items: (map['result'] as List<dynamic>?)
          ?.map(
            (x) => CartItem.fromJson(x as Map<String, dynamic>),
      )
          .toList() ??
          [],
    );
  }

  @override
  String toString() => 'CartItems(items: $items)';
}
