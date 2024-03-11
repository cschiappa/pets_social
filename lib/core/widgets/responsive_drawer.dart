import 'package:flutter/material.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';

class ResponsiveDrawer extends StatefulWidget {
  final Widget drawer;
  final Widget content;
  final PreferredSizeWidget? appBar;

  const ResponsiveDrawer({
    super.key,
    required this.drawer,
    required this.content,
    required this.appBar,
  });

  @override
  State<ResponsiveDrawer> createState() => _ResponsiveDrawerState();
}

class _ResponsiveDrawerState extends State<ResponsiveDrawer> {
  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    if (isWeb) {
      return Row(
        children: [
          widget.drawer,
          Container(width: 0.5, color: Colors.black),
          Expanded(child: widget.content),
        ],
      );
    } else {
      return Scaffold(
        drawer: widget.drawer,
        appBar: widget.appBar,
        body: widget.content,
      );
    }
  }
}
