import 'package:base_ecom_appsure/features/products/models/search_result.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';

abstract class ProductSearchState {
  const ProductSearchState();
}

class ProductSearchInitial extends ProductSearchState {
  const ProductSearchInitial();
}

class ProductSearchLoading extends ProductSearchState {
  const ProductSearchLoading();
}

class ProductSearchSuccess extends ProductSearchState {
  const ProductSearchSuccess(this.data);

  final List<SearchResult> data;
}

class ProductSearchError extends ProductSearchState {
  const ProductSearchError(this.error);

  final AppException error;
}
