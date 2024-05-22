import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:base_ecom_appsure/features/addresses/models/address.dart';
import 'package:base_ecom_appsure/features/addresses/providers/address_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/models/cart_item.dart';
import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';
import 'package:base_ecom_appsure/features/checkout/models/area_details.dart';
import 'package:base_ecom_appsure/features/checkout/models/time_slot.dart';
import 'package:base_ecom_appsure/features/checkout/providers/checkout_provider.dart';
import 'package:base_ecom_appsure/features/checkout/providers/purchase_provider.dart';
import 'package:base_ecom_appsure/features/products/models/payment_methods.dart';
import 'package:base_ecom_appsure/features/products/models/product_details/item_delivery_option.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/widgets/default_card.dart';

import 'checkout_addresses.dart';
import 'checkout_item.dart';
import 'checkout_payment_delivery.dart';
import 'promo_code_card.dart';
import 'review_order.dart';

typedef PushRoute<T, U> = Future<T?> Function(U param,
    [List<dynamic>? otherParams]);

class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({
    required this.pushWebView,
    required this.pushAddAddress,
    required this.onOrderSuccess,
    this.onItemTapped,
    this.errorImagePath,
    super.key,
  });
  final PushRoute<dynamic, WebViewController> pushWebView;
  final PushRoute<dynamic, Address?> pushAddAddress;
  final PushRoute<dynamic, bool> onOrderSuccess;
  final ValueChanged<CartItem>? onItemTapped;
  final String? errorImagePath;

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  PaymentMethod? _paymentMethod;
  ItemDeliveryOption? _deliveryOption;
  TimeSlot? _timeSlot;
  Address? _address;
  AreaDetails? _areaDetails;
  final _remarksController = TextEditingController();
  final _giftWrapController = TextEditingController();
  final _promoCodeController = TextEditingController();
  bool _giftWrap = false;

  double get deliveryCharge {
    if (appConfig.disableDeliveryChargeOption ||
        appConfig.showZeroDeliveryCharge) {
      return 0;
    }
    if (enableMultipleDeliveryOption) {
      if (_deliveryOption?.title?.contains('Normal') ?? false) {
        return _areaDetails?.deliveryCharge ?? 0;
      }
      return _areaDetails?.fastDeliveryCharge ?? 0;
    }
    return _areaDetails?.deliveryCharge ?? 0;
  }

  bool get enableMultipleDeliveryOption =>
      appConfig.enableMultipleDeliveryOption;

  bool get enabledeliveryTimeSlot => appConfig.deliveryTimeSlotAllocation;

  AppConfig get appConfig => ref.read(appConfigProvider);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _initData());
    super.initState();
  }

  void _initData() {
    ref.read(addressProvider).getAddressList();
    ref.read(checkoutProvider).getCheckoutOptions();
    ref.read(cartProvider).loadCartFromRemote();
  }

  AppSettingsprovider get settings => ref.read(settingsProvider);

  CartProvider get cart => ref.read(cartProvider);

  bool get promoCodeFeatureEnabled {
    if (appConfig.enablePromoCodeFeature) {
      if (appConfig.disablePromocodeForGuestUser &&
          (HiveRepo.instance.user?.isGuest ?? true)) {
        return false;
      }
      return true;
    }
    return false;
  }

  void onPaymentComplete(bool success) {
    if (success) {
      FirebaseAnalytics.instance.logPurchase(
        value: cart.cartValue.toDouble() + deliveryCharge,
        currency: 'KWD',
        coupon: cart.promoCode,
        items: ref
            .read(cartProvider)
            .items
            .map((e) => e.analyticsEventItem)
            .toList(),
        parameters: {
          'PaymentType': _paymentMethod!.keyword!,
        },
      );
    }
    widget.onOrderSuccess(
      success,
      [_address, _paymentMethod, cart.cartValue.toDouble() + deliveryCharge],
    );
  }

  void _initListeners() {
    ref.listen(addressesProvider, (_, next) {
      if (next.isSuccess) {
        _address ??= next.data!.firstWhereOrNull(
              (element) => element.defaultAddress,
        );

        if (_address != null) {
          ref.read(checkoutProvider).getEcomAreaDetails(
            addressID: _address!.id,
            areaId: _address!.areaId,
          );
        }
      }
    });

    ref.listen(areaDetails, (previous, next) {
      if (next.isSuccess) {
        _areaDetails = next.data!;
        setState(() {});
      }
    });

    ref.listen(settingsProvider, (previous, next) {
      _initData();
    });

    ref.listen(checkoutOptionsProvider, (previous, next) {
      next.doWhen(
        onSuccess: (data) {
          _paymentMethod ??= data.paymentMethods.firstOrNull;
          _deliveryOption ??= data.deliveryOptions.firstOrNull;
          _timeSlot ??= data.timeSlots.firstOrNull;
          setState(() {});
        },
      );
    });

    ref.listen(purchaseProvider, (previous, next) {
      if (next is CODSuccess) {
        onPaymentComplete(true);
      } else if (next is PurchaseSuccess) {
        if (next.url == null) return;

        FirebaseAnalytics.instance.logBeginCheckout(
          value: cart.cartValue.toDouble() + deliveryCharge,
          currency: 'KWD',
          coupon: cart.promoCode,
          items: ref
              .read(cartProvider)
              .items
              .map((e) => e.analyticsEventItem)
              .toList(),
          parameters: {
            'PaymentType': _paymentMethod!.keyword!,
          },
        );

        final uri = Uri.parse(next.url!);
        print('~~PurchaseSuccess.path: ${uri.host}/${uri.path}');
        print('~~PurchaseSuccess.parameters: ${uri.queryParameters}');
        final webViewController = WebViewController(
          onPermissionRequest: (request) {
            request.grant();
          },
        )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..enableZoom(false)
          ..loadRequest(Uri.parse(next.url!))
          ..setNavigationDelegate(NavigationDelegate(
            onUrlChange: (change) {},
            onNavigationRequest: (request) {
              final uri = Uri.parse(request.url);
              print('~~onNavigationRequest.path: ${uri.host}/${uri.path}');
              print(
                '~~onNavigationRequest.queryParameters: ${uri.queryParameters}',
              );
              if (uri.pathSegments.contains('PaymentSuccess')) {
                onPaymentComplete(true);
                return NavigationDecision.prevent;
              } else if (uri.pathSegments.contains('PaymentFailure')) {
                onPaymentComplete(false);
                return NavigationDecision.prevent;
              } else if (uri.pathSegments.contains('ErrorPage')) {
                onPaymentComplete(false);
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ));
        // ignore: use_build_context_synchronously
        widget.pushWebView(webViewController);
      } else if (next is PurchaseFailed) {
        showSnackBar(
          context,
          isError: true,
          message: ref
              .read(settingsProvider)
              .selectedLocale!
              .translate(next.exception.toString()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final cart = ref.watch(cartProvider);
    final items = cart.items;
    final purchaseState = ref.watch(purchaseProvider);
    _initListeners();

    final cartContainsProductOnOffer =
        items.firstWhereOrNull((element) => element.isOnOffer) != null;

    return RefreshIndicator.adaptive(
      onRefresh: () async => _initData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckoutAddresses(
              goToAddAddress: () => _goToAddAddress(),
              address: _address,
              onAddressChanged: (value) => setState(() {
                _address = value;
                if (_address != null) {
                  ref.read(checkoutProvider).getEcomAreaDetails(
                    addressID: _address!.id,
                    areaId: _address!.areaId,
                  );
                }
              }),
              onEditAddress: (value) => _goToAddAddress(address: value),
            ),
            const Gap(18.0),
            CheckoutPaymentDelivery(
              onItemDeliveryOptionChanged: (value) => setState(() {
                _deliveryOption = value;
              }),
              onPaymentMethodChanged: (value) => setState(() {
                _paymentMethod = value;
              }),
              onTimeSlotChanged: (value) => setState(() {
                _timeSlot = value;
              }),
              deliveryOption: _deliveryOption,
              paymentMethod: _paymentMethod,
              timeSlot: _timeSlot,
            ),
            if (promoCodeFeatureEnabled && !cartContainsProductOnOffer) ...[
              const Gap(18.0),
              _title(settings.selectedLocale!.translate('ApplyCoupon')),
              const Gap(12.0),
              PromoCodeCard(
                controller: _promoCodeController,
                applyPromoCode: _applyPromoCode,
              )
            ],
            const Gap(18.0),
            _title(settings.selectedLocale!.translate('ReviewYourOrder')),
            const Gap(12.0),
            DefaultCard(
              margin: EdgeInsets.zero,
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Builder(
                builder: (context) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => CheckoutItem(
                      item: items[index],
                      onTap: widget.onItemTapped,
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: items.length,
                  );
                },
              ),
            ),
            const Gap(12.0),
            ReviewOrder(
              giftWrapEnabled: _giftWrap,
              remarksController: _remarksController,
              giftWrapController: _giftWrapController,
              deliveryCharge: deliveryCharge,
              onGiftWrapChanged: (value) => setState(() {
                _giftWrap = value ?? false;
              }),
            ),
            const Gap(18.0),
            if (purchaseState is Purchasing ||
                ref.watch(checkoutOptionsProvider).isLoading)
              const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            else
              ElevatedButton(
                onPressed: _orderingFlow,
                child: Text(
                  settings.selectedLocale!.translate('ProceedtoPay'),
                ),
              )
          ],
        ),
      ),
    );
  }

  PurchaseProvider get _purchaseProvider => ref.read(purchaseProvider.notifier);

  Widget _title(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future<void> _orderingFlow() async {
    if (_address == null) {
      showSnackBar(
        context,
        isError: true,
        message: settings.selectedLocale!.translate('OldAddress'),
      );
      _goToAddAddress();
      return;
    }

    if (enableMultipleDeliveryOption && _deliveryOption?.id == null) return;
    if (enabledeliveryTimeSlot && _timeSlot?.id == null) return;
    if (_paymentMethod?.description == null) return;

    final amount = cart.cartValue.toDouble() + deliveryCharge;
    final minAmount = _areaDetails?.basketSize ?? 0.0;
    if (amount < minAmount) {
      String message = settings.selectedLocale!.translate(
        'AmountLessThanMinimumBasketSize',
      );

      final amountText = settings.priceText(minAmount);

      message = '$message $amountText';

      showSnackBar(
        context,
        isError: true,
        message: message,
      );
      return;
    }

    final items = cart.items;

    await _purchaseProvider.makePaymentGateway(
      paymentType: _paymentMethod!.keyword!,
      amount: amount.toString(),
      addressId: _address!.id,
      deliveryCharge: deliveryCharge,
      deliveryTypeID: _deliveryOption?.id,
      discount: 0.0,
      itemID: cart.quickBuyItemId ?? items.first.itemId,
      quickBuyUnitId: cart.quickBuyUnitId,
      remarks: _remarksController.text,
      giftWrapping: _giftWrap,
      giftWrappingMessage: _giftWrapController.text,
      timeSlotId: _timeSlotInfo,
      minBasketSize: (_areaDetails?.basketSize ?? 0.0).toInt(),
      promoCode: cart.promoCode,
    );
  }

  String? get _timeSlotInfo {
    if (_timeSlot == null) {
      return null;
    }
    return '${_timeSlot!.id}~${DateFormat('MM/dd/yyyy').format(_timeSlot!.date)} 00:00:00 AM';
  }

  Future<void> _goToAddAddress({Address? address}) async {
    await widget.pushAddAddress(address);
    _initData();
  }

  Future<void> _applyPromoCode(String value) async {
    await cart.validatePromoCode(value);
  }
}
