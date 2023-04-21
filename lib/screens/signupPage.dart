import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaza_app/utils/generiSnackbar.dart';

import 'package:provider/provider.dart';

import 'package:validators/validators.dart';
import '../models/custom_error.dart';
import '../providers/Signup/Signup_provider.dart';
import '../providers/Signup/Signup_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static const String routeName = '/Signup';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _name, _email, _password;

  final _passwordController = TextEditingController();

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
      // Navigator.pushNamed(context, VerifiyEmailPage.routeName);
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('name: $_name,email: $_email, password: $_password');

    try {
      await context
          .read<SignupProvider>()
          .Signup(name: _name!, email: _email!, password: _password!);
    } on CustomError catch (e) {
      // errorDialog(context, e);

      if (e.code == 'email-already-in-use') {
        GenericSnackbar(context, "Email already registered");
      } else if (e.code == 'weak-password') {
        GenericSnackbar(context, "Weak Password");
      } else if (e.code == 'network-request-failed') {
        GenericSnackbar(context, "Network Error");
      } else if (e.code == 'operation-not-allowed') {
        GenericSnackbar(context, "This Operation Couldn't be performed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SignupState = Provider.of<SignupProvider>(context).state;

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
                  Hero(
                    tag: 'kazalogo',
                    child: Image.asset(
                      'lib/assets/images/kaza-logo.png',
                      width: 250,
                      height: 250,
                      color: Colors.orange,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Register Now',
                      style: GoogleFonts.poppins(
                        color: Colors.orange,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.account_box),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name Must be atleast 2 Characters Long';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _name = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
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
                    controller: _passwordController,
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
                  const SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (String? value) {
                      if (_passwordController.text != value) {
                        return 'Password Not Matched';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                        SignupState.signupStatus == SignupStatus.submitting
                            ? 'Loading...'
                            : 'Sign Up'),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed:
                        SignupState.signupStatus == SignupStatus.submitting
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                    child: const Text('Already a Member? Sign in!'),
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
