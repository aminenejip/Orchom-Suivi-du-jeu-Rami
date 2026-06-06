import 'package:flutter/material.dart';

class OrchomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final int? maxLines;

  const OrchomTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
