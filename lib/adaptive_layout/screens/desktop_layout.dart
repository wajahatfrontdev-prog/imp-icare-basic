import 'package:flutter/material.dart';
import 'package:icare/navigators/drawer.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
  });
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar!,
      floatingActionButton: floatingActionButton,
      body: Row(children: [CustomDrawer(), body!]),
    );
  }
}
