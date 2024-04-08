import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    BuildContext context, {
      required String message,
      bool isError = false,
      EdgeInsets? padding,
    }) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        content: Text(message),
        padding: padding,
      ),
    );

ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>
showBanner(
    BuildContext context, {
      required String message,
    }) =>
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('OK'),
          )
        ],
      ),
    );
