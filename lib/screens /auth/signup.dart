import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text(
          'Sign Up Screen - In Progress',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
