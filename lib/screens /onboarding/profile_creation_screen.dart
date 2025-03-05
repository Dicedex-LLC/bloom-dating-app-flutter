import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart';
import 'package:bloom_app/constants/app_strings.dart';
import 'package:bloom_app/constants/app_styles.dart';
import 'package:bloom_app/components/custom_button.dart';
import 'package:bloom_app/services/database_service.dart'; // Import DatabaseService
import 'package:bloom_app/models/profile.dart';         // Import Profile model
import 'package:firebase_auth/firebase_auth.dart';       // Import FirebaseAuth for current user
import 'package:bloom_app/screens/home/home_screen.dart';   // Navigation to HomeScreen

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  ProfileCreationScreenState createState() => ProfileCreationScreenState();
}

class ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _gender = 'Male'; // Default gender selection
  bool _isLoading = false;

  final DatabaseService _databaseService = DatabaseService(); // Instantiate DatabaseService

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          Profile profile = Profile(
            userId: currentUser.uid, // Use current user's UID
            name: _nameController.text.trim(),
            age: int.parse(_ageController.text.trim()), // Parse age as integer
            bio: _bioController.text.trim(),
            imageUrls: [], // Initially empty image URLs - we'll add image upload later
            gender: _gender,
            location: null, // Location can be added later
            interests: null, // Interests can be added later
          );

          await _databaseService.createUserProfile(profile); // Save profile to Firestore

          setState(() {
            _isLoading = false;
          });

          print('Profile created successfully for user: ${currentUser.uid}');
          // Navigate to Home Screen after successful profile creation
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          _showSnackBar('No user logged in. Please sign in first.', Colors.redAccent);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Error creating profile. Please try again.', Colors.redAccent);
        print('Error creating profile: $e'); // Log detailed error
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 32.0),

                Text(
                  AppStrings.profileCreationTitle, // "Tell us about yourself"
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary,
                  ),
                ),
                const SizedBox(height: 24.0),

                // Name Text Field
                TextFormField(
                  controller: _nameController,
                  decoration: customInputDecoration(labelText: 'Your Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Age Text Field
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration(labelText: 'Your Age'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number for age';
                    }
                    int age = int.parse(value);
                    if (age < 18 || age > 120) {
                      return 'Age must be between 18 and 120';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Bio Text Field
                TextFormField(
                  controller: _bioController,
                  maxLines: 3, // Allow multiple lines for bio
                  decoration: customInputDecoration(labelText: 'Your Bio (Short description)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a short bio';
                    }
                    if (value.length > 500) {
                      return 'Bio must be less than 500 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _gender, // Current selected gender
                  decoration: customInputDecoration(labelText: 'Gender'),
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                  validator: (value) => value == null ? 'Please select your gender' : null,
                ),
                const SizedBox(height: 32.0),

                // Create Profile Button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: _createProfile,
                        text: 'Create Profile',
                      ),

                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
