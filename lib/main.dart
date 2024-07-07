import 'package:brain_tuomr/firebase_options.dart';
import 'package:brain_tuomr/screens/home_screen.dart';
import 'package:brain_tuomr/screens/login_screen.dart';
import 'package:brain_tuomr/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';





void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brain Tuomr',
      theme: ThemeData(
        
        primarySwatch: Colors.blue
      ),
      //home: const Auth(),
      routes: {
        '/': (context)=> const Auth(),
        'homeScreen' : (context) => const HomeScreen(),
        'signupScreen': (context) => const SignupScreen(),
        'loginScreen' :(context) => const LoginScreen(),

      },
    );
  }
}
