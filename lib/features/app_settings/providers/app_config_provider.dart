import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = StateProvider((ref) => AppConfig());

class AppConfig {
  final Map<String, dynamic> _appConfig = {};

  Map<String, dynamic> get appConfig => _appConfig;

  void clear() {
    _appConfig.clear();
  }

  void putIfAbsent(String key, String? value) {
    _appConfig.putIfAbsent(key, () => value);
  }

  void addAll(Map<String, dynamic> map) {
    _appConfig.addAll(map);
  }

  String get companyName => appConfig['Company Name'] ?? '';
  String? get hotLineNo => appConfig['HotLineNo'] as String?;
  String? get twitterURL => appConfig['Twitter URL'] as String?;
  String? get youTubeURL => appConfig['YouTube URL'] as String?;
  String? get facebookURL => appConfig['Facebook URL'] as String?;
  String? get linkedInURL => appConfig['LinkedIn URL'] as String?;
  String? get instagramURL => appConfig['Instagram URL'] as String?;
  bool get enablewishlist => _appConfig['Enable Wishlist'] == "True";
  bool get sellOutOfStock => appConfig['Sell Out of Stock'] == 'True';
  bool get enableGuestLogin => appConfig['Enable Guest Login'] == 'True';
  bool get disableAreaPopup => appConfig['Disable Area Popup'] == 'True';
  String get contactEmail => appConfig['Contact Email'] as String? ?? '';
  bool get languageSwitching => _appConfig['Language Switching'] == 'True';
  String get defaultLanguage => _appConfig['Default Language'] ?? 'English';
  bool get registerwithoutOTP => appConfig['Register without OTP'] == 'True';
  bool get enableGiftWrapping => appConfig['Enable Gift Wrapping'] == 'True';
  bool get quantityAsDropDown => appConfig['Quantity as DropDown'] == 'True';
  bool get enableBannerShading => appConfig['Enable Banner Shading'] == 'True';
  int get decimalPoint => int.tryParse(_appConfig['Decimal Point'] ?? '2') ?? 2;
  String get ecommerceWebRootPath => appConfig['Ecommerce Web Root Path'] ?? '';
  bool get disableCancelRequest =>
      appConfig['Disable Cancel Request'] == 'True';
  String get whatsappEnquiryNumber =>
      _appConfig['Whatsapp Enquiry Number'] ?? '';
  bool get enableSlidingCategory =>
      appConfig['Enable Sliding Category'] == 'True';
  bool get enableComplexPassword =>
      appConfig['Enable Complex Password'] == 'True';
  bool get showCategoryComponent =>
      appConfig['Show Category Component'] == 'True';
  bool get enableOneStepCheckout =>
      appConfig['Enable One Step Checkout'] == 'True';
  bool get disableZeroStockItems =>
      appConfig['Disable Zero Stock Items'] == 'True';
  bool get tickIncludeOutOfStock =>
      appConfig['Tick Include Out of Stock'] == 'True';
  bool get enablePromoCodeFeature =>
      appConfig['Enable Promo Code Feature'] == 'True';
  bool get showZeroDeliveryCharge =>
      appConfig['Show Zero Delivery Charge'] == 'True';
  bool get siteUnderMaintenance =>
      appConfig['Enable Site Under Maintenance'] == 'True';
  bool get removeBuyNow =>
      appConfig['Remove Buy Now'] == 'True' || !enableOneStepCheckout;
  bool get eableRemarksInSalesOrder =>
      appConfig['Enable Remarks in Sales Order'] == 'True';
  bool get enableRatingsAndReviews =>
      appConfig['Enable User Ratings and Reviews'] == 'True';
  bool get deliveryTimeSlotAllocation =>
      appConfig['Delivery Time Slot Allocation'] == 'True';
  bool get enableWhatsappEnquiryGen =>
      appConfig['Enable Whatsapp Enquiry General'] == 'True';
  String get siteUnderMaintenanceMessage =>
      appConfig['Site Under Maintenance Message'] ?? '';
  bool get disableDeliveryChargeOption =>
      appConfig['Disable Delivery Charge Option'] == 'True';
  bool get enableProductPartialListing =>
      appConfig['Enable Product Partial Listing'] == 'True';
  bool get enableWhatsappEnquiryItem =>
      appConfig['Enable Whatsapp Enquiry Item Level'] == 'True';
  bool get enableMultipleDeliveryOption =>
      appConfig['Enable Multiple Delivery Option'] == 'True';
  bool get showEstimatedDeliveryCaption =>
      appConfig['Show Estimated Delivery Caption'] == 'True';
  bool get disablePromocodeForGuestUser =>
      appConfig['Disable Promocode For Guest User'] == 'True';
  bool get showCategoryBoxTypeComponent =>
      appConfig['Show Category Box Type Component'] == 'True';
  bool get enableTwoItemInMobileCarousel =>
      appConfig['Enable two item in Mobile Carousel'] == 'True';
  bool get showPaymentMethodsInDetailPage =>
      appConfig['Show Payment Methods in Detail Page'] == 'True';
  bool get disableEmailValidationInRegistration =>
      appConfig['Disable Email Validation In Registration'] == 'True';
  bool get enableImageMagnificationInDetailPage =>
      appConfig['Enable Image Magnification in Detail Page'] == 'True';
  bool get enableSocialMediaIconsAndFunctionality =>
      appConfig['Enable Social media icons and Functionality'] == 'True';
  num get productListingPerPageCount =>
      num.tryParse(
          appConfig['Product Listing PerPage Count'] as String? ?? '12') ??
          12;
}
