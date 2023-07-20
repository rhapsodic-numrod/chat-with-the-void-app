import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase_chat_app2/pages/auth_page.dart';
import 'package:test_firebase_chat_app2/pages/home_page.dart';
import 'package:test_firebase_chat_app2/utils/utils.dart';

class AuthSwitcher extends StatelessWidget {
  const AuthSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.emailVerified) {
              return const HomePage();
            } else {
              sendEmail(snapshot.data);
              return const EmailNotVerifiedPage();
            }
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }

  void sendEmail(User? user) async{
    await user?.sendEmailVerification();
  }
}

class EmailNotVerifiedPage extends StatelessWidget {
  const EmailNotVerifiedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              textAlign: TextAlign.center,
              "Email address has not been verified.\n Check your email to verify it",
              style: TextStyle(fontSize: 18),
            ),
            addHeight(20),
            ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text("GO BACK"),
            )
          ],
        ),
      ),
    );
  }
}
