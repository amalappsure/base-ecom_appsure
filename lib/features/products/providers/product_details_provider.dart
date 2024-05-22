import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/products/models/payment_methods.dart';
import 'package:base_ecom_appsure/features/products/models/product_details/product_details.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/remote_data.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

import 'package:base_ecom_appsure/features/products/models/product_panels.dart';

final productDetailsController =
StateProvider.family<ProductDetailsProvider, int>(
      (ref, family) => ProductDetailsProvider(ref),
);

final productDetailsProvider =
StateProvider.family<RemoteData<ProductDetails>, int>(
      (ref, family) => RemoteData(),
);

final similarItemsProvider =
StateProvider.family<RemoteData<ProductPanel>, int>(
      (ref, family) => RemoteData(),
);

final paymentMethodsProvider =
StateProvider.family<RemoteData<List<PaymentMethod>>, int>(
      (ref, family) => RemoteData(),
);

class ProductDetailsProvider {
  ProductDetailsProvider(
      this._ref,
      ) : _restClient = _ref.read(restClientProvider);

  final RestClient _restClient;
  final Ref _ref;

  String get _language => _ref.read(settingsProvider).selectedLocale!.name;

  Future<void> getProductDetails(
      int id, {
        int? unitId,
      }) async {
    final map = <String, dynamic>{};
    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("Language", () => _language);
    map.putIfAbsent("ID", () => id);
    if (unitId != null) {
      map.putIfAbsent("String3", () => unitId);
    }

    final notifier = _ref.read(productDetailsProvider(id).notifier);

    notifier.state = RemoteData();

    try {
      final response = await _restClient.getProductDetails(map);
      if (response.result == null) {
        notifier.state = RemoteData(
          error: AppException('Something went wrong'),
        );
      } else {
        notifier.state = RemoteData(data: response.result!);
        try {
          FirebaseAnalytics.instance.logViewItem(

            items: [response.result!.asAnalyticsEventItem],
          );
        } catch (e) {
          //
        }
        getSimilarItems(id);
        getPaymentTypesByItemID(id);
      }
    } catch (e) {
      notifier.state = RemoteData(
        error: AppException(e),
      );
    }
  }

  Future<void> getSimilarItems(int id) async {
    final map = <String, dynamic>{};

    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("Language", () => _language);
    map.putIfAbsent("ID", () => id);

    final notifier = _ref.read(similarItemsProvider(id).notifier);

    notifier.state = RemoteData();

    try {
      final response = await _restClient.getRelatedItemsList(map);
      notifier.state = RemoteData(data: response.panel!);
    } catch (e) {
      notifier.state = RemoteData(error: AppException(e));
    }
  }

  Future<void> getPaymentTypesByItemID(int id) async {
    final map = <String, dynamic>{};

    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("Language", () => _language);
    map.putIfAbsent("TypeObject", () => id);

    final notifier = _ref.read(paymentMethodsProvider(id).notifier);

    notifier.state = RemoteData();

    try {
      final response = await _restClient.getPaymentTypesByItemID(map);
      notifier.state = RemoteData(data: response.result);
    } catch (e) {
      notifier.state = RemoteData(data: []);
    }
  }
}
