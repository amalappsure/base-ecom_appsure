part of 'purchase_provider.dart';

abstract class PurchaseState {
  const PurchaseState();
}

class PurchaseInitial extends PurchaseState {
  const PurchaseInitial();
}

class Purchasing extends PurchaseState {
  const Purchasing();
}

class PurchaseSuccess extends PurchaseState {
  const PurchaseSuccess(this.url);
  final String? url;
}

class CODSuccess extends PurchaseState {
  const CODSuccess();
}

class PurchaseFailed extends PurchaseState {
  const PurchaseFailed(this.exception);
  final AppException exception;
}
