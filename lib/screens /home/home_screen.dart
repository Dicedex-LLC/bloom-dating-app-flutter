import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloom - Home'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text(
          'Welcome to Bloom Home!',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
