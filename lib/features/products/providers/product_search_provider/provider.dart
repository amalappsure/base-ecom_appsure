import 'dart:async';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

import 'product_search_states.dart';

final productSearchProvider = StateNotifierProvider.autoDispose<
    ProductSearchProvider, ProductSearchState>(
      (ref) => ProductSearchProvider(ref),
);

class ProductSearchProvider extends StateNotifier<ProductSearchState> {
  ProductSearchProvider(this._ref)
      : _restClient = _ref.read(restClientProvider),
        super(const ProductSearchInitial());
  final Ref _ref;
  final RestClient _restClient;
  Timer? _debounce;

  String get _language => _ref.read(settingsProvider).selectedLocale!.name;

  Future<void> getSearchList(String searchTerm) async {
    _getSearchList(searchTerm);
  }

  Future<void> _getSearchList(String searchTerm) async {
    final map = <String, dynamic>{};
    final ipv4 = await Ipify.ipv4();

    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("Language", () => _language);
    map.putIfAbsent("String1", () => searchTerm);
    map.putIfAbsent("String2", () => ipv4);

    state = const ProductSearchLoading();

    try {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(microseconds: 100), () async {
        if (searchTerm.isEmpty) {
          state = const ProductSearchSuccess([]);
        } else {
          // Call your API here with the value
          final response = await _restClient.getSearchList(map);
          state = ProductSearchSuccess(response.results);
        }
      });
    } catch (e) {
      state = ProductSearchError(AppException(e));
    }
  }

  void clearList() {
    state = const ProductSearchInitial();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
