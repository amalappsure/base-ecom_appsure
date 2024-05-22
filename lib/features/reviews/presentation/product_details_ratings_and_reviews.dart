import 'dart:async';

import 'package:base_ecom_appsure/features/reviews/models/reviews_list/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/reviews/models/users_review.dart';
import 'package:base_ecom_appsure/features/reviews/presentation/add_review_bs.dart';
import 'package:base_ecom_appsure/features/reviews/providers/reviews_provider.dart';

import 'review_progress.dart';

class RatingsAndreviews extends ConsumerStatefulWidget {
  const RatingsAndreviews({
    super.key,
    required this.productId,
  });
  final int productId;

  @override
  ConsumerState<RatingsAndreviews> createState() => _RatingsAndreviewsState();
}

class _RatingsAndreviewsState extends ConsumerState<RatingsAndreviews> {
  late StreamController<UsersReview> _existingReviewController;
  late StreamController<Rating> _reviewsController;

  @override
  void initState() {
    _existingReviewController = StreamController<UsersReview>.broadcast();
    _reviewsController = StreamController<Rating>.broadcast();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchExistingReview();
      fetchReviews();
    });
    super.initState();
  }

  @override
  void dispose() {
    _existingReviewController.close();
    _reviewsController.close();
    super.dispose();
  }

  ReviewsProvider get provider => ref.read(reviewsProvider);

  Future<void> fetchExistingReview() async {
    try {
      final data = await provider.getExistingReview(widget.productId);
      if (!_existingReviewController.isClosed) {
        _existingReviewController.add(data);
      }
    } catch (error) {
      if (!_existingReviewController.isClosed) {
        _existingReviewController.addError(error);
      }
    }
  }

  Future<void> fetchReviews() async {
    try {
      final data = await provider.getReviewsByItemID(widget.productId);
      if (!_reviewsController.isClosed) {
        _reviewsController.add(data);
      }
    } catch (error) {
      if (!_reviewsController.isClosed) {
        _reviewsController.addError(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          stream: _existingReviewController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox.shrink();
            } else if (!snapshot.hasData) {
              return const SizedBox.shrink();
            } else {
              if (snapshot.data!.orderId == 0) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(16.0),
                    Text(
                      settings.selectedLocale!.translate('ReviewThisProduct'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      settings.selectedLocale!.translate('ShareYourThoughts'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Gap(8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () => showAddReviewBS(snapshot.data!),
                        child: Text(
                          settings.selectedLocale!.translate(
                            'WriteAProductReview',
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                  ],
                ),
              );
            }
          },
        ),
        StreamBuilder(
          stream: _reviewsController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox.shrink();
            } else if (!snapshot.hasData) {
              return const SizedBox.shrink();
            } else {
              final data = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      settings.selectedLocale!.translate('TotalReviews'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: data.average.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const WidgetSpan(child: SizedBox(width: 3)),
                          const WidgetSpan(child: Icon(Icons.star, size: 19)),
                          const WidgetSpan(child: SizedBox(width: 6)),
                          TextSpan(
                            text:
                            '${data.totalUserRatings} ${settings.selectedLocale!.translate('Ratings')}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    const Gap(4),
                    ...['5', '4', '3', '2', '1'].map(
                          (e) => ReviewProgress(
                        rating: e,
                        count: data.countOf(e),
                        width: data.countOf(e) / data.totalUserRatings,
                      ),
                    ),
                    const Gap(16.0),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future<void> showAddReviewBS(UsersReview review) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => AddReviewBS(
        usersReview: review,
      ),
    );
    setState(() {});
  }
}
