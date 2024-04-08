import 'package:flutter/material.dart';

// Max widths
const double _mobile = 479;
const double _smallTablet = 670;
const double _mediumTablet = 767;
const double _largeTablet = 991; // lager than this is considered desktop size

typedef ResponsiveBuilder = Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    Widget? child,
    );

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.smallTablet,
    this.mediumTablet,
    this.largeTablet,
    this.desktop,
    this.child,
  });

  final ResponsiveBuilder mobile;
  final ResponsiveBuilder? smallTablet;
  final ResponsiveBuilder? mediumTablet;
  final ResponsiveBuilder? largeTablet;
  final ResponsiveBuilder? desktop;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (width > _largeTablet && desktop != null) {
          return desktop!(context, constraints, child);
        }

        if (width > _mediumTablet && largeTablet != null) {
          return largeTablet!(context, constraints, child);
        }

        if (width > _smallTablet && mediumTablet != null) {
          return mediumTablet!(context, constraints, child);
        }

        if (width > _mobile && smallTablet != null) {
          return smallTablet!(context, constraints, child);
        }

        return mobile(context, constraints, child);
      },
    );
  }

  static T valueWhen<T>({
    required BuildContext context,
    required T mobile,
    T? smallTablet,
    T? mediumTablet,
    T? largeTablet,
    T? desktop,
    String? parentName,
  }) {
    final width = MediaQuery.of(context).size.width;
    // if (width > _largeTablet) {
    //   print("~~desktop");
    // } else if (width > _mediumTablet) {
    //   print("~~largeTablet");
    // } else if (width > _smallTablet) {
    //   print("~~mediumTablet");
    // } else if (width > _mobile) {
    //   print("~~smallTablet");
    // } else {
    //   print("~~mobile");
    // }

    if (width > _largeTablet && desktop != null) {
      // print("~~$parentName-desktop: $desktop");
      return desktop;
    }

    if (width > _mediumTablet && largeTablet != null) {
      // print("~~$parentName-largeTablet: $largeTablet");
      return largeTablet;
    }

    if (width > _smallTablet && mediumTablet != null) {
      // print("~~$parentName-mediumTablet: $mediumTablet");
      return mediumTablet;
    }

    if (width > _mobile && smallTablet != null) {
      // print("~~$parentName-smallTablet: $smallTablet");
      return smallTablet;
    }

    return mobile;
  }
}
