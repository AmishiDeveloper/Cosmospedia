// FAQ data model
import 'package:flutter/material.dart';

class FaqCategory {
  final String title;
  final IconData icon;
  final List<FaqItem> items;

  FaqCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}


class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

List<FaqCategory> generateFaqCategories() {
  return [
    FaqCategory(
      title: 'General Questions',
      icon: Icons.help,
      items: [
        FaqItem(
          question: 'What is CosmosPedia?',
          answer: 'CosmosPedia is an educational mobile app that offers curated, real-time space-related information. Explore NASA\'s Astronomy Picture of the Day, asteroid data, live space weather updates and Space discoveries all over the world —all in one place.',
        ),
        FaqItem(
          question: 'Which platforms support CosmosPedia?',
          answer: 'CosmosPedia is available for download on both Android and iOS devices.',
        ),
        FaqItem(
          question: 'Is the app free to use?',
          answer: 'Absolutely! CosmosPedia is completely free to download and use.',
        ),
        FaqItem(
          question: 'Does CosmosPedia require an internet connection?',
          answer: 'Yes. Most features fetch live data from NASA and other APIs, so an active internet connection is required.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Features & Navigation',
      icon: Icons.explore,
      items: [
        FaqItem(
          question: 'What features are available in CosmosPedia?',
          answer: 'CosmosPedia includes the following key modules:\n\n'
              '• User Authentication – Secure access to app'
              '• Astronomy Picture of the Day (APOD) – Enjoy NASA\'s featured space images.'
              '• Asteroid Tracker – Explore real-time data on near-Earth objects (NEOs).\n'
              '• Space Discoveries – Real-time updates about space discoveries all over the world.\n'
              '• Space Weather Dashboard – Monitor solar activity like flares and storms.\n'
              '• My Profile – Manages user account.\n',
        ),
        FaqItem(
          question: 'How do I navigate between different sections of the app?',
          answer: 'Use the bottom navigation bar to quickly access:\n\n'
              '• Home – Features Cosmos images\n'
              '• Space Discoveries\n'
              '• Asteroid Tracker\n'
              '• Space Weather\n'
              '• My Profile',
        ),
        FaqItem(
          question: 'Can I know about latest news, events, launches and missions going in space',
          answer: 'Yes. Easily:\n\n'
              '• Navigate to space news section then choose the category for which you want latest updates about.\n'
              '• Filter photos by camera type (e.g., Mastcam, Navcam)',
        ),
        FaqItem(
          question: 'How do I access detailed asteroid information?',
          answer: 'Tap on any asteroid to view:\n\n'
              '• Orbit diagrams\n'
              '• Size comparisons\n'
              '• Relative Velocity comparisons\n'
              '• Historical and upcoming close approaches',
        ),
      ],
    ),
    FaqCategory(
      title: 'Account & User Data',
      icon: Icons.account_circle,
      items: [
        FaqItem(
          question: 'Do I need an account to use the app?',
          answer: 'Yes account is required for general use.',
        ),
        FaqItem(
          question: 'How do I create or sign in to an account?',
          answer: 'Go to the Sign In screen and enter your credentials. New users can tap "Don\'t have an account? Sign Up" to register.',
        ),
        FaqItem(
          question: 'Is my personal data secure?',
          answer: 'Yes. CosmosPedia uses Firebase Authentication to ensure secure sign-in and safe storage of your preferences.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Troubleshooting',
      icon: Icons.build,
      items: [
        FaqItem(
          question: 'Why are images not loading properly?',
          answer: 'Make sure you have a stable internet connection.',
        ),
        FaqItem(
          question: 'The app crashes in a specific section—what should I do?',
          answer: 'Click on Try Again Button. If still not works then restart the application. Ensure you\'re using the latest version from the app store. Still having trouble? Reach out via the Help & Support section.',
        ),
        FaqItem(
          question: 'How can I report a bug or suggest a feature?',
          answer: 'Navigate to the Help & Support section from the app menu to submit your feedback or report an issue.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Space Data & Sources',
      icon: Icons.public,
      items: [
        FaqItem(
          question: 'Where does CosmosPedia get its space data from?',
          answer: 'We integrate real-time data through various NASA public APIs,and API from other space agencies including:\n\n'
              '• Astronomy Picture of the Day (APOD)\n'
              '• Spaceflight and Launch Library 2 APIS \n'
              '• Near-Earth Object Web Service (NeoWs)\n'
              '• DONKI (Space Weather) API',
        ),
        FaqItem(
          question: 'How frequently is the content updated?',
          answer: '• APOD: Updated daily\n'
              '• Space Discoveries: Updated daily\n'
              '• Asteroid & Space Weather Data: Pulled in real-time upon accessing those sections',
        ),
        // FaqItem(
        //   question: 'Can I download images for offline viewing?',
        //   answer: 'Yes! Tap the download icon while previewing any image to save it directly to your device.',
        // ),
      ],
    ),
    FaqCategory(
      title: 'Customization & Settings',
      icon: Icons.settings,
      items: [
        FaqItem(
          question: 'Can I change the app theme?',
          answer: 'No. CosmosPedia doesn\'t support a theme. It uses a common theme for both light and dark theme',
        ),
        FaqItem(
          question: 'Can I change the language of the app?',
          answer: 'Currently, CosmosPedia is available in English, with support for more languages planned in upcoming releases.',
        ),
        FaqItem(
          question: 'Can I customize the layout of the Home screen?',
          answer: 'Not at the moment, but we\'re exploring customization options for future updates.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Upcoming Features & Roadmap',
      icon: Icons.update,
      items: [
        // FaqItem(
        //   question: 'Will more rover data (e.g., Perseverance) be added?',
        //   answer: 'Yes! Future versions of CosmosPedia will include imagery and data from the Perseverance rover and additional missions.',
        // ),
        FaqItem(
          question: 'Are there plans for a web or desktop version?',
          answer: 'A desktop or web-based version is not currently available, but may be developed based on user interest.',
        ),
        FaqItem(
          question: 'Will I receive notifications about asteroid flybys or events?',
          answer: 'Yes! A notification system for near-Earth object alerts and astronomical events is currently under development.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Need Additional Help?',
      icon: Icons.support_agent,
      items: [
        FaqItem(
          question: 'How can I contact support?',
          answer: 'For further assistance, feedback, or support, feel free to reach out:\n\n'
              '• Email: support@cosmospedia.com\n'
              '• In-App: Navigate to Help & Support via the app\'s main menu',
        ),
      ],
    ),
  ];
}