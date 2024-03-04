import 'package:flutter/material.dart';

class GreyCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget body;
  final double? height;

  const GreyCard({super.key, required this.title, required this.icon, required this.body, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey.shade900,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Icon(icon)
            ],
          ),
          const Divider(
            color: Colors.white,
          ),
          body,
        ],
      ),
    );
  }
}
