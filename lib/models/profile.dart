class Profile {
  String userId;        // Firebase User ID - to link with Firebase Auth user
  String name;
  int age;
  String bio;
  List<String> imageUrls; // List of profile image URLs
  String gender;         // e.g., "Male", "Female", "Other"
  String? location;      // Optional location (e.g., city, country)
  List<String>? interests; // Optional list of interests/hobbies

  Profile({
    required this.userId,
    required this.name,
    required this.age,
    required this.bio,
    required this.imageUrls,
    required this.gender,
    this.location,
    this.interests,
  });

  // Factory method to create a Profile object from a map (e.g., from Firestore document)
  factory Profile.fromMap(Map<String, dynamic> map, String userId) {
    return Profile(
      userId: userId, // Pass the document ID as userId
      name: map['name'] ?? '', // Use '' as default if name is null in Firestore
      age: map['age']?.toInt() ?? 18, // Default age to 18 if null or not convertible to int
      bio: map['bio'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []), // Ensure imageUrls is a List<String>, default to empty list
      gender: map['gender'] ?? '',
      location: map['location'],
      interests: map['interests'] != null ? List<String>.from(map['interests']) : null, // Handle potential null interests
    );
  }

  // Method to convert a Profile object to a map (e.g., to save to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'bio': bio,
      'imageUrls': imageUrls,
      'gender': gender,
      'location': location,
      'interests': interests,
    };
  }
}
