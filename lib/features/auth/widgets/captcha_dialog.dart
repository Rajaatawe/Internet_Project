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

    // Pick a label that appears more than once (cat or dog)
    List<String> possible = ['cat', 'dog'];
    targetLabel = possible[Random().nextInt(possible.length)];

    // Correct labels = all matching images
    correctLabels = images
        .where((img) => img['label'] == targetLabel)
        .map((e) => e['label']!)
        .toList();

    selectedLabels = [];
  }

  void checkSelection(String label) {
    selectedLabels.add(label);

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

    // If user selected all required correct images
    if (selectedLabels.length == correctLabels.length) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: whiteBrown,
      title: const Text(
        "Verify You Are Human",
        style:  TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Select all images containing a: ${targetLabel.toUpperCase()}",
            style: const TextStyle(
              color: primaryColor,
            ),
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
            children: images.map((img) {
              return InkWell(
                onTap: () => checkSelection(img['label']!),
                child: Image.asset(img['path']!, width: 80, height: 80),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: const TextStyle(fontWeight: FontWeight.bold, color: darkBrown),),
          ),
        ),
      ],
    );
  }
}
