import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required String labelText,
  IconData? prefixIcon,
}) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.grey), // Optional: Customize border color
    ),
    focusedBorder: OutlineInputBorder( // Style when the input field is focused
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.blue), // Optional: Customize focused border color
    ),
    errorBorder: OutlineInputBorder( // Style when there is a validation error
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.red), // Optional: Customize error border color
    ),
    focusedErrorBorder: OutlineInputBorder( // Style when focused and has error
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.redAccent), // Optional: Customize focused error border color
    ),
    // You can add more default styling here if needed, like labelStyle, contentPadding, etc.
  );
}
