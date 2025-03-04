import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // For animated text
import 'package:bloom_app/constants/app_colors.dart'; // Example constant colors
import 'package:bloom_app/constants/app_strings.dart'; // Example constant strings
import 'package:bloom_app/screens/auth/login_screen.dart'; // Example: Navigate to LoginScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Animation duration
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward(); // Start the logo animation

    // Delay navigation after splash duration
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to Login screen
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Example primary color from constants
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ScaleTransition(
              scale: _logoAnimation,
              child: Image.asset(
                'assets/images/bloom_logo.png', // Replace with your logo asset path
                height: 120, // Adjust logo size
              ),
            ),
            const SizedBox(height: 20),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  FlickerAnimatedText(AppStrings.appName), // Example app name string from constants
                  FlickerAnimatedText(AppStrings.appTagline), // Example tagline from constants
                ],
                isRepeatingAnimation: false,
