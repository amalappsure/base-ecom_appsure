import 'dart:convert';

import 'package:async_queue/async_queue.dart';
import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/auth/providers/login_state_provider.dart';
import 'package:base_ecom_appsure/features/products/models/product.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

import '../models/cart_item.dart';
import '../models/cart_items.dart';

final cartProvider = ChangeNotifierProvider<CartProvider>(
      (ref) => CartProvider(ref),
);

class CartProvider extends ChangeNotifier {
  CartProvider(this._ref) : _restClient = _ref.read(restClientProvider) {
    loadCartFromLocal();
    loadCartFromRemote();
    _initListeners();
  }

  final Ref _ref;
  final RestClient _restClient;
  final autoAsyncQ = AsyncQueue.autoStart();
  final List<CartItem> _items = [];
  int? _quickBuyUnitId;
  int? _quickBuyItemId;
  String? _promoCode;

  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  // Getters
  num get cartValue {
    num value = 0;
    List<CartItem> items;

    if (_quickBuyItemId != null && _quickBuyUnitId != null) {
      items = [_item(_quickBuyItemId!, _quickBuyUnitId!)!];
    } else {
      items = _items;
    }

    for (final item in items) {
      value += (item.sellingPrice * item.quantity);
    }

    return value;
  }

  String get cartValueString {
    return _ref.read(settingsProvider).priceText(
      cartValue.toDouble(),
    );
  }

  int get particularsCount => _items.length;

  int get itemsCount {
    int count = 0;
    List<CartItem> items;

    if (_quickBuyItemId != null && _quickBuyUnitId != null) {
      final quickBuyItem = _item(_quickBuyItemId!, _quickBuyUnitId!);
      if (quickBuyItem != null) {
        items = [quickBuyItem];
      } else {
        items = _items;
      }
    } else {
      items = _items;
    }

    for (final item in items) {
      count += item.quantity;
    }

    return count;
  }

  bool get isNotEmpty => _items.isNotEmpty;

  List<CartItem> get items {
    if (_quickBuyItemId != null && _quickBuyUnitId != null) {
      final item = _item(_quickBuyItemId!, _quickBuyUnitId!);
      if (item == null) {
        _quickBuyItemId = null;
        _quickBuyUnitId = null;
      } else {
        return [item];
      }
    }
    return _items;
  }

  String get _language => _ref.read(settingsProvider).selectedLocale!.name;

  bool get isLoggedIn => _ref.read(loginStateProvider) is LoggedIn;

  int? get quickBuyUnitId => _quickBuyUnitId;

  int? get quickBuyItemId => _quickBuyItemId;

  CartItem? _item(int itemId, int unitId) {
    return _items.firstWhereOrNull(
          (element) => element.itemId == itemId && element.unitId == unitId,
    );
  }

  bool contains(int itemId, int unitId) => _item(itemId, unitId) != null;

  int countOf(int itemId, int unitId) => _item(itemId, unitId)?.quantity ?? 0;

  double totalPriceOf(int itemId, int unitId) {
    final item = _item(itemId, unitId);
    final count = item?.quantity ?? 0;

    return (count * (item?.sellingPrice ?? 0));
  }

  double get totalPromoDiscount {
    double value = 0;
    for (final item in _items) {
      value += item.promoCodeDisc ?? 0;
    }
    return value;
  }

  String? get promoCode => _promoCode;

  set promoCode(String? value) {
    _promoCode = value;
    notifyListeners();
  }

  // Initialise Listeners
  void _initListeners() {
    autoAsyncQ.addQueueListener((QueueEvent event) {
      if (event.type == QueueEventType.queueEnd) {
        loadCartFromRemote();
      }
    });
    _ref.listen(loginStateProvider, (previous, next) {
      if (previous is! LoggedIn && next is LoggedIn && _items.isNotEmpty) {
        for (final item in _items) {
          autoAsyncQ.addJob((previousResult) => _updateRemoteCart(
            itemId: item.itemId,
            unitId: item.unitId,
            difference: item.quantity,
          ));
        }
      } else if (next is! LoginRequired) {
        loadCartFromRemote();
      }
    });
    _ref.listen(settingsProvider, (previous, next) {
      loadCartFromRemote();
    });
  }

  // Load Cart
  Future<void> loadCartFromRemote() async {
    if (!isLoggedIn) return;
    final map = <String, dynamic>{};

    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("Language", () => _language);
    if (_promoCode != null) {
      map.putIfAbsent("TypeObject", () => _promoCode);
    }

    final response = await _restClient.getCartItemsList(map);

    _items.clear();
    _items.addAll(response.items);

    updateLocalCart();

    notifyListeners();
  }

  void loadCartFromLocal() {
    final fromCache = HiveRepo.instance.readData(
      'Cart-$_language',
    );

    if (fromCache == null) return;
    final response = CartItems.fromJson(
      json.decode(fromCache),
    );

    _items.clear();
    _items.addAll(response.items);

    notifyListeners();
  }

