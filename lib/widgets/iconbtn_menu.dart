import 'package:flutter/material.dart';

class IconbtnMenu extends StatelessWidget {
  final Icon icon;
  final List<Widget> items;

  const IconbtnMenu({super.key, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        elevation: const WidgetStatePropertyAll(3),
      ),
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
          icon: icon,
        );
      },
      menuChildren: items,
    );
  }
}
