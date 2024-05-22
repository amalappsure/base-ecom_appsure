import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/addresses/models/address.dart';
import 'package:base_ecom_appsure/features/addresses/models/address_type.dart';
import 'package:base_ecom_appsure/features/addresses/providers/address_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/auth/providers/auth_provider.dart';
import 'package:base_ecom_appsure/features/auth/providers/login_state_provider.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/foundation/string_exts.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/country_code.dart';
import 'package:base_ecom_appsure/models/misc_values.dart';
import 'package:base_ecom_appsure/widgets/custom_drop_down.dart';
import 'package:base_ecom_appsure/widgets/phone_field.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

class AddAddressForm extends ConsumerStatefulWidget {
  const AddAddressForm({
    super.key,
    this.address,
  });

  final Address? address;

  @override
  ConsumerState<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends ConsumerState<AddAddressForm> {
  AddressType? addressType;
  MiscValue? area;

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isDefault = true;

  late List<TextEditingController> _editingControllers;
  late TextEditingController _confirmMobileController;
  CountryCode countryCode = countryCodes.first;

  bool get isLoggedIn => ref.read(loginStateProvider) is LoggedIn;

  @override
  void initState() {
    if (widget.address?.addressTypeId != null) {
      addressType = addressTypes.firstWhereOrNull(
            (element) => element.id == widget.address?.addressTypeId,
      ) ??
          addressTypes.first;
    } else {
      addressType = addressTypes.first;
    }

    if (widget.address != null) {
      isDefault = widget.address!.defaultAddress;
    }

    _editingControllers = List.generate(
      11,
          (index) {
        switch (index) {
          case 0:
            return TextEditingController()
              ..text = widget.address?.fullName ?? '';
          case 1:
            return TextEditingController()..text = widget.address?.phone ?? '';
          case 2:
            return TextEditingController()..text = widget.address?.email ?? '';
          case 3:
            return TextEditingController()..text = widget.address?.block ?? '';
          case 4:
            return TextEditingController()..text = widget.address?.street ?? '';
          case 5:
            return TextEditingController()..text = widget.address?.jadah ?? '';
          case 6:
            return TextEditingController()
              ..text = widget.address?.address1 ?? '';
          case 7:
            return TextEditingController()
              ..text = widget.address?.houseNo ?? '';
          case 8:
            return TextEditingController()..text = widget.address?.floor ?? '';
          case 9:
            return TextEditingController()
              ..text = widget.address?.landmark ?? '';
          case 10:
            return TextEditingController()
              ..text = widget.address?.residenceAddress ?? '';
          default:
            return TextEditingController();
        }
      },
    );

    _confirmMobileController = TextEditingController()
      ..text = widget.address?.phone ?? '';
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => ref.read(addressProvider).getAreas(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final areasState = ref.watch(areasProvider);

    if (areasState.isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 48,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFieldWithTitleBase.widget(
            controller: _editingControllers[0],
            label: settings.selectedLocale!.translate('Fullname'),
            isRequired: true,
            textInputAction: TextInputAction.next,
            validator: (value) => Rule(
              value,
              name: settings.selectedLocale!.translate('Fullname'),
              isRequired: true,
              customErrors: {
                'isRequired': settings.selectedLocale!.translate(
                  'PleaseEnterName',
                ),
              },
            ).error,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          const Gap(18),
          PhoneFieldWithTitle(
            isRequired: true,
            label: settings.selectedLocale!.translate(
              'GuestMobileNumber',
            ),
            initialValue: countryCode,
            hint: settings.selectedLocale!.translate('EnterMobileNumber'),
            editingController: _editingControllers[1],
            onChanged: (value) {},
          ),
          const Gap(8),
          PhoneFieldWithTitle(
            label: settings.selectedLocale!.translate(
              'ConfirmMobileNumber',
            ),
            isRequired: true,
            initialValue: countryCode,
            hint: settings.selectedLocale!.translate('EnterMobileNumber'),
            editingController: _confirmMobileController,
            onChanged: (value) {},
            validator: (value) {
              if (_editingControllers[1].text !=
                  _confirmMobileController.text) {
                return settings.selectedLocale!.translate(
                  'ConfirmYourMobileNumber',
                );
              }
              return null;
            },
          ),
          const Gap(8),
          TextFieldWithTitleBase.widget(
            controller: _editingControllers[2],
            label: settings.selectedLocale!.translate('Email'),
            textInputAction: TextInputAction.next,
            validator: (value) => Rule(
              value,
              name: settings.selectedLocale!.translate('Email'),
              // isRequired: true,
              isEmail: true,
            ).error,
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(18),
          DropdownWithTitle(
            items: addressTypes
                .map(
                  (e) => AddressType(
                id: e.id,
                name: settings.selectedLocale!.translate(e.name),
              ),
            )
                .toList(),
            label: settings.selectedLocale!.translate('SelectAddressType'),
            isRequired: true,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  addressType = value;
                });
              }
            },
            value: addressType,
            validator: (value) => Rule(
              value?.toString(),
              name: settings.selectedLocale!.translate('SelectAddressType'),
              isRequired: true,
            ).error,
          ),
          const Gap(18),
          ref.watch(areasProvider).when(
            onLoading: () => Column(
              children: [
                DropdownWithTitle(
                  items: const [],
                  isRequired: true,
                  label: settings.selectedLocale!.translate(
                    'Area',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        area = value;
                      });
                    }
                  },
                  value: area,
                  enabled: false,
                ),
                const Gap(18),
              ],
            ),
            onSuccess: (data) {
              if (widget.address?.areaId != null && area == null) {
                area = data.firstWhereOrNull(
                      (element) => element.id == widget.address?.areaId,
                );
              } else if (ref.read(settingsProvider).area != null &&
                  area == null) {
                area = data.firstWhereOrNull(
                      (element) =>
                  element.id == ref.read(settingsProvider).area?.id,
                );
              }
              return Column(
                children: [
                  DropdownWithTitle(
                    items: data,
                    label: settings.selectedLocale!.translate(
                      'Area',
                    ),
                    isRequired: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          area = value;
                        });
                      }
                    },
                    value: area,
                    validator: (value) {
                      return Rule(
                        value?.toString(),
                        name: settings.selectedLocale!.translate('Area'),
                        isRequired: true,
                        customErrors: {
                          'isRequired': settings.selectedLocale!.translate(
                            'PleaseSelectArea',
                          ),
                        },
                      ).error;
                    },
                  ),
                  const Gap(18),
                ],
              );
            },
            onError: (error) => const SizedBox.shrink(),
          ),
          Row(
            children: [
              Expanded(
                child: TextFieldWithTitleBase.widget(
                  controller: _editingControllers[3],
                  isRequired: true,
                  label: settings.selectedLocale!.translate('Block'),
                  textInputAction: TextInputAction.next,
                  validator: (value) => Rule(
                    value,
                    name: settings.selectedLocale!.translate('Block'),
                    isRequired: true,
                    customErrors: {
                      'isRequired': settings.selectedLocale!.translate(
                        'PleaseEnterBlock',
                      ),
                    },
                  ).error,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const Gap(8),
              Expanded(
                child: TextFieldWithTitleBase.widget(
                  controller: _editingControllers[4],
                  isRequired: true,
                  label: settings.selectedLocale!.translate('Street'),
                  textInputAction: TextInputAction.next,
                  validator: (value) => Rule(
                    value,
                    name: settings.selectedLocale!.translate('Street'),
                    isRequired: true,
                    customErrors: {
                      'isRequired': settings.selectedLocale!.translate(
                        'PleaseEnterStreet',
                      ),
                    },
                  ).error,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          const Gap(18),
          Row(
            children: [
              Expanded(
                child: TextFieldWithTitleBase.widget(
                  controller: _editingControllers[5],
                  label: settings.selectedLocale!.translate('Jadah'),
                  textInputAction: TextInputAction.next,
                  // validator: (value) => Rule(
                  //   value,
                  //   name: settings.selectedLocale!.translate('Jadah'),
                  //   isRequired: true,
                  // ).error,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const Gap(8),
              Expanded(
                child: TextFieldWithTitleBase.widget(
                  controller: _editingControllers[6],
                  isRequired: true,
                  label: settings.selectedLocale!.translate('BuildingNo'),
                  textInputAction: TextInputAction.next,
                  validator: (value) => Rule(
                    value,
                    name: settings.selectedLocale!.translate('BuildingNo'),
                    isRequired: true,
                    customErrors: {
                      'isRequired': settings.selectedLocale!.translate(
                        'PleaseEnterBuildingName',
                      ),
                    },
                  ).error,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          const Gap(18),
          Row(
            children: [
              Expanded(
                child: TextFieldWithTitleBase.widget(
                  controller: _editingControllers[8],
                  label: settings.selectedLocale!.translate('Floor'),
                  textInputAction: TextInputAction.next,
                  // validator: (value) => Rule(
                  //   value,
                  //   name: settings.selectedLocale!.translate('Floor'),
                  //   isRequired: true,
                  //   isNumeric: true,
                  // ).error,
                  keyboardType: TextInputType.number,
                ),
              ),
              const Gap(8),
              Expanded(
                child: TextFieldWithTitleBase.widget(
                  controller: _editingControllers[7],
                  label: settings.selectedLocale!.translate('Flat'),
                  textInputAction: TextInputAction.next,
                  // validator: (value) => Rule(
                  //   value,
                  //   name: settings.selectedLocale!.translate('Flat'),
                  //   isRequired: true,
                  // ).error,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          const Gap(18),
          TextFieldWithTitleBase.widget(
            controller: _editingControllers[9],
            label: settings.selectedLocale!.translate('Landmark'),
            textInputAction: TextInputAction.next,
            // validator: (value) => Rule(
            //   value,
            //   name: settings.selectedLocale!.translate('Landmark'),
            //   isRequired: true,
            // ).error,
            keyboardType: TextInputType.streetAddress,
            textCapitalization: TextCapitalization.words,
          ),
          const Gap(18),
          TextFieldWithTitleBase.widget(
            controller: _editingControllers[10],
            label: settings.selectedLocale!.translate('Remarks'),
            textInputAction: TextInputAction.done,
            minLines: 3,
            maxLines: 4,
            keyboardType: TextInputType.streetAddress,
            textCapitalization: TextCapitalization.sentences,
          ),
          const Gap(18),
          GestureDetector(
            onTap: () => setState(() {
              isDefault = !isDefault;
            }),
            child: Row(
              children: [
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  value: isDefault,
                  onChanged: (value) => setState(() {
                    isDefault = value ?? false;
                  }),
                ),
                const Gap(8),
                Text(
                  settings.selectedLocale!.translate(
                    'SetAsDefault',
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
          const Gap(24),
          if (loading)
            _progressIndicator
          else
            ElevatedButton(
              onPressed: _submit,
              child: Text(
                settings.selectedLocale!.translate('SaveAddress'),
              ),
            )
        ],
      ),
    );
  }

  Widget get _progressIndicator => const Center(
    child: CircularProgressIndicator.adaptive(),
  );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
    });

    if (!isLoggedIn) {
      await ref.read(authProvider).registerGuestUser(
        name: _editingControllers[0].text,
        mobile: _editingControllers[1].text,
        email: _editingControllers[2].text.nullIfEmpty,
      );
    }

    try {
      await ref.read(addressProvider).createAdress(
        id: widget.address?.id,
        fullName: _editingControllers[0].text,
        phone: _editingControllers[1].text,
        email: _editingControllers[2].text,
        block: _editingControllers[3].text,
        street: _editingControllers[4].text,
        jadah: _editingControllers[5].text,
        address1: _editingControllers[6].text, // Building No
        houseNo: _editingControllers[7].text, // Flat
        floor: _editingControllers[8].text,
        landmark: _editingControllers[9].text,
        residenceAddress: _editingControllers[10].text, // Remarks
        areaId: area!.id,
        addressTypeID: addressType!.id,
        isDefault: isDefault,
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: AppException(e).toString(),
      );
    }

    setState(() {
      loading = false;
    });
  }
}
