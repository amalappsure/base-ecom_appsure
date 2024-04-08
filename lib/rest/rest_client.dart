import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:base_ecom_appsure/features/addresses/models/address.dart';
import 'package:base_ecom_appsure/features/auth/models/login_resp.dart';
import 'package:base_ecom_appsure/features/auth/models/tokens.dart';
import 'package:base_ecom_appsure/features/cart/models/cart_items.dart';
import 'package:base_ecom_appsure/features/checkout/models/area_details.dart';
import 'package:base_ecom_appsure/features/checkout/models/put_sales_order_result.dart';
import 'package:base_ecom_appsure/features/company_info/models/company_info.dart';
import 'package:base_ecom_appsure/features/home/models/category.dart';
import 'package:base_ecom_appsure/features/home/models/home_banner.dart';
import 'package:base_ecom_appsure/features/orders/models/order_details_resp/order_details_resp.dart';
import 'package:base_ecom_appsure/features/orders/models/orders_list/orders_list_resp.dart';
import 'package:base_ecom_appsure/features/products/models/category_products_page.dart';
import 'package:base_ecom_appsure/features/products/models/payment_methods.dart';
import 'package:base_ecom_appsure/features/products/models/product_details/product_details_resp.dart';
import 'package:base_ecom_appsure/features/products/models/product_panel.dart';
import 'package:base_ecom_appsure/features/products/models/product_panels.dart';
import 'package:base_ecom_appsure/features/products/models/search_result.dart';
import 'package:base_ecom_appsure/features/products/models/sort_method.dart';
import 'package:base_ecom_appsure/features/reviews/models/reviews_list/reviews_resp.dart';
import 'package:base_ecom_appsure/features/reviews/models/users_review.dart';
import 'package:base_ecom_appsure/features/wishlist/models/wish_list_item.dart';
import 'package:base_ecom_appsure/models/misc_values.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {required String baseUrl}) = _RestClient;

  @POST('/GetEcomAllSettings')
  Future<dynamic> getEcomAllSettings(@Body() Map<String, dynamic> body);

  @POST('/GetCategoryListForComponent')
  Future<GetCategoryListResp> getCategoryListForComponent(
      @Body() Map<String, dynamic> body,
      );

  @POST('/GetPanelItemsList')
  Future<GetPanelsResp> getProductPanels(@Body() Map<String, dynamic> body);

  @POST('/GetBannerMasterList')
  Future<HomeBannerResp> getBanners(@Body() Map<String, dynamic> body);

  @POST('/GetSearchItemsList')
  Future<CategoryProductsResp> getSearchItemsList(
      @Body() Map<String, dynamic> body,
      );

  @POST('/GetSortByList')
  Future<SortMethods> getSortMethods(@Body() Map<String, dynamic> body);

  @POST('/GetFilterCategoryListByID')
  Future<GetCategoryListResp> getFilterCategoryListByID(
      @Body() Map<String, dynamic> body,
      );

  @POST('/ValidateUsername')
  Future<dynamic> userNameExists(@Body() Map<String, dynamic> body);

  @POST('/GenerateOTP')
  Future<dynamic> generateOTP(@Body() Map<String, dynamic> body);

  @POST('/PutOTPMobile')
  Future<dynamic> putOTP(@Body() Map<String, dynamic> body);

  @POST('/PutUserRegistrationMobile')
  Future<dynamic> registerUser(@Body() Map<String, dynamic> body);

  @POST('/PutGuestUserRegistration')
  Future<dynamic> registerGuestUser(@Body() Map<String, dynamic> body);

  @POST('/PutUserLogin')
  Future<LoginResp> userLogin(@Body() Map<String, dynamic> body);

  @POST('/InsertCartItems')
  Future<dynamic> insertCartItems(@Body() Map<String, dynamic> body);

  @POST('/RemoveCartItem')
  Future<dynamic> removeCartItem(@Body() Map<String, dynamic> body);

  @POST('/GetCartItemsList')
  Future<CartItems> getCartItemsList(@Body() Map<String, dynamic> body);

  @POST('/GetWishlistItemsList')
  Future<WishListItems> getWishlistItemsList(@Body() Map<String, dynamic> body);

  @POST('/InsertwishlistItems')
  Future<dynamic> insertwishlistItems(@Body() Map<String, dynamic> body);

  @POST('/RemoveWishlistItem')
  Future<dynamic> removeWishlistItem(@Body() Map<String, dynamic> body);

  @POST('/GetSearchList')
  Future<SearchResults> getSearchList(@Body() Map<String, dynamic> body);

  @POST('/GetProductDetails')
  Future<ProductDetailsResp> getProductDetails(
      @Body() Map<String, dynamic> body,
      );

  @POST('/GetRelatedItemsList')
  Future<GetPanelResp> getRelatedItemsList(@Body() Map<String, dynamic> body);

  @POST('/GetPaymentTypesByItemID')
  Future<PaymentMethods> getPaymentTypesByItemID(
      @Body() Map<String, dynamic> body,
      );

  @POST('/PutUserAddress')
  Future<dynamic> putUserAddress(@Body() Map<String, dynamic> body);

  @POST('/GetMiscMasterValuesList')
  Future<MiscValues> getMiscMasterValuesList(@Body() Map<String, dynamic> body);

  @POST('/GetAddressList')
  Future<Addresses> getAddressList(@Body() Map<String, dynamic> body);

  @POST('/DeleteUserAddress')
  Future<dynamic> deleteUserAddress(@Body() Map<String, dynamic> body);

  @POST('/PutDefaultAddress')
  Future<dynamic> setDefaultAddress(@Body() Map<String, dynamic> body);

  @POST('/PaymentTypes')
  Future<dynamic> getCheckoutOptions(@Body() Map<String, dynamic> body);

  @POST('/GetEcomAreaDetails')
  Future<AreaDetailsResp> getEcomAreaDetails(@Body() Map<String, dynamic> body);

  @POST('/PutSalesOrder')
  Future<PutSalesOrderResp> putSalesOrder(@Body() Map<String, dynamic> body);

  @POST('/MakePaymentGateway')
  Future<dynamic> makePaymentGateway(@Body() Map<String, dynamic> body);

  @POST('/PutEmail')
  Future<dynamic> putEmail(@Body() Map<String, dynamic> body);

  @POST('/PutName')
  Future<dynamic> putName(@Body() Map<String, dynamic> body);

  @POST('/PutMobile')
  Future<dynamic> putMobile(@Body() Map<String, dynamic> body);

  @POST('/GetSecurityDetails')
  Future<LoginResp> getSecurityDetails(@Body() Map<String, dynamic> body);

  @POST('/PutPassword')
  Future<dynamic> putPassword(@Body() Map<String, dynamic> body);

  @POST('/PasswordUpdate')
  Future<dynamic> passwordUpdate(
      @Body() Map<String, dynamic> body,
      );

  @POST('/GetSalesOrderList')
  Future<OrdersListResp> getSalesOrderList(@Body() Map<String, dynamic> body);

  @POST('/GetOrderDetails')
  Future<OrderDetailsResp> getOrderDetails(@Body() Map<String, dynamic> body);

  @POST('/PutCancelRequest')
  Future<dynamic> putCancelRequest(@Body() Map<String, dynamic> body);

  @POST('/GetContentByID')
  Future<CompanyInfoResp> getContentByID(@Body() Map<String, dynamic> body);

  @POST('/ValidatePromoCode')
  Future<dynamic> validatePromoCode(@Body() Map<String, dynamic> body);

  @POST('/GetTokens')
  Future<AuthTokensResp> getTokens(@Body() Map<String, dynamic> body);

  @POST('/GetNewTokens')
  Future<AuthTokensResp> getNewTokens(@Body() Map<String, dynamic> body);

  @POST('/UserReviews/InsertUserReview')
  Future<ReviewsResp> insertUserReview(@Body() Map<String, dynamic> body);

  @POST('/UserReviews/FillReviewByItemID')
  Future<ReviewsResp> fillReviewByItemID(@Body() Map<String, dynamic> body);

  @POST('/UserReviews/CheckItemOrderedByUser')
  Future<UsersReviewResp> getExistingReview(
      @Body() Map<String, dynamic> body,
      );
}
