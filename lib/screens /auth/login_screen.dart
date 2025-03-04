
import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart';
import 'package:bloom_app/constants/app_strings.dart';
import 'package:bloom_app/components/custom_button.dart'; // Example custom button component (we might create this later)
import 'package:bloom_app/screens/auth/signup_screen.dart'; // Example: Navigation to SignupScreen (create later)
import 'package:bloom_app/screens/home/home_screen.dart'; // Example: Navigation to HomeScreen after successful login
import 'package:bloom_app/constants/app_styles.dart'; // Import app_styles
import 'package:bloom_app/services/auth_service.dart'; // Import AuthService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final AuthService _authService = AuthService(); // Instantiate AuthService
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // For toggling password visibility
  bool _isLoading = false;      // To show loading indicator during login process

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle login process using Firebase Auth
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Call AuthService to sign in with email and password
      User? user = await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(), // Trim whitespace from email
        _passwordController.text.trim(), // Trim whitespace from password
      );

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        // Sign in successful
        print('Login successful. User UID: ${user.uid}');
        // Navigate to Home Screen after successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with actual HomeScreen
        );
      } else {
        // Sign in failed (error handled in AuthService and printed to console)
        // You can show an error message to the user here (we'll add error display improvements later)
        print('Login failed.'); // For now, just print to console
        // Optionally, display a SnackBar or AlertDialog to inform user of login failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials and try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // ... rest of the LoginScreenState code (build method, etc.)
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Background color from constants
      body: Center(
        child: SingleChildScrollView( // Make screen scrollable if content overflows (e.g., keyboard)
          padding: const EdgeInsets.symmetric(horizontal: 24.0), // Horizontal padding
          child: Form(
            key: _formKey, // Assign form key for validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children across width
              children: <Widget>[
                // App Logo (you can reuse the logo from SplashScreen or a smaller version)
                Image.asset(
                  'assets/images/bloom_logo.png', // Path to your logo asset
                  height: 80, // Adjust logo size for login screen
                ),
                const SizedBox(height: 48.0),

                // Welcome Text
                Text(
                  AppStrings.loginTitle, // "Welcome Back!" from constants
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary, // Primary text color from constants
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)), // Rounded border
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Basic email validation (you can use more robust validation if needed)
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
                  obscureText: _obscurePassword, // Toggle password visibility
                  decoration: customInputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton( // Icon button to toggle password visibility
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)), // Rounded border
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Add more password validation rules here if needed (e.g., minimum length)
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),

                // Login Button
                _isLoading // Show loading indicator if _isLoading is true
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton( // Or use your CustomButton component here for styling consistency
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor, // Primary color from constants
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Rounded button
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                const SizedBox(height: 24.0),

                // Don't have an account? Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.textColorSecondary), // Secondary text color from constants
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Signup Screen (replace with actual SignupScreen navigation)
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const SignupScreen()), // Replace with actual SignupScreen
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: AppColors.primaryColor, // Primary color for interactive text
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
