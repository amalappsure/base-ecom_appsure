import 'package:base_ecom_appsure/models/country_code.dart';
import 'package:flutter/material.dart';

class CoutryCodeSelectorBS extends StatelessWidget {
  const CoutryCodeSelectorBS({
    super.key,
    required this.selected,
  });

  final CountryCode selected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0.0),
            child: Text(
              'Select contry code',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: countryCodes.length,
            itemBuilder: (context, index) => TextButton(
              onPressed: () => Navigator.of(context).pop(countryCodes[index]),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "+${countryCodes[index].code} ${countryCodes[index].countryName}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (selected == countryCodes[index])
                    const Icon(
                      Icons.check_rounded,
                      size: 18.0,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
