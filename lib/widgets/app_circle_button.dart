import 'package:flutter/material.dart';

class AppCircularButton extends StatelessWidget {
  final double width;
  final Color? color;
  final Widget child;
  final VoidCallback? onTap;
  const AppCircularButton(
      {super.key,
      this.width = 60,
      this.color,
      required this.child,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      type: MaterialType.transparency,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
