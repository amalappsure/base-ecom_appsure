import 'package:base_ecom_appsure/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';

EdgeInsets pagePadding(BuildContext context) => Responsive.valueWhen(
  context: context,
  mobile: const EdgeInsets.all(16),
  desktop: EdgeInsets.symmetric(
    vertical: desktopVertical(context),
    horizontal: desktopHorizontal(context),
  ),
);

double desktopVertical(BuildContext context) =>
    MediaQuery.of(context).size.height * 0.2;

double desktopHorizontal(BuildContext context) =>
    MediaQuery.of(context).size.height * 0.8;
