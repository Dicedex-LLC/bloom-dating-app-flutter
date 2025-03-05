import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart';
import 'package:bloom_app/services/auth_service.dart'; // Import AuthService

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService(); // Instantiate AuthService

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloom - Home'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton( // Sign out button in AppBar
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out', // Tooltip for accessibility
            onPressed: () async {
              // Show confirmation dialog before signing out (optional but good UX)
              bool confirmSignOut = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false), // Dismiss dialog, return false
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),  // Dismiss dialog, return true
                        child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              ) ?? false; // If dialog is dismissed without selection, default to false

              if (confirmSignOut) {
                await _authService.signOut(); // Call AuthService sign out
                // After signOut, AuthGate in main.dart will automatically redirect to LoginScreen
              }
            },
          ),
        ],
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
