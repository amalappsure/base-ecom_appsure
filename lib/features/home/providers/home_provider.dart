import 'dart:convert';

import 'package:base_ecom_appsure/features/products/models/product_panels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/features/home/models/category.dart';
import 'package:base_ecom_appsure/features/home/models/home_banner.dart';
import 'package:base_ecom_appsure/models/remote_data.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

final homeProvider = StateProvider<HomeProvider>(
      (ref) => HomeProvider(ref),
);

final bannersProvider = StateProvider<RemoteData<List<HomeBanner>>>(
      (ref) => RemoteData(),
);

final categoriesProvider = StateProvider<RemoteData<List<Category>>>(
      (ref) => RemoteData(),
);

final panelsProvider = StateProvider<RemoteData<List<ProductPanel>>>(
      (ref) => RemoteData(),
);

class HomeProvider {
  HomeProvider(this._ref) : _restClient = _ref.read(restClientProvider);

  final RestClient _restClient;
  final StateProviderRef _ref;

  String get _language => _ref.read(settingsProvider).selectedLocale!.name;

  Map<String, dynamic> get map {
    final map = <String, dynamic>{};

    map.putIfAbsent('Username', () => HiveRepo.instance.userName);
    map.putIfAbsent(
      'Language',
          () => _language,
    );

    return map;
  }

  Future<void> getCategoryListForComponent() async {
    final notifier = _ref.read(categoriesProvider.notifier);
    if (!notifier.state.isLoading) {
      notifier.state = RemoteData();
    }

    final fromCache = HiveRepo.instance.readData(
      'CategoryListForComponent-$_language',
    );

    if (fromCache != null) {
      notifier.state = RemoteData(
        data: GetCategoryListResp.fromJson(
          json.decode(fromCache),
        ).categories,
      );
    }

    try {
      final response = await _restClient.getCategoryListForComponent(map);
      HiveRepo.instance.storeData(
        'CategoryListForComponent-$_language',
        json.encode(response.toJson()),
      );
      notifier.state = RemoteData(data: response.categories);
    } catch (e) {
      if (fromCache == null) {
        notifier.state = RemoteData(error: AppException(e));
      }
    }
  }

  Future<void> getProductPanels() async {
    final notifier = _ref.read(panelsProvider.notifier);
    if (!notifier.state.isLoading) {
      notifier.state = RemoteData();
    }

    final fromCache = HiveRepo.instance.readData(
      'ProductPanels-$_language',
    );

    if (fromCache != null) {
      notifier.state = RemoteData(
        data: GetPanelsResp.fromJson(
          json.decode(fromCache),
        ).panels,
      );
    }

    try {
      final response = await _restClient.getProductPanels(map);
      HiveRepo.instance.storeData(
        'ProductPanels-$_language',
        json.encode(response.toJson()),
      );
      notifier.state = RemoteData(data: response.panels);
    } catch (e) {
      if (fromCache == null) {
        notifier.state = RemoteData(error: AppException(e));
      }
    }
  }

  Future<void> getBanners() async {
    final notifier = _ref.read(bannersProvider.notifier);
    if (!notifier.state.isLoading) {
      notifier.state = RemoteData();
    }

    final fromCache = HiveRepo.instance.readData(
      'Banners-$_language',
    );

    if (fromCache != null) {
      notifier.state = RemoteData(
        data: HomeBannerResp.fromJson(
          json.decode(fromCache),
        ).banners,
      );
    }

    try {
      final response = await _restClient.getBanners(map);
      HiveRepo.instance.storeData(
        'Banners-$_language',
        json.encode(response.toJson()),
      );
      notifier.state = RemoteData(data: response.banners);
    } catch (e) {
      if (fromCache == null) {
        notifier.state = RemoteData(error: AppException(e));
      }
    }
  }
}
