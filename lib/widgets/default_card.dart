import 'package:flutter/material.dart';

import 'package:base_ecom_appsure/themes/shadows.dart';

class DefaultCard extends StatelessWidget {
  const DefaultCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(
      vertical: 16.0,
    ),
    this.shadow = shadow1,
    this.border,
  });

  const DefaultCard.smallMargin({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(
      vertical: 8.0,
    ),
    this.shadow = shadow1,
    this.border,
  });

  final Widget? child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxShadow shadow;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [shadow1],
        borderRadius: BorderRadius.circular(16),
        border: border,
      ),
      child: child,
    );
  }
}
