import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/features/auth/widgets/auth_text_field.dart';

class TextFieldComponent extends StatefulWidget {
  const TextFieldComponent({
    super.key,
    required this.textEditingController,
    required this.obscureText,
    required this.keyboardType,
    required this.validator,
    required this.hintText,
    this.icon,
    required this.showLabel,
    required this.filled,
     this.fillColor,
     this.borderWidth,
    required this.maxLines,
     this.readOnly,
    required this.withText,
     this.title, this.ontap, this.onChanged,
  });
  final TextEditingController textEditingController;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final String hintText;
  final IconData? icon;
  final bool showLabel;
  final bool filled;
  final Color? fillColor;
  final double? borderWidth;
  final int maxLines;
  final bool? readOnly;
  final bool withText;
  final String? title;
  final void Function()? ontap;
  final ValueChanged<String>? onChanged;
  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.withText
            ? Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  widget.title ?? '`',
                  style: TextStyle(
                    color: widget.title != null ? primaryColor : Colors.transparent ,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : SizedBox(height: 0.01),
        SizedBox(height: 5),
        AuthTextField(
          hintText: widget.hintText,
          icon: widget.icon,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          textEditingController: widget.textEditingController,
          validator: widget.validator,
          obscureText: widget.obscureText,
          showLabel: widget.showLabel,
          ontap: widget.ontap ?? null,
          readOnly: widget.readOnly ?? false,
          onChanged: widget.onChanged ?? null,
        ),
      ],
    );
  }
}
