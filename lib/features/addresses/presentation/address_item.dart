import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/addresses/models/address.dart';
import 'package:base_ecom_appsure/features/addresses/providers/address_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';
import 'package:base_ecom_appsure/widgets/confirmation_dialog.dart';

class AddressItem extends ConsumerWidget {
  const AddressItem({
    super.key,
    required this.address,
    this.onEditClicked,
    this.showActions = true,
    this.showIsDefault = true,
    this.groupValue,
    this.onChanged,
    this.showDeliveryCharge = false,
    this.showTopEdit = true,
  });

  final Address address;
  final VoidCallback? onEditClicked;
  final bool showActions;
  final bool showIsDefault;
  final Address? groupValue;
  final ValueChanged<Address?>? onChanged;
  final bool showDeliveryCharge;
  final bool showTopEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final editButton = IconButton(
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      onPressed: onEditClicked,
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );

    return GestureDetector(
      onTap: () => onChanged?.call(address),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: address == groupValue
              ? Border.all(
            color: Theme.of(context).colorScheme.primary,
          )
              : Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
          boxShadow: const [shadow1],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (groupValue != null) ...[
              Radio.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.comfortable,
                value: address,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              const Gap(8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${settings.selectedLocale!.translate('Name')}: ${address.fullName ?? ''}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (address.defaultAddress && showIsDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Text(
                            settings.selectedLocale!.translate(
                              'DefaultAddress',
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      else if (showTopEdit)
                        editButton
                    ],
                  ),
                  const Gap(6),

                  // if (address.landmark != null)
                  //   Text(
                  //     '${settings.selectedLocale!.translate('Landmark')}: ${address.landmark}',
                  //     style: Theme.of(context).textTheme.bodyMedium,
                  //   ),
                  // if (addressLine(context).isNotEmpty) ...[
                  //   Text(
                  //     '${settings.selectedLocale!.translate('Address')}: ${addressLine(context)}',
                  //     style: Theme.of(context).textTheme.bodyMedium,
                  //   ),
                  //   const Gap(4),
                  // ],
                  Text(
                    '${settings.selectedLocale!.translate('Area')}: ${address.area}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(4),
                  Text(
                    '${settings.selectedLocale!.translate('Block')}: ${address.block}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(4),
                  Text(
                    '${settings.selectedLocale!.translate('BuildingNo')}: ${address.address1}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(4),
                  Text(
                    '${settings.selectedLocale!.translate('Street')}: ${address.street}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(4),
                  if (address.phone != null) ...[
                    Text(
                      '${settings.selectedLocale!.translate('Mobile')}: ${address.phone}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Gap(4),
                  ],
                  if (address.email != null && address.email!.isNotEmpty) ...[
                    Text(
                      '${settings.selectedLocale!.translate('Email')}: ${address.email}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Gap(4),
                  ],

                  // if (address.residenceAddress != null)
                  //   Text(
                  //     '${settings.selectedLocale!.translate('Remarks')}: ${address.residenceAddress}',
                  //     style: Theme.of(context).textTheme.bodyMedium,
                  //   ),
                  if (showActions) ...[
                    const Gap(4),
                    Row(
                      children: [
                        editButton,
                        const Gap(4),
                        IconButton(
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => _onDeleteClicked(
                            context,
                            settings,
                            ref,
                            address.id,
                          ),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        if (!address.defaultAddress) ...[
                          const Gap(4),
                          Expanded(
                            child: TextButton(
                              onPressed: () =>
                                  ref.read(addressProvider).makeDefault(
                                    address.id,
                                  ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                settings.selectedLocale!.translate(
                                  'SetAsDefaultAddress',
                                ),
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                  ],
                  if (showDeliveryCharge && address.deliveryCharge != null) ...[
                    const Gap(6),
                    Row(
                      children: [
                        Text(
                          '${settings.selectedLocale!.translate('DeliveryCharge')}:'
                              ' ${settings.priceText(address.deliveryCharge!)}',
                          style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String addressLine(BuildContext context) {
    final list = <String>[];
    if (address.area != null) {
      list.add(address.area!);
    }
    if (address.block != null) {
      list.add(address.block!);
    }
    // if (address.jadah != null) {
    //   list.add(address.jadah!);
    // }
    if (address.street != null) {
      list.add(address.street!);
    }
    if (address.address1 != null) {
      list.add(address.address1!);
    }
    // if (address.floor != null) {
    //   list.add(address.floor!);
    // }
    // if (address.houseNo != null) {
    //   list.add(address.houseNo!);
    // }

    return list.join(', ');
  }

  Future<void> _onDeleteClicked(
      BuildContext context,
      AppSettingsprovider settings,
      WidgetRef ref,
      int id,
      ) async {
    final result = await showAdaptiveDialog<bool?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmationDialog(
        message: settings.selectedLocale!.translate(
          'DeleteAddressMsg',
        ),
        positiveButtonLabel: settings.selectedLocale!.translate(
          'Delete',
        ),
      ),
    );

    if (result == true) {
      try {
        ref.read(addressProvider).deleteAddress(id);
      } catch (e) {
        //
      }
    }
  }
}
