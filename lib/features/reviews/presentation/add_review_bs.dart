import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/reviews/models/users_review.dart';
import 'package:base_ecom_appsure/features/reviews/providers/reviews_provider.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AddReviewBS extends ConsumerStatefulWidget {
  const AddReviewBS({
    super.key,
    required this.usersReview,
  });

  final UsersReview usersReview;

  @override
  ConsumerState<AddReviewBS> createState() => _AddReviewBSState();
}

class _AddReviewBSState extends ConsumerState<AddReviewBS> {
  bool submitting = false;
  late double starValue;
  late final List<TextEditingController> _editingControllers;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    starValue = (widget.usersReview.userRatings ?? 1).toDouble();
    _editingControllers = List.generate(
      2,
          (index) {
        switch (index) {
          case 0:
            return TextEditingController(text: widget.usersReview.title);
          case 1:
            return TextEditingController(text: widget.usersReview.userComments);
          default:
            return TextEditingController();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0).copyWith(
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              settings.selectedLocale!.translate('WriteAReview'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(24),
            Text(
              settings.selectedLocale!.translate('OverallRating'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            StarRatingBar(
              context: context,
              ref: ref,
              initialValue: starValue,
              onChanged: (value) => setState(() => starValue = value),
              validator: (value) {
                if ((value ?? 0) < 1) {
                  return settings.selectedLocale!.translate(
                    'RatingCannotBeEmpty',
                  );
                }
                return null;
              },
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[0],
              textCapitalization: TextCapitalization.words,
              label: settings.selectedLocale!.translate('AddReviewTitle'),
              hint: settings.selectedLocale!.translate('ReviewTitle'),
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return settings.selectedLocale!.translate(
                    'TitleCannotBeEmpty',
                  );
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[1],
              textCapitalization: TextCapitalization.sentences,
              label: settings.selectedLocale!.translate('AddReviewDescription'),
              hint: settings.selectedLocale!.translate('ReviewDescription'),
              textInputAction: TextInputAction.done,
              minLines: 5,
            ),
            const Gap(24),
            if (submitting)
              const SizedBox.square(
                dimension: 48.0,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            else
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  settings.selectedLocale!.translate('Submit'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => submitting = true);
    try {
      await ref.read(reviewsProvider).addUserReview(
        id: widget.usersReview.id,
        itemID: widget.usersReview.itemId,
        orderID: widget.usersReview.orderId,
        rating: starValue.toInt(),
        title: _editingControllers[0].text,
        review: _editingControllers[1].text,
      );
    } catch (e) {
      //
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    setState(() => submitting = false);
  }
}

class StarRatingBar extends FormField<double> {
  StarRatingBar({
    super.key,
    required BuildContext context,
    required WidgetRef ref,
    required double initialValue,
    required ValueChanged<double> onChanged,
    super.validator,
  }) : super(
    builder: (state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RatingBar.builder(
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Color(0xFFFFE11B),
                ),
                minRating: 1.0,
                onRatingUpdate: (value) {
                  state.didChange(value);
                  onChanged(value);
                },
                unratedColor: const Color(0xFFE0E0E0),
                glow: false,
                initialRating: initialValue,
                allowHalfRating: false,
              ),
              const Gap(6),
              Text(
                ratingText(ref, state.value ?? initialValue),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                  ratingColor(ref, state.value ?? initialValue),
                ),
              ),
            ],
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                state.errorText ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            )
        ],
      );
    },
  );

  static String ratingText(WidgetRef ref, double starValue) {
    final settings = ref.read(settingsProvider);
    switch (starValue.toInt()) {
      case 1:
        return settings.selectedLocale!.translate('VeryBad');
      case 2:
        return settings.selectedLocale!.translate('Bad');
      case 3:
        return settings.selectedLocale!.translate('Good');
      case 4:
        return settings.selectedLocale!.translate('VeryGood');
      case 5:
        return settings.selectedLocale!.translate('Excellent');
      default:
        return '';
    }
  }

  static Color ratingColor(WidgetRef ref, double starValue) {
    switch (starValue.toInt()) {
      case 1:
        return const Color(0xFFE53935);
      case 2:
        return const Color(0xFFFFA500);
      case 3:
      case 4:
      case 5:
        return const Color(0xFF008000);
      default:
        return Colors.transparent;
    }
  }
}
