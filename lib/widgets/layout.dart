import 'package:flutter/material.dart';

class LayoutWidget extends StatelessWidget {
  const LayoutWidget({
    super.key,
    this.horizontal = false,
    this.vertical = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.children = const <Widget>[],
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
  final bool horizontal;
  final bool vertical;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      );
    } else {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      );
    }
  }
}
