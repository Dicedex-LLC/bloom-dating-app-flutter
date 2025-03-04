import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:bloom_app/screens/splash_screen.dart'; // Import SplashScreen
import 'package:bloom_app/screens/auth/login_screen.dart'; // Import LoginScreen
import 'package:bloom_app/screens/home/home_screen.dart';   // Import HomeScreen
import 'package:firebase_auth/firebase_auth.dart';       // Import FirebaseAuth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom Dating App',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Or use your custom theme in theme/ folder
        fontFamily: 'Roboto', // Example font family, add fonts to assets/fonts/
      ),
      home: const SplashScreen(), // Set SplashScreen as the home screen
    );
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom Dating App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Roboto',
      ),
      home: const AuthGate(), // Use AuthGate as the home widget
    );
  }
}

// AuthGate Widget - Decides whether to show LoginScreen or HomeScreen based on auth state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show SplashScreen or loading indicator while checking auth state
          return const SplashScreen(); // Or a loading indicator if you prefer
        }

        if (snapshot.hasData) {
          // User is signed in
          return const HomeScreen();
        }

        // User is not signed in
        return const LoginScreen();
      },
    );
  }
}
// ... (MyHomePage and _MyHomePageState removed - no longer needed for initial setup)
