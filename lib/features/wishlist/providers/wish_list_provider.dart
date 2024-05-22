import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:async_queue/async_queue.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/remote_data.dart';
import 'package:base_ecom_appsure/features/wishlist/models/wish_list_item.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

import '../../auth/providers/login_state_provider.dart';

final wishListProvider = ChangeNotifierProvider<WishListProvider>(
      (ref) => WishListProvider(ref),
);

class WishListProvider extends ChangeNotifier {
  WishListProvider(this._ref) : _restClient = _ref.read(restClientProvider) {
    autoAsyncQ.addQueueListener((QueueEvent event) {
      if (event.type == QueueEventType.queueEnd) {
        getWishlistItemsList();
      }
    });
    _ref.listen(loginStateProvider, (previous, next) {
      if (next is! LoginRequired) {
        getWishlistItemsList();
      }
    });
    _ref.listen(settingsProvider, (previous, next) {
      getWishlistItemsList();
    });
    getWishlistItemsList();
  }
  final Ref _ref;
  final RestClient _restClient;

  final autoAsyncQ = AsyncQueue.autoStart();

  String get _language => _ref.read(settingsProvider).selectedLocale!.name;

  RemoteData<List<WishListItem>> _list = RemoteData();

  RemoteData<List<WishListItem>> get listState => _list;

  List<WishListItem> get wishList {
    if (!_list.isSuccess) {
      return [];
    } else {
      return _list.data ?? [];
    }
  }

  bool existInWishList(int id) => itemWithProductId(id) != null;

  WishListItem? itemWithProductId(int id) {
    return wishList.firstWhereOrNull(
          (element) => element.itemId == id,
    );
  }

  Future<void> getWishlistItemsList() async {
    if (!_list.isSuccess) {
      _list = RemoteData();
    }
    notifyListeners();
    final map = <String, dynamic>{};

    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("Language", () => _language);

    try {
      final response = await _restClient.getWishlistItemsList(map);

      _list = RemoteData(data: response.items);
    } catch (e) {
      if (!_list.isSuccess) {
        _list = RemoteData(error: AppException(e));
      }
    }
    notifyListeners();
  }

  Future<void> insertwishlistItems(int itemId, int unitId) async {
    final map = <String, dynamic>{};

    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("ItemID", () => itemId);

    map.putIfAbsent("UnitID", () => unitId);
    map.putIfAbsent("Quantity", () => 1);

    autoAsyncQ.addJob(
          (previousResult) => _restClient.insertwishlistItems(
        {"TypeObject": map},
      ),
    );
  }

  Future<void> removeWishlistItem(int id) async {
    final map = {
      "Username": HiveRepo.instance.userName,
      "ID": id,
    };

    final newList = <WishListItem>[..._list.data ?? []];

    newList.removeWhere((element) => element.id == id);

    _list = RemoteData(data: newList);

    notifyListeners();

    autoAsyncQ.addJob(
          (previousResult) => _restClient.removeWishlistItem(map),
    );
  }
}
