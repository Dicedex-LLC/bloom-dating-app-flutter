import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the User object on successful signup
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors (e.g., weak-password, email-already-in-use)
      print("Firebase Auth Signup Error: ${e.code} - ${e.message}");
      return null; // Return null if signup fails
    } catch (e) {
      // Handle other potential errors
      print("Generic Signup Error: $e");
      return null; // Return null if signup fails
    }
  }

  // Sign in with email and password (we'll implement this later)
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return User object on successful login
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Signin Error: ${e.code} - ${e.message}");
      return null; // Return null if signin fails
    } catch (e) {
      print("Generic Signin Error: $e");
      return null; // Return null if signin fails
    }
  }

  // Get current user (we'll implement this later if needed)
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign out (we can implement this later)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
