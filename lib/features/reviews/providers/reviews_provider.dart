import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/reviews/models/reviews_list/rating.dart';
import 'package:base_ecom_appsure/features/reviews/models/users_review.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

final reviewsProvider = StateProvider.autoDispose<ReviewsProvider>(
      (ref) => ReviewsProvider(ref),
);

class ReviewsProvider {
  final RestClient _restClient;
  final Ref _ref;
  ReviewsProvider(this._ref) : _restClient = _ref.read(restClientProvider);

  String? get _language => _ref.read(settingsProvider).selectedLocale?.name;

  Future<Rating> addUserReview({
    required int id,
    required int itemID,
    required int orderID,
    required int rating,
    required String title,
    required String review,
  }) async {
    try {
      final response = await _restClient.insertUserReview({
        "TypeObject": {
          if (id != 0) "ID": id,
          "Language": _language,
          "Username": HiveRepo.instance.userName,
          "ItemID": itemID,
          "OrderID": orderID,
          "Title": title,
          "UserComments": review,
          "UserRatings": rating,
        }
      });
      final data = response.result?.table1.firstOrNull;
      if (data != null) {
        return data;
      } else {
        throw AppException('No data found');
      }
    } catch (e) {
      throw AppException(e);
    }
  }

  Future<Rating> getReviewsByItemID(int id) async {
    try {
      final response = await _restClient.fillReviewByItemID({
        "ID": id,
        "Language": _language,
        "Username": HiveRepo.instance.userName,
      });

      final data = response.result?.table1.firstOrNull;
      if (data != null) {
        return data;
      } else {
        throw AppException('No data found');
      }
    } catch (e) {
      throw AppException(e);
    }
  }

  Future<UsersReview> getExistingReview(int id) async {
    try {
      final resonse = await _restClient.getExistingReview({
        "ID": id,
        "Language": _language,
        "Username": HiveRepo.instance.userName,
      });

      return resonse.result;
    } catch (e) {
      throw AppException(e);
    }
  }
}
