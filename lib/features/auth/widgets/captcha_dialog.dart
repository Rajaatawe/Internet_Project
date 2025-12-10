import 'dart:math';
import 'package:flutter/material.dart';
import 'package:internet_application_project/core/constants/app_assets.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';

class CaptchaDialog extends StatefulWidget {
  const CaptchaDialog({super.key});

  @override
  State<CaptchaDialog> createState() => _CaptchaDialogState();
}

class _CaptchaDialogState extends State<CaptchaDialog> {
  late List<Map<String, String>> images;
  late String targetLabel;
  late List<String> selectedLabels;
  late List<String> correctLabels;

  late List<int> selectedIndexes;

  @override
  void initState() {
    super.initState();
    generateCaptcha();
  }

  void generateCaptcha() {
    images = [
      {'label': 'cat', 'path': cat1},
      {'label': 'dog', 'path': dog1},
      {'label': 'car', 'path': car},
      {'label': 'tree', 'path': tree},
      {'label': 'dog', 'path': dog2},
      {'label': 'cat', 'path': cat2},
    ];

    images.shuffle();

    List<String> possible = ['cat', 'dog'];
    targetLabel = possible[Random().nextInt(possible.length)];

    correctLabels = images
        .where((img) => img['label'] == targetLabel)
        .map((e) => e['label']!)
        .toList();

    selectedLabels = [];
    selectedIndexes = []; 
  }

  void checkSelection(int index, String label) {
    if (selectedIndexes.contains(index)) return;

    selectedIndexes.add(index);

    if (label != targetLabel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wrong image! Try again."),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => generateCaptcha());
      return;
    }

    selectedLabels.add(label);

    if (selectedLabels.length == correctLabels.length) {
      Navigator.pop(context, true);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: whiteBrown,
      title: const Text(
        "Verify You Are Human",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Select all images containing a: ${targetLabel.toUpperCase()}",
            style: const TextStyle(color: primaryColor),
          ),
          const SizedBox(height: 10),
          Text(
            "(${correctLabels.length} images required)",
            style: TextStyle(color: thirdColor, fontSize: 13),
          ),
          const SizedBox(height: 70),

         Wrap(
  spacing: 10,
  runSpacing: 10,
  children: List.generate(images.length, (index) {
    final img = images[index];
    final isSelected = selectedIndexes.contains(index);

    return InkWell(
      onTap: () => checkSelection(index, img['label']!),
      child: Container(
        width: 80,
        height: 100,
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),

          border: Border.all(
            color: isSelected ? primaryColor : Colors.brown.shade200,
            width: isSelected ? 3 : 1.5,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Opacity(
          opacity: isSelected ? 0.4 : 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              img['path']!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }),
),

        ],
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
