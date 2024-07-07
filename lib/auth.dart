//import 'package:brain_tuomr/screens/home_screen.dart';
import 'package:brain_tuomr/screens/home_screen.dart';
import 'package:brain_tuomr/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
  
class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context,snapshot)
        {
          if(snapshot.hasData)
          {
            return const HomeScreen();
          }
          else{
            return const LoginScreen();
          }

        }),
      ),
    );
  }
}
