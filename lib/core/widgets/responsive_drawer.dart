import 'package:flutter/material.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';

class ResponsiveDrawer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    if (isWeb) {
      return Row(
        children: [
          drawer,
          Container(width: 0.5, color: Colors.black),
          Expanded(child: content),
        ],
      );
    } else {
      return Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: content,
      );
    }
  }
}
