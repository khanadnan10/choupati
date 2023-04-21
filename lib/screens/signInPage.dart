import 'package:flutter/material.dart';
import 'package:kaza_app/utils/generiSnackbar.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import '../models/custom_error.dart';
import '../providers/signin/signin_provider.dart';
import '../providers/signin/signin_state.dart';

import 'forgotpage.dart';
import 'signupPage.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);
  static const String routeName = '/signin';

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('email: $_email, password: $_password');

    try {
      await context
          .read<SigninProvider>()
          .signin(email: _email!, password: _password!);
    } on CustomError catch (e) {
      if (e.code == 'wrong-password') {
        GenericSnackbar.show(context, "Your password is wrong.");
      } else if (e.code == 'user-not-found') {
        GenericSnackbar.show(context, "User with this email doesn't exist.");
      } else if (e.code == 'network-request-failed') {
        GenericSnackbar.show(context, "Too many requests. Try again later.");
        print(e);
      }
      // errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signinState = Provider.of<SigninProvider>(context).state;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 70.0,
                  ),
                  // Hero(
                  //   tag: 'kazalogo',
                  //   child: Image.asset(
                  //     'lib/assets/images/kaza-logo.png',
                  //     height: 150,
                  //     color: Colors.orange,
                  //   ),
                  // ),
                  const Align(
                      alignment: Alignment.center,
                      child: Text('Enhancing street food experience')),
                  const SizedBox(
                    height: 70.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email required';
                      }
                      if (!isEmail(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _email = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _password = value;
                    },
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, ForgotPage.routeName, (route) => false);
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child:
                          !(signinState.signinStatus == SigninStatus.submitting)
                              ? const Text('Sign In')
                              : const CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed: signinState.signinStatus ==
                            SigninStatus.submitting
                        ? null
                        : () {
                            Navigator.pushNamed(context, SignupPage.routeName);
                          },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: ' Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
