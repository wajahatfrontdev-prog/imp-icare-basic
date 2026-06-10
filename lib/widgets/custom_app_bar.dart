import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double elevation;
  final bool centerTitle;
  final double height;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation = 0,
    this.centerTitle = false,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).primaryColor;

    return Material(
      color: bg,
      elevation: elevation,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) leading! else const SizedBox.shrink(),
                if (leading != null)
                  const SizedBox(width: 8)
                else
                  const SizedBox.shrink(),
                Expanded(
                  child: Align(
                    alignment: centerTitle
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: title ?? const SizedBox.shrink(),
                  ),
                ),
                if (actions != null) ...actions! else const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
