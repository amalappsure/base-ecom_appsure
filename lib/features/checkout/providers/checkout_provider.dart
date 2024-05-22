import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/checkout/models/area_details.dart';
import 'package:base_ecom_appsure/features/checkout/models/checkout_options.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/remote_data.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

final checkoutOptionsProvider =
StateProvider.autoDispose<RemoteData<CheckoutOptions>>(
      (ref) => RemoteData(),
);

final areaDetails = StateProvider.autoDispose<RemoteData<AreaDetails>>(
      (ref) => RemoteData(),
);

final checkoutProvider = StateProvider.autoDispose<CheckoutProvider>(
      (ref) => CheckoutProvider(ref),
);

class CheckoutProvider {
  CheckoutProvider(this._ref) : _restClient = _ref.read(restClientProvider);
  final RestClient _restClient;
  final Ref _ref;

  String get _language => _ref.read(settingsProvider).selectedLocale!.name;

  AppConfig get _appConfig => _ref.read(appConfigProvider);

  Future<void> getCheckoutOptions() async {
    final map = <String, dynamic>{};
    map.putIfAbsent("Username", () => HiveRepo.instance.user?.username ?? '');
    map.putIfAbsent("Language", () => _language);

    final notifier = _ref.read(checkoutOptionsProvider.notifier);

    if (!notifier.state.isLoading) {
      notifier.state = RemoteData();
    }

    try {
      final response = await _restClient.getCheckoutOptions(map);

      final deliverySlotsEnabled = _appConfig.deliveryTimeSlotAllocation;

      final data = CheckoutOptions.fromJson(
        response,
        deliveryOptionsKey: deliverySlotsEnabled ? 'table4' : 'table3',
        timeSlotsKey: deliverySlotsEnabled ? 'table3' : null,
      );

      notifier.state = RemoteData(
        data: data,
      );
    } catch (e) {
      notifier.state = RemoteData(error: AppException(e));
    }
  }

  Future<void> getEcomAreaDetails({
    required int areaId,
    required int addressID,
  }) async {
    final map = <String, dynamic>{};
    map.putIfAbsent('ID', () => areaId);
    map.putIfAbsent('TypeObject', () => addressID);

    final notifier = _ref.read(areaDetails.notifier);

    if (!notifier.state.isSuccess) {
      notifier.state = RemoteData();
    }

    try {
      final response = await _restClient.getEcomAreaDetails(map);
      notifier.state = RemoteData(data: response.details!);
    } catch (e) {
      rethrow;
      // notifier.state = RemoteData(error: AppException(e));
    }
  }
}
