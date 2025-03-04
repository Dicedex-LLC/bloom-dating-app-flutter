import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart'; // Import app colors

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed; // Function to execute when button is pressed
  final String text;             // Text to display on the button
  final Color? backgroundColor;   // Optional: Background color of the button (defaults to primary color)
  final Color? textColor;       // Optional: Text color of the button (defaults to white)
  final double? fontSize;        // Optional: Font size of the button text (defaults to 18.0)
  final EdgeInsetsGeometry? padding; // Optional: Button padding (defaults to vertical 14.0)
  final BorderRadius? borderRadius; // Optional: Button border radius (defaults to circular 12.0)

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primaryColor, // Use provided color or default primary color
        foregroundColor: textColor ?? Colors.white,             // Use provided color or default white
        padding: padding ?? const EdgeInsets.symmetric(vertical: 14.0), // Use provided padding or default
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12.0), // Use provided radius or default
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize ?? 18.0), // Use provided font size or default
      ),
    );
  }
}
