import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/addresses/models/address.dart';
import 'package:base_ecom_appsure/features/addresses/presentation/address_item.dart';
import 'package:base_ecom_appsure/features/addresses/providers/address_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/widgets/shimmer.dart';

class CheckoutAddresses extends ConsumerWidget {
  const CheckoutAddresses({
    super.key,
    required this.goToAddAddress,
    required this.address,
    required this.onAddressChanged,
    this.onEditAddress,
  });

  final VoidCallback goToAddAddress;
  final Address? address;
  final ValueChanged<Address?> onAddressChanged;
  final ValueChanged<Address>? onEditAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return ref.watch(addressesProvider).when(
      onLoading: () => CustomShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _container(
              height: 23,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            const Gap(12.0),
            _container(height: 95),
            const Gap(8),
            _container(height: 95),
          ],
        ),
      ),
      onSuccess: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _title(
              context,
              settings.selectedLocale!.translate(
                'OldAddress',
              ),
            ),
            const Gap(12.0),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index >= data.length) {
                  return TextButton(
                    onPressed: () => goToAddAddress(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add),
                        const Gap(12),
                        Text(
                          settings.selectedLocale!.translate(
                            'NewAddress',
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return AddressItem(
                  address: data[index],
                  groupValue: address,
                  onChanged: onAddressChanged,
                  showIsDefault: false,
                  showActions: true,
                  showTopEdit: false,
                  showDeliveryCharge: true,
                  onEditClicked: () => onEditAddress?.call(data[index]),
                );
              },
            ),
          ],
        );
      },
      onError: (error) => const SizedBox.shrink(),
    );
  }

  Widget _title(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Container _container({
    required double height,
    double width = double.infinity,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.8),
      ),
      width: width,
    );
  }
}