  // Update Cart
  Future<void> _updateRemoteCart({
    required int itemId,
    required int unitId,
    required int difference,
  }) async {
    if (!isLoggedIn) return;
    final map = <String, dynamic>{};

    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("ItemID", () => itemId);
    map.putIfAbsent("UnitID", () => unitId);
    map.putIfAbsent("Quantity", () => difference);

    await _restClient.insertCartItems({"TypeObject": map});
  }

  Future<void> updateLocalCart() async {
    await HiveRepo.instance.storeData(
      'Cart-$_language',
      json.encode(CartItems(items: _items).toJson()),
    );
  }

  // Add or Remove from Cart
  Future<void> removeFromCart(int itemId, int unitId) async {
    final item = _item(itemId, unitId);
    final id = item?.id;

    if (item != null) {
      try {
        analytics.logRemoveFromCart(
          currency: 'KWD',
          value: item.quantity * item.sellingPrice,
          items: [item.analyticsEventItem],
        );
      } catch (e) {
        //
      }
    }

    if (id != null && id != 0) {
      autoAsyncQ.addJob((previousResult) => _removeFromRemoteCart(id));
    }

    _items.removeWhere((element) => element.itemId == itemId);
    await updateLocalCart();

    notifyListeners();
  }

  Future<void> clearRemoteCart() async {
    final list = <Future>[];
    for (final item in _items) {
      list.add(_removeFromRemoteCart(item.id));
    }
    await Future.wait(list);
    await clearLocalCart();
    await loadCartFromRemote();
  }

  Future<void> _removeFromRemoteCart(int id) async {
    if (!isLoggedIn) return;
    final map = {
      "Username": HiveRepo.instance.userName,
      "ID": id,
    };

    await _restClient.removeCartItem(map);
  }

  Future<void> addToCart(Product product, final int count) async {
    if (count <= 0) {
      removeFromCart(product.itemId, product.unitId);
      return;
    }

    final currentQuantity = countOf(
      product.itemId,
      product.unitId,
    );

    if (count == currentQuantity) return;

    final difference = count - currentQuantity;
    final reduce = difference < 0;

    if (reduce && currentQuantity <= 1) {
      removeFromCart(product.itemId, product.unitId);
      return;
    } else if (currentQuantity < 1) {
      await _addToLocalCart(product, count);
    } else {
      _item(product.itemId, product.unitId)?.quantity = count;
      updateLocalCart();
    }

    try {
      analytics.logAddToCart(
        items: [product.asAnalyticsEventItem(count)],
        value: count * (product.currentPrice ?? 0),
        currency: 'KWD',
      );
    } catch (e) {
      //
    }

    notifyListeners();

    autoAsyncQ.addJob((previousResult) => _updateRemoteCart(
      itemId: product.itemId,
      unitId: product.unitId,
      difference: difference,
    ));
  }

  Future<void> incrOrDecrItemCount(
      Product product, {
        int? number,
        bool decrease = false,
      }) async {
    final currentQuantity = countOf(
      product.itemId,
      product.unitId,
    );

    if (currentQuantity == 1 && decrease) return;

    int count;

    if (decrease) {
      count = currentQuantity - (number ?? 1);
    } else {
      count = currentQuantity + (number ?? 1);
    }

    addToCart(product, count);
  }

  Future<void> _addToLocalCart(Product product, int count) async {
    _items.add(CartItem(
      id: 0,
      itemId: product.itemId,
      unitId: product.unitId,
      unit: product.units
          ?.firstWhereOrNull((element) => element.unitId == product.unitId)
          ?.unit,
      itemName: product.itemName,
      urlName: product.urlName,
      itemImage: product.imagePath,
      sellingPrice: product.currentPrice ?? 0,
      stock: product.stock,
      quantity: count,
      subTotal: count * (product.currentPrice ?? 0),
    ));
    await updateLocalCart();
    notifyListeners();
  }

  Future<void> clearLocalCart() async {
    _items.clear();
    await updateLocalCart();
    notifyListeners();
  }

  Future<bool> validatePromoCode(String code) async {
    promoCode = null;
    try {
      final response = await _restClient.validatePromoCode({
        "Language": _language,
        "Username": HiveRepo.instance.userName,
        "String1": code,
      });

      final result = response['result'] as bool;
      if (result) {
        promoCode = code;
      } else {
        promoCode = null;
      }
      loadCartFromRemote();
      return result;
    } catch (e) {
      promoCode = null;
      loadCartFromRemote();
      throw AppException(e);
    }
  }

  // Quick Buy / Buy Now
  void setquickBuy(int unitId, int itemId) {
    _quickBuyUnitId = unitId;
    _quickBuyItemId = itemId;
    notifyListeners();
  }

  void clearQuickBuy() {
    _quickBuyUnitId = null;
    _quickBuyItemId = null;
    notifyListeners();
  }

  void clearPromoCode() {
    promoCode = null;
  }
}

typedef RunCartingAnim = Future<void> Function(
    GlobalKey? globalKey,
    );
