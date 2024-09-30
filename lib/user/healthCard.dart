import 'package:flutter/material.dart';

class HealthCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String date;
  final Color valueColor;
  final Color progressBarColor;
  final double progressValue;
  final int minValue;
  final int maxValue;
  final List<String> rangeValues;

  const HealthCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.date,
    required this.valueColor,
    required this.progressBarColor,
    required this.progressValue,
    required this.minValue,
    required this.maxValue,
    required this.rangeValues,
  });

  List<Widget> getRangeText() {
    List<Widget> list = rangeValues
        .map((e) => Text(e,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)))
        .toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 30),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            Text(date, style: const TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value,
                    style: TextStyle(
                        color: valueColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (progressValue - minValue) / (maxValue - minValue),
              backgroundColor: Colors.grey[300],
              color: progressBarColor,
              minHeight: 14,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getRangeText(),
            ),
          ],
        ),
      ),
    );
  }
}
