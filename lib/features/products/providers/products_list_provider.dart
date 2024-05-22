import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/home/models/category.dart';
import 'package:base_ecom_appsure/features/products/models/sort_method.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/foundation/string_exts.dart';
import 'package:base_ecom_appsure/foundation/utils.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/remote_data.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

import '../models/product.dart';
import '../models/product_panels.dart';

final productListProvider =
ChangeNotifierProvider.autoDispose.family<CategoryProductsProvider, String>(
      (ref, family) => CategoryProductsProvider(ref, family),
);

final sortMethodsProvider =
StateProvider.family<RemoteData<List<SortMethod>>, String>(
      (ref, _) => RemoteData(),
);

final catFilProvider = StateProvider.family<RemoteData<List<Category>>, String>(
      (ref, _) => RemoteData(),
);

class CategoryProductsProvider extends ChangeNotifier {
  CategoryProductsProvider(
      this._ref,
      this.family,
      ) : _restClient = _ref.read(restClientProvider) {
    _pagingController.addPageRequestListener(
          (pageKey) => _getSearchItemsList(pageKey),
    );

    _ref.listen(settingsProvider, (previous, next) {
      getSortMethods();
      getFilterCategoryListByID();
      _pagingController.refresh();
    });

    showOutOfStock = _appConfig.tickIncludeOutOfStock;
  }

  void logListingevent(String? name) {
    final params = <String, dynamic>{};
    params.putIfAbsent('Type', () => _type);

    if (category != null) {
      params.putIfAbsent('ID', () => category!.id);
    } else if (panel != null) {
      params.putIfAbsent('ID', () => panel!.id);
    } else if (searchQuery != null && searchQuery!.isNotEmpty) {
      params.putIfAbsent('Keyword', () => searchQuery);
    }

    FirebaseAnalytics.instance.logViewItemList(
      itemListName: name,
      parameters: params,
    );
  }

  final RestClient _restClient;
  final String family;
  final ChangeNotifierProviderRef _ref;

  SortMethod? _sortBy;

  SortMethod? get sortBy => _sortBy;

  String? _title;

