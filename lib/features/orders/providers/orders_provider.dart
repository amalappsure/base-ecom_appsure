import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/orders/models/order_details_resp/result.dart';
import 'package:base_ecom_appsure/features/orders/models/orders_list/orders_list_result.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/remote_data.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

final ordersListProvider =
StateProvider.autoDispose<RemoteData<OrdersListResult>>(
      (ref) => RemoteData.loading(),
);

final ordersProvider = StateProvider.autoDispose(
      (ref) => OrdersProvider(ref),
);

class OrdersProvider {
  OrdersProvider(this._ref) : _ecomClient = _ref.read(restClientProvider);
  final RestClient _ecomClient;
  final Ref _ref;

  String? get _language => _ref.read(settingsProvider).selectedLocale?.name;

  Future<void> getOrders({bool refresh = false}) async {
    final provider = _ref.read(ordersListProvider.notifier);

    if (refresh) {
      provider.state = RemoteData.loading();
    }

    try {
      final response = await _ecomClient.getSalesOrderList({
        "Username": HiveRepo.instance.userName,
        "Language": _language,
      });

      provider.state = RemoteData.data(data: response.result!);
    } catch (e) {
      provider.state = RemoteData.error(error: AppException(e.toString()));
    }
  }

  Future<OrderDetails> getOrderDetails(int voucherId) async {
    try {
      final response = await _ecomClient.getOrderDetails({
        "Username": HiveRepo.instance.userName,
        "Language": _language,
        "ID": voucherId.toString(),
      });
      return response.result!;
    } catch (e) {
      throw AppException(e);
    }
  }

  Future<void> requestCancellation(int voucherId, String reason) async {
    try {
      await _ecomClient.putCancelRequest({
        "Username": HiveRepo.instance.userName,
        "Language": _language,
        "ID": voucherId.toString(),
        "String1": reason,
      });
    } catch (e) {
      throw AppException(e);
    }
  }
}
