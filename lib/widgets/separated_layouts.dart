import 'package:flutter/material.dart';

extension RowExtension on Row {
  Widget separated(
      BuildContext context, {
        required WidgetBuilder separatorBuilder,
      }) {
    return Row(
      key: key,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: List.generate(
        children.length + (children.length - 1),
            (index) {
          if (index.isOdd) {
            return separatorBuilder(context);
          }
          final childIndex = index == 0 ? index : index ~/ 2;
          return children[childIndex];
        },
      ),
    );
  }
}

extension ColumnExtension on Column {
  Widget separated(
      BuildContext context, {
        required WidgetBuilder separatorBuilder,
      }) {
    return Column(
      key: key,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: List.generate(
        children.length + (children.length - 1),
            (index) {
          if (index % 2 == 1) {
            return separatorBuilder(context);
          }
          final childIndex = index == 0 ? index : index ~/ 2;
          return children[childIndex];
        },
      ),
    );
  }
}
