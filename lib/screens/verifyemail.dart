import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaza_app/screens/homeScreen.dart';

class VerifiyEmailPage extends StatefulWidget {
  const VerifiyEmailPage({super.key});
  static const String routeName = '/verifyEmail';

  @override
  State<VerifiyEmailPage> createState() => _VerifiyEmailPageState();
}

class _VerifiyEmailPageState extends State<VerifiyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 5),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) timer.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });

      await Future.delayed(Duration(seconds: 5));

      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? HomeScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text("Verify Email"),
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "A Verification email has been sent to the user",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton.icon(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    icon: const Icon(
                      Icons.email,
                      size: 32,
                    ),
                    label: const Text(
                      "Resent Email",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text("Cancel"))
                ],
              ),
            ),
          );
  }
}
