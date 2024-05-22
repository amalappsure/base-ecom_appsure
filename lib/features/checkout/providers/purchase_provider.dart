import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/foundation/string_exts.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

part 'purchase_states.dart';

final purchaseProvider = StateNotifierProvider<PurchaseProvider, PurchaseState>(
      (ref) => PurchaseProvider(ref),
);

class PurchaseProvider extends StateNotifier<PurchaseState> {
  PurchaseProvider(this._ref)
      : _restClient = _ref.read(restClientProvider),
        super(const PurchaseInitial());
  final RestClient _restClient;
  final Ref _ref;

  String? get _language => _ref.read(settingsProvider).selectedLocale?.name;

  Future<void> makePaymentGateway({
    String remarks = '',
    bool giftWrapping = false,
    String giftWrappingMessage = '',
    required String amount,
    required String paymentType,
    required int addressId,
    required num deliveryCharge,
    required num discount,
    int? deliveryTypeID,
    int? itemID,
    String? timeSlotId,
    String? promoCode,
    String? productType,
    String? businessNature,
    int? quickBuyUnitId,
    int? minBasketSize,
  }) async {
    state = const Purchasing();
    final map = <String, dynamic>{};

    map.putIfAbsent('TypeObject4', () => giftWrapping ? 'True' : 'False');
    map.putIfAbsent('String4', () => giftWrappingMessage.nullIfEmpty);
    map.putIfAbsent('String1', () => businessNature ?? '');
    map.putIfAbsent('String2', () => productType?.nullIfEmpty);
    map.putIfAbsent('String5', () => paymentType);
    map.putIfAbsent('String7', () => '');
    map.putIfAbsent('String6', () => addressId.toString());
    map.putIfAbsent('TypeObject1', () => deliveryCharge.toString());
    map.putIfAbsent('TypeObject3', () => discount.toString());
    map.putIfAbsent('String3', () => remarks.nullIfEmpty);
    map.putIfAbsent('TypeObject', () => promoCode?.nullIfEmpty);
    map.putIfAbsent('Language', () => _language);
    map.putIfAbsent('TypeObject2', () => timeSlotId);
    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    if (deliveryTypeID != null) {
      map.putIfAbsent('Int1', () => deliveryTypeID);
    }
    if (quickBuyUnitId != null) {
      map.putIfAbsent('ID', () => itemID);
      map.putIfAbsent('TypeObject5', () => itemID);
      map.putIfAbsent('Int3', () => quickBuyUnitId);
    }
    map.putIfAbsent('Int2', () => minBasketSize ?? 0);

    try {
      final response = await _restClient.makePaymentGateway(map);
      if (response["result"] == 'True') {
        state = const CODSuccess();
      } else if (response["result"]["data"] != null) {
        state = PurchaseSuccess(response["result"]["data"] as String?);
      } else {
        throw _ref
            .read(settingsProvider)
            .selectedLocale!
            .translate('ErrorPageMessage');
      }
    } catch (e) {
      state = PurchaseFailed(AppException(e));
    }
  }
}
