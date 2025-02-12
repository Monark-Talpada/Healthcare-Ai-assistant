import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screen/home_screen.dart';
import 'screen/patient_history_screen.dart';
import 'screen/chatbot_screen.dart';
import 'screen/login_screen.dart';
import 'screen/forget_password_screen.dart';
import 'screen/signup_screen.dart';
import 'screen/medicine_tracking_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()), // Added Provider for authentication
      ],
      child: const DoctApp(),
    ),
  );
}

class DoctApp extends StatelessWidget {
  const DoctApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DoctApp',
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/patient-history': (context) => const PatientHistoryScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/medicine-tracking': (context) => const MedicineTrackingScreen(), 
},
    );
  }
}
