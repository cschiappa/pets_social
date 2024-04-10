import 'package:flutter/material.dart';
import 'package:pets_social/core/widgets/info_bubble/info_bubble.dart';

void showInfoBubble(
  String title,
  String description,
  GlobalKey focusableWidgetKey,
  Color bgColor, {
  double bubbleWidth = 300.0,
  double bubblePadding = 32.0,
  double bubbleTipWidth = 22.0,
  double bubbleTipHeight = 12.0,
}) {
  showDialog(
    context: focusableWidgetKey.currentContext!,
    builder: (BuildContext context) {
      return InfoBubbleDialogWidget(
        title,
        description,
        focusableWidgetKey,
        bgColor,
        bubbleWidth: bubbleWidth,
        bubblePadding: bubblePadding,
        bubbleTipWidth: bubbleTipWidth,
        bubbleTipHeight: bubbleTipHeight,
      );
    },
  );
}
