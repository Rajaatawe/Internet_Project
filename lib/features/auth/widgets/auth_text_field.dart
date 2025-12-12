import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final String hintText;
  final IconData? icon;
  final bool showLabel;
  final bool filled;
  final Color? fillColor;
  final double borderWidth;
  final int maxLines;
  final bool readOnly;
  final void Function()? ontap;
 ValueChanged<String>? onChanged;
  AuthTextField({
    super.key,
    required this.textEditingController,
    required this.obscureText,
    required this.keyboardType,
    required this.validator,
    required this.hintText,
    this.icon,
    required this.showLabel,
    this.filled = true,
    this.readOnly = false,
    this.fillColor,
    this.borderWidth = 1.0,
    this.maxLines = 1,  this.ontap, this.onChanged,
  });
  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        style: TextStyle(color: thirdColor),
        cursorErrorColor: primaryColor,
        readOnly: widget.readOnly,
        controller: widget.textEditingController,
        obscureText: widget.keyboardType == TextInputType.visiblePassword
            ? _obscure
            : false,
        cursorColor: primaryColor,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
onTap: widget.ontap ?? null,
onChanged: widget.onChanged,
        decoration: InputDecoration(
          floatingLabelBehavior: widget.showLabel
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 12.0,
          ),
          focusedBorder: buildBorder(primaryColor),
          enabledBorder: buildBorder(primaryColor),
          errorBorder: buildBorder(Colors.red),
          focusedErrorBorder: buildBorder(Colors.red),
          labelText: widget.showLabel ? widget.hintText : null,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: secondColor),
          labelStyle: TextStyle(color: primaryColor),
          suffixIconColor: primaryColor,

          suffixIcon: widget.keyboardType == TextInputType.visiblePassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                  icon: Icon(
                    _obscure ? Icons.lock : Icons.lock_open,
                    size: 30,
                    color: primaryColor,
                  ),
                )
              : (widget.icon != null
                    ? Icon(widget.icon, size: 30)
                    : null),
          filled: widget.filled,
          fillColor: widget.fillColor ?? Colors.transparent,
        ),
        validator: widget.validator,
      ),
    );
  }

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(width: widget.borderWidth, color: color),
    );
  }
}
