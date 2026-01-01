import 'package:flutter/material.dart';
import 'package:to_do_app/main.dart';
// To access themeNotifier

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? extraActions;
  final bool showThemeToggle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.extraActions,
    this.showThemeToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = themeNotifier.value == ThemeMode.dark;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 24,
        ),
      ),
      actions: [
        if (extraActions != null) ...extraActions!,
        if (showThemeToggle)
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
