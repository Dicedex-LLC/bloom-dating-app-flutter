import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart';
import 'package:bloom_app/constants/app_strings.dart';
import 'package:bloom_app/screens/auth/login_screen.dart'; // Navigation to LoginScreen
import 'package:bloom_app/screens/home/home_screen.dart'; // Example: Navigation to HomeScreen after successful signup
import 'package:bloom_app/constants/app_styles.dart'; // Import app_styles
import 'package:bloom_app/services/auth_service.dart'; // Import AuthService

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); // Instantiate AuthService
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;         // Toggle password visibility for password field
  bool _obscureConfirmPassword = true;  // Toggle password visibility for confirm password field
  bool _isLoading = false;             // To show loading indicator during signup

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  import 'package:flutter/material.dart';
// ... other imports
import 'package:bloom_app/services/auth_service.dart'; // Import AuthService

class SignupScreenState extends State<SignupScreen> {
  // ... form keys, controllers, etc.

  final AuthService _authService = AuthService(); // Instantiate AuthService

  // Function to handle signup process using Firebase Auth
  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Call AuthService to signup with email and password
      User? user = await _authService.signUpWithEmailAndPassword(
        _emailController.text.trim(), // Trim whitespace from email
        _passwordController.text.trim(), // Trim whitespace from password
      );

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        // Signup successful
        print('Signup successful. User UID: ${user.uid}');
        // Navigate to Home Screen after successful signup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with actual HomeScreen
        );
      } else {
        // Signup failed (error handled in AuthService and printed to console)
        // You can show an error message to the user here (we'll add error display in next steps)
        print('Signup failed.'); // For now, just print to console
        // Optionally, display a SnackBar or AlertDialog to inform user of signup failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup failed. Please check your details and try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // ... rest of the SignupScreenState code (build method, etc.)
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // App Logo
                Image.asset(
                  'assets/images/bloom_logo.png',
                  height: 80,
                ),
                const SizedBox(height: 48.0),

                // Sign Up Title Text
                Text(
                  AppStrings.signupTitle, // "Create Account" from constants
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary,
                  ),
                ),
                const SizedBox(height: 32.0),

                // Email Text Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: customInputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Password Text Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: customInputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) { // Example: Minimum password length validation
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Confirm Password Text Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: customInputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),

                // Sign Up Button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                const SizedBox(height: 24.0),

                // Already have an account? Log In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: AppColors.textColorSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Login Screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
