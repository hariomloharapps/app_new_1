// lib/main.dart
import 'package:flutter/material.dart';
import 'package:gyrogame/util.dart';
import 'Onboarding/CompanionSetupScreen.dart';
import 'Onboarding/PersonalityTypeScreen.dart';
import 'Onboarding/RelationshipTypeScreen.dart';
import 'Onboarding/gender_selection_screen.dart';
import 'Onboarding/mainscreen.dart';
import 'Onboarding/name_input_screen.dart';
import 'Onboarding/verification/AdultVerificationScreen.dart';
import 'Onboarding/verification/VerifyPhotoScreen.dart';
import 'screens/chat_screen.dart';
import 'theme.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Aboreto", "Abhaya Libre");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme:brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const OnboardingScreen(),
      // Define your routes
      routes: {
        '/gender': (context) => const GenderTraitsScreen(),
        '/name': (context) => const NameInputScreen(),
        '/rela': (context) => const RelationshipTypeScreen(),
        '/PersonalityTypeScreen': (context) => const PersonalityTypeScreen(),
        '/verify-photo': (context) => const VerifyPhotoScreen(),
        '/adult-verification': (context) => const AdultVerificationScreen(),
        '/chat': (context) =>  ChatScreen(),
        // Add your chat screen route here
        // '/chat': (context) => const ChatScreen(),
      },
    );
  }
}



