// Stub for InAppPurchase on web
library in_app_purchase_stub;

class InAppPurchase {
  static const InAppPurchase _instance = InAppPurchase._();
  static InAppPurchase get instance => _instance;

  const InAppPurchase._();

  Future<bool> isAvailable() async => false;
  Future<void> restorePurchases({String? applicationUserName}) async {}
// Add other methods as needed based on your usage
}