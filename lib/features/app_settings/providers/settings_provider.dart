import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/home/models/category.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/misc_values.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

import '../models/custom_locale.dart';

final _languages = [
  CustomLocale(
    locale: const Locale('ar', 'KW'),
    name: 'Arabic',
    displayName: 'عربي',
  ),
  CustomLocale(
    locale: const Locale('en', 'US'),
    name: 'English',
    displayName: 'English',
  ),
];

final settingsProvider = ChangeNotifierProvider<AppSettingsprovider>(
      (ref) => AppSettingsprovider(ref),
);

class AppSettingsprovider extends ChangeNotifier {
  AppSettingsprovider(
      this._ref,
      ) : _restClient = _ref.read(restClientProvider);
  final Ref _ref;
  final RestClient _restClient;
  MiscValue? area;

  final List<CustomLocale> _locales = [];

  List<CustomLocale> get locales => _locales;

  CustomLocale? _selectedLocale;

  CustomLocale? get selectedLocale => _selectedLocale;

  set selectedLocale(CustomLocale? locale) {
    _selectedLocale = locale;
    HiveRepo.instance.defaultLanguage = _selectedLocale?.name;
    notifyListeners();
  }

  CustomLocale? get unselectedLocale {
    return _locales.firstWhereOrNull(
          (element) => element.name != _selectedLocale?.name,
    );
  }

  AppConfig get appConfig => _ref.read(appConfigProvider);

  String priceText(double? price, {bool prefixCurrency = false}) {
    if (prefixCurrency) {
      return "${selectedLocale!.translate('KD')} ${(price ?? 0.0).toStringAsFixed(appConfig.decimalPoint)}";
    } else {
      return "${(price ?? 0.0).toStringAsFixed(appConfig.decimalPoint)} ${selectedLocale!.translate('KD')}";
    }
  }

  Future<dynamic> getEcomAllSettings() async {
    HiveRepo.instance.defaultLanguage ??= _languages.first.name;
    final defaultLanguage = HiveRepo.instance.defaultLanguage;

    _loadLocalesFromCache(defaultLanguage ?? appConfig.defaultLanguage);

    await Future.delayed(const Duration(seconds: 1), () => _locales.clear());

    await _loadLocalesFromNetwork(defaultLanguage ?? appConfig.defaultLanguage);
  }

  Future<void> _loadLocalesFromNetwork(String? defaultLanguage) async {
    final map = <String, dynamic>{};
    map.putIfAbsent('Username', () => HiveRepo.instance.userName);

    _loadALocaleFromNetwork(_languages.first, defaultLanguage)
        .then(
          (value) => _loadALocaleFromNetwork(
        _languages.last,
        defaultLanguage,
      ).onError((error, stackTrace) {}),
    )
        .onError((error, stackTrace) {});
  }

  Future<void> _loadALocaleFromNetwork(
      CustomLocale language,
      String? defaultLanguage,
      ) async {
    final map = <String, dynamic>{};
    map.putIfAbsent('Username', () => HiveRepo.instance.userName);
    map['Language'] = language.name;

    final response = await _restClient.getEcomAllSettings(map);
    final locale = CustomLocale.fromSettingsJson(
      name: language.name,
      locale: language.locale,
      json: response,
      subCategories: (response['result']['table3'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      displayName: language.displayName,
    );

    _locales.add(locale);

    if (_selectedLocale == null) {
      _selectedLocale = _locales.firstWhereOrNull(
            (element) => element.name == defaultLanguage,
      );
      notifyListeners();
    }

    await HiveRepo.instance.storeData(
      language.name,
      json.encode(locale.toJson()),
    );

    appConfig.clear();

    final table1 = (response['result']['table1'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList() ??
        [];

    final table2 = (response['result']['table2'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList() ??
        [];

    // Merge elements from list1 into the result map
    for (var map in table1) {
      appConfig.putIfAbsent(map['key'], map['value']);
    }

    // Merge elements from list2 into the result map
    for (var map in table2) {
      appConfig.putIfAbsent(map['key'], map['value']);
    }

    await HiveRepo.instance.storeData(
      'app_config',
      json.encode(appConfig.appConfig),
    );
  }

  void _loadLocalesFromCache(String? defaultLanguage) {
    for (final language in _languages) {
      final cached = HiveRepo.instance.readData(language.name);
      if (cached != null) {
        try {
          final locale = CustomLocale.fromJson(json.decode(cached));
          _locales.add(locale);
        } catch (e) {
          //
        }
      }
    }

    if (_locales.isNotEmpty && _selectedLocale == null) {
      _selectedLocale = _locales.firstWhereOrNull(
            (element) => element.name == defaultLanguage,
      );
      notifyListeners();
    }

    final cachedConfig = HiveRepo.instance.readData('app_config');

    if (cachedConfig != null) {
      appConfig.clear();
      appConfig.addAll(json.decode(cachedConfig));
    }
  }
}
