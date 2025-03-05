import 'package:flutter/material.dart';
import 'package:bloom_app/constants/app_colors.dart';
import 'package:bloom_app/services/auth_service.dart'; // Import AuthService
import 'package:flutter_tindercard/flutter_tindercard.dart'; // Import TinderSwapCard

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
  class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  List<String> dummyProfileImages = [ // Dummy image URLs - replace with actual profile image URLs later
    "https://images.unsplash.com/photo-1595152772835-219674b2a8a6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1539571696357-5a69c1736fec?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1580489944761-15a19d67b465?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1531427186511-ecfd6d936586?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjF8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjZ8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60",
  ];
  CardController cardController = CardController(); // Controller for TinderSwapCard

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloom - Home'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              bool confirmSignOut = await showDialog(/* ... confirmation dialog ... */) ?? false;
              if (confirmSignOut) {
                await _authService.signOut();
              }
            },
          ),
        ],
      ),
      body: Center( // Center the TinderSwapCard
        child: SizedBox( // Set size for the TinderSwapCard
          height: MediaQuery.of(context).size.height * 0.6, // 60% of screen height
          child: TinderSwapCard(
            maxWidth: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
            maxHeight: MediaQuery.of(context).size.height * 0.6, // 60% of screen height
            minWidth: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            minHeight: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
            totalNum: dummyProfileImages.length, // Number of cards
            stackNum: 3, // Cards to stack
            swipeEdge: 4.0,
            swipeOrientation: SwipeOrientation.HORIZONTAL,
            swipeCardBuilder: (context, index) => Card( // Build each card
              elevation: 4, // Card elevation for shadow effect
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), // Rounded card corners
              child: ClipRRect( // Clip image to rounded corners
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  dummyProfileImages[index], // Use dummy image URL
                  fit: BoxFit.cover, // Cover the card area
                ),
              ),
            ),
            cardController: cardController,
            swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
              /// Get swiping card's alignment
              if (align.alignment == SwipeItemAlignment.top) {
                // Card is swiping top
              } else if (align.alignment == SwipeItemAlignment.bottom) {
                // Card is swiping bottom
              } else if (align.alignment == SwipeItemAlignment.left) {
                //Card is swiping left
              } else if (align.alignment == SwipeItemAlignment.right) {
                //Card is swiping right
              }
            },
            swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
              /// Called when the card is swiped in any direction.
              if (orientation == CardSwipeOrientation.left) {
                print('Swiped left (dislike) on card index $index');
                // Handle dislike action (e.g., update data, move to next profile)
              } else if (orientation == CardSwipeOrientation.right) {
                print('Swiped right (like) on card index $index');
                // Handle like action (e.g., record like, check for match, move to next profile)
              }
            },
          ),
        ),
      ),
    );
  }
}
      ),
    );
  }
}
