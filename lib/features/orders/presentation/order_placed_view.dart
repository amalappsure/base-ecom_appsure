import 'package:base_ecom_appsure/foundation/string_exts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import 'package:base_ecom_appsure/features/addresses/models/address.dart';
import 'package:base_ecom_appsure/features/addresses/presentation/address_item.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/models/cart_item.dart';
import 'package:base_ecom_appsure/features/checkout/presentation/payment_methods.dart';
import 'package:base_ecom_appsure/features/products/models/payment_methods.dart';
import 'package:base_ecom_appsure/widgets/custom_app_bar.dart';
import 'package:base_ecom_appsure/widgets/default_card.dart';

import '../../../themes/shadows.dart';

class OrderPlacedView extends ConsumerStatefulWidget {
  const OrderPlacedView({
    super.key,
    required this.items,
    required this.appBarBuilder,
    this.failed = false,
    this.deliveryAddress,
    this.paymentMethod,
    this.total,
    this.color,
  });

  final List<CartItem> items;
  final CustomAppBarBuilder appBarBuilder;
  final bool failed;
  final Address? deliveryAddress;
  final PaymentMethod? paymentMethod;
  final double? total;
  final Color? color;

  @override
  ConsumerState<OrderPlacedView> createState() => _OrderPlacedViewState();
}

class _OrderPlacedViewState extends ConsumerState<OrderPlacedView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create an AnimationController with a duration of 2 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Create a Tween animation that interpolates values from 100 to 300
    _animation = Tween<double>(begin: 0, end: 0.78).animate(_controller);

    // Start the animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.color ?? Colors.white,
      appBar: widget.appBarBuilder('', false),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16).copyWith(
        //   top: 0.0,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.2,
              child: Center(
                child: Lottie.asset(
                  widget.failed
                      ? 'assets/lotties/failed.json'
                      : 'assets/lotties/success.json',
                  package: 'base_ecom_appsure',
                  repeat: false,
                  controller: _animation,
                ),
              ),
            ),
            Center(
              child: AutoSizeText(
                settings.selectedLocale!.translate(
                  widget.failed ? 'YourOrderFailed' : 'YourOrderHasBeenSuccessfullyPlaced',
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 22),
              ),
            ),
            const Gap(15.0),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(5.0),
                  Text(
                    settings.selectedLocale!.translate('items').capitalizeFirst!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(12),
                  DefaultCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      itemCount: widget.items.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => _Item(
                        item: widget.items[index],
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ),
                  if (widget.deliveryAddress != null) ...[
                    const Gap(12.0),
                    Text(
                      settings.selectedLocale!.translate(
                        'DeliveryAddress',
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(4),
                    AddressItem(
                      address: widget.deliveryAddress!,
                      showActions: false,
                      showIsDefault: false,
                      showTopEdit: false,
                    )
                  ],
                  if (widget.paymentMethod != null) ...[
                    const Gap(12.0),
                    Text(
                      settings.selectedLocale!.translate(
                        'PaymentMethod',
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(12),
                    PaymentMethodWidget(
                      method: widget.paymentMethod!,
                    )
                  ],
                  if (widget.total != null) ...[
                    const Gap(12.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settings.selectedLocale!.translate(
                            'TotalAmount',
                          ),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Gap(8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:Border.all(
                              color: Theme.of(context).dividerColor.withOpacity(0.2),
                            ),
                            boxShadow: const [shadow1],
                            color: Colors.white,
                          ),
                          child: Text(settings.priceText(widget.total),
                              style: Theme.of(context).textTheme.headline6),
                        ),
                      ],
                    )
                  ],
                  const Gap(12.0),
                ],
              ),
            ),
          ],
        )
        ),


    );
  }
}

class _Item extends ConsumerWidget {
  const _Item({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        CachedNetworkImage(
          height: size.height * 0.15,
          width: size.height * 0.15,
          imageUrl: item.itemImage ?? '',
        ),
        const Gap(6),
        Flexible(
          child: Column(
            children: [
              Text(
                item.itemName ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _titleAndValue(
                    context,
                    settings.selectedLocale!.translate('Unit'),
                    item.unit ?? '',
                    CrossAxisAlignment.start,
                  ),
                  _titleAndValue(
                    context,
                    settings.selectedLocale!.translate('Qty'),
                    item.quantity.toString(),
                    CrossAxisAlignment.center,
                  ),
                  _titleAndValue(
                    context,
                    settings.selectedLocale!.translate('SubTotal'),
                    settings.priceText(
                      (item.subTotal ?? 0).toDouble(),
                    ),
                    CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _titleAndValue(
      BuildContext context,
      String title,
      String value,
      CrossAxisAlignment alignment,
      ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
