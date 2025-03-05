import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloom_app/models/profile.dart'; // Import the Profile model

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String profilesCollectionName = 'profiles'; // Collection name for user profiles

  // Function to create a new user profile in Firestore
  Future<void> createUserProfile(Profile profile) async {
    try {
      // Set the document ID to be the userId for easy retrieval
      await _firestore
          .collection(profilesCollectionName)
          .doc(profile.userId)
          .set(profile.toMap()); // Convert Profile object to Map before saving
      print('Profile created successfully for user: ${profile.userId}');
    } catch (e) {
      print('Error creating user profile in Firestore: $e');
      // You might want to handle errors more gracefully, e.g., throw exception or return error status
      rethrow; // For now, re-throwing the error to be handled by the caller
    }
  }

  // Function to get a user profile from Firestore by userId
  Future<Profile?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(profilesCollectionName)
          .doc(userId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        // Document exists and has data
        return Profile.fromMap(snapshot.data()!, userId); // Use factory constructor to create Profile from Map
      } else {
        // Document does not exist
        print('Profile not found for userId: $userId');
        return null; // Return null if profile not found
      }
    } catch (e) {
      print('Error fetching user profile from Firestore: $e');
      return null; // Return null in case of error
    }
  }

  // Function to get a list of profiles for swiping (excluding current user and liked/disliked profiles)
  // (This is a simplified version for demonstration - more complex filtering will be needed in a real app)
  Future<List<Profile>> getProfilesForSwiping() async {
    List<Profile> profiles = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(profilesCollectionName)
          .get(); // Fetch all documents in 'profiles' collection for now

      for (var docSnapshot in querySnapshot.docs) {
        Profile profile = Profile.fromMap(docSnapshot.data(), docSnapshot.id); // Create Profile from each document
        profiles.add(profile);
      }
      return profiles;
    } catch (e) {
      print('Error fetching profiles for swiping from Firestore: $e');
      return []; // Return empty list in case of error
    }
  }

  // You can add more Firestore interaction functions here as needed,
  // like functions to update profile, handle likes/dislikes, matches, etc.
}
