import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:base_ecom_appsure/widgets/responsive_builder.dart';

final categorySizeProvider = StateProvider.autoDispose<CategoryItemSize>(
      (ref) => CategoryItemSize(),
);

class CategoryItemSize {
  double height(BuildContext context) {
    return Responsive.valueWhen(
      context: context,
      mobile: MediaQuery.of(context).size.width / 4,
      smallTablet: MediaQuery.of(context).size.width / 6,
      mediumTablet: MediaQuery.of(context).size.width / 6,
      largeTablet: MediaQuery.of(context).size.width / 6,
      desktop: MediaQuery.of(context).size.width / 10,
    ).h;
  }

  double width(BuildContext context) {
    return Responsive.valueWhen(
      context: context,
      mobile: MediaQuery.of(context).size.width / 4.5,
      smallTablet: MediaQuery.of(context).size.width / 8,
      mediumTablet: MediaQuery.of(context).size.width / 12,
      largeTablet: MediaQuery.of(context).size.width / 12,
      desktop: MediaQuery.of(context).size.width / 32,
    ).w;
  }
}
