import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart';
import 'package:bloom_app/constants/app_strings.dart';
import 'package:bloom_app/constants/app_styles.dart';
import 'package:bloom_app/components/custom_button.dart';
import 'package:bloom_app/services/database_service.dart'; // Import DatabaseService
import 'package:bloom_app/models/profile.dart';         // Import Profile model
import 'package:firebase_auth/firebase_auth.dart';       // Import FirebaseAuth for current user
import 'package:bloom_app/screens/home/home_screen.dart';   // Navigation to HomeScreen
import 'package:image_picker/image_picker.dart'; // Import image_picker

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

  List<File> _profileImages = []; // List to store selected image files
  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImages.add(File(pickedFile.path)); // Add selected File to the list
      });
    }
  }

  // Function to pick image from camera (optional for now, can add later)
  // Future<void> _pickImageFromCamera() async { ... }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (AppBar, backgroundColor, body - same as before) ...
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // ... (Title Text, Name, Age, Bio, Gender fields - same as before) ...

                const SizedBox(height: 24.0),

                // Profile Image Section
                Text(
                  'Add Profile Pictures (Optional)', // Make image upload optional initially
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary,
                  ),
                ),
                const SizedBox(height: 12.0),

                // Image Preview Area (Horizontal ListView)
                SizedBox(
                  height: 100.0, // Fixed height for image preview
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _profileImages.length + 1, // +1 for the "Add Image" button
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // "Add Image" button
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: _pickImageFromGallery, // Call gallery picker
                            child: Container(
                              width: 100.0,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: const Icon(Icons.add_photo_alternate, size: 40.0, color: Colors.grey),
                            ),
                          ),
                        );
                      } else {
                        // Image Preview
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              _profileImages[index - 1], // Access image from _profileImages list
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 32.0),

                // Create Profile Button (same as before)
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
          List<String> imageUrls = []; // Initialize imageUrls list

          if (_profileImages.isNotEmpty) { // Only upload images if there are any selected
            imageUrls = await _databaseService.uploadProfileImages(_profileImages, currentUser.uid); // Upload images to Storage
          }

          Profile profile = Profile(
            userId: currentUser.uid,
            name: _nameController.text.trim(),
            age: int.parse(_ageController.text.trim()),
            bio: _bioController.text.trim(),
            imageUrls: imageUrls, // Use the download URLs obtained from Storage
            gender: _gender,
            location: null,
            interests: null,
          );

          await _databaseService.createUserProfile(profile);

          setState(() {
            _isLoading = false;
          });

          print('Profile created successfully with images. User UID: ${currentUser.uid}');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // ... (No user logged in SnackBar) ...
        }
      } catch (e) {
        // ... (Error SnackBar and error logging) ...
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
