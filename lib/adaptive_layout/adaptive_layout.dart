import 'package:flutter/material.dart';
import 'package:icare/adaptive_layout/screens/desktop_layout.dart';
import 'package:icare/adaptive_layout/screens/mobile_layout.dart';
import 'package:icare/adaptive_layout/screens/tablet_layout.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileLayout();
        } else if (constraints.maxWidth < 1024) {
          return TabletLayout();
        } else {
          return DesktopLayout();
        }
      },
    );
  }
}
