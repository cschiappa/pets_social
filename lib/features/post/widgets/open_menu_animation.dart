import 'package:flutter/material.dart';

class OpenMenuAnimation extends StatefulWidget {
  final Widget child;
  final isMenuOpen;
  const OpenMenuAnimation({super.key, required this.child, required this.isMenuOpen});

  @override
  State<OpenMenuAnimation> createState() => _OpenMenuAnimationState();
}

class _OpenMenuAnimationState extends State<OpenMenuAnimation> {
  @override
  Widget build(BuildContext context) {
    const Duration animationDuration = Duration(milliseconds: 300);

    return AnimatedPositioned(
      duration: animationDuration,
      curve: Curves.easeInOut,
      top: 0,
      bottom: 0,
      width: widget.isMenuOpen ? 200 : 0,
      child: widget.child,
    );
  }
}