  String? get title {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final settings = _ref.read(settingsProvider);
      return '${settings.selectedLocale!.translate('SearchResultof')} "$searchQuery"';
    }
    return category?.title.nullIfEmpty ?? panel?.title.nullIfEmpty ?? _title;
  }

  set sortBy(SortMethod? value) {
    _sortBy = value;
    notifyListeners();
  }

  void updateSortBy(SortMethod? value) {
    _sortBy = value;
    _pagingController.refresh();
    notifyListeners();
  }

  bool _listView = true;

  bool get listView => _listView;

  set listView(bool value) {
    _listView = value;
    notifyListeners();
  }

  final PagingController<int, Product> _pagingController = PagingController(
    firstPageKey: 1,
  );

  PagingController<int, Product> get pagingController => _pagingController;

  String get _language => _ref.read(settingsProvider).selectedLocale!.name;

  AppConfig get _appConfig => _ref.read(appConfigProvider);

  Map<String, dynamic> get map {
    final map = <String, dynamic>{};

    map.putIfAbsent('Username', () => HiveRepo.instance.userName);
    map.putIfAbsent(
      'Language',
          () => _language,
    );

    return map;
  }

  Future<void> getSortMethods() async {
    final notifier = _ref.read(sortMethodsProvider(family).notifier);
    if (!notifier.state.isLoading) {
      notifier.state = RemoteData();
    }

    final fromCache = HiveRepo.instance.readData(
      'SortMethods-$_language',
    );

    if (fromCache != null) {
      notifier.state = RemoteData(
        data: SortMethods.fromJson(
          json.decode(fromCache),
        ).sortMethods,
      );
    }

    try {
      final response = await _restClient.getSortMethods({
        "String1": "EcommerceItemSortby",
        ...map,
      });

      HiveRepo.instance.storeData(
        'SortMethods-$_language',
        json.encode(response.toJson()),
      );
      notifier.state = RemoteData(data: response.sortMethods);
    } catch (e) {
      if (fromCache == null) {
        notifier.state = RemoteData(error: AppException(e));
      }
    }
  }

  final List<List<num>> pricePairs = [];

  List<num>? _selectedPricePairs;

  List<num>? get selectedPricePairs => _selectedPricePairs;

  set selectedPricePairs(List<num>? list) {
    _selectedPricePairs = list;
    _pagingController.refresh();
    notifyListeners();
  }

  late bool _showOutOfStock;

  bool get showOutOfStock => _showOutOfStock;

  set showOutOfStock(bool value) {
    _showOutOfStock = value;
    _pagingController.refresh();
    notifyListeners();
  }

  Future<void> _getSearchItemsList(int page) async {
    final pageSize = _appConfig.productListingPerPageCount;
    if (page == 1) {
      _title = null;
    }

    try {
      final response = await _restClient.getSearchItemsList({
        "typeobject2": {
          "ID": _id,
          "Type": _type,
          "Sortby": sortBy?.id,
          if (searchQuery != null && searchQuery!.isNotEmpty)
            "Keyword": searchQuery,
          "PerPage": pageSize,
          "PageNo": page,
          "OutOfStock": _showOutOfStock,
          "PriceMin": _selectedPricePairs?.firstOrNull ?? 0,
          "PriceMax": _selectedPricePairs?.lastOrNull ?? 0,
          "MenuText": '',
          if (category != null) "CategoryIds": _category!.id.toString(),
          ...map,
        },
      });

      if (pricePairs.isEmpty) {
        pricePairs.addAll(generatePairsWithInterval(
          response.page.filterPriceMin,
          response.page.filterPriceMax,
          interval(response.page.filterPriceMax),
        ));
      }

      final newItems = response.page.itemList;
      _title = response.page.title;
      if (page == 1) {
        try {
          logListingevent(_title);
        } catch (e) {
          //
        }
      }

      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = page + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = AppException(e);
    }
    notifyListeners();
  }

  int get _id {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      return 0;
    }
    if (category != null) {
      return category!.id;
    }
    if (panel != null) {
      return panel!.id;
    }
    return 0;
  }

  String get _type {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      return 'SearchItems';
    }
    if (category != null) {
      return 'Category';
    }

    if (panel != null) {
      return 'Panel';
    }
    return '';
  }

  Category? _category;

  Category? get category => _category;

  ProductPanel? panel;

  String? searchQuery;

  void setCategory(Category? value, {bool notify = true}) {
    _category = value;
    _pagingController.refresh();
    pricePairs.clear();
    _selectedPricePairs = null;
    // getFilterCategoryListByID();
    if (notify) notifyListeners();
  }

  Future<void> getFilterCategoryListByID() async {
    final notifier = _ref.read(catFilProvider(family).notifier);
    final current = <Category>[];
    if (!notifier.state.isLoading) {
      if (notifier.state.isSuccess) {
        current.addAll(notifier.state.data!);
      }
      notifier.state = RemoteData();
    }

    final fromCache = HiveRepo.instance.readData(
      'CatFilter-$_language',
    );

    if (fromCache != null) {
      notifier.state = RemoteData(
        data: GetCategoryListResp.fromJson(
          json.decode(fromCache),
        ).categories,
      );
    }

    try {
      final response = await _restClient.getFilterCategoryListByID({
        "ID": category?.id ?? 0,
        ...map,
      });

      HiveRepo.instance.storeData(
        'CatFilter-$_language',
        json.encode(response.toJson()),
      );

      if (response.categories.isNotEmpty) {
        notifier.state = RemoteData(data: response.categories);
      } else {
        notifier.state = RemoteData(data: current);
      }
    } catch (e) {
      if (fromCache == null) {
        if (current.isNotEmpty) {
          notifier.state = RemoteData(data: current);
        } else {
          notifier.state = RemoteData(error: AppException(e));
        }
      }
    }
  }
}

int interval(num max) {
  if (max >= 50000) {
    return 5000;
  } else if (max >= 25000) {
    return 2000;
  } else if (max >= 8000) {
    return 1000;
  } else if (max >= 2000) {
    return 500;
  } else if (max >= 1000) {
    return 200;
  } else if (max >= 500) {
    return 150;
  } else if (max >= 150) {
    return 50;
  } else if (max >= 130) {
    return 30;
  } else if (max >= 100) {
    return 20;
  } else if (max >= 50) {
    return 10;
  }
  return 5;
}
