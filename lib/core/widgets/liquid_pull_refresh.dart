import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class LiquidPullRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const LiquidPullRefresh({super.key, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LiquidPullToRefresh(
      key: key,
      onRefresh: onRefresh,
      showChildOpacityTransition: false,
      animSpeedFactor: 4,
      color: Colors.pink[100],
      backgroundColor: theme.colorScheme.background,
      child: child,
    );
  }
}
