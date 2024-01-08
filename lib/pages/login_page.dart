import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:careability/components/my_button.dart';
import 'package:careability/components/my_textfield.dart';
import 'package:careability/components/square_tile.dart';
import 'package:careability/services/auth_services.dart';
import 'package:provider/provider.dart';

import '../user_role.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  final String? userId;

  const LoginPage({super.key, this.userId});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthService authService;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool areTermsAccepted = false;

  void signUserIn() async {
    if (!mounted) return;

    final role = Provider.of<UserRole>(context, listen: false).role;
    final email = emailController.text;

    print('Role: $role');
    print('Email: $email');

    // Check if the user exists in the selected role collection
    bool userExists = await doesUserExistForRole(role, email);

    if (!userExists) {
      showErrorMessage('User with selected role does not exist');
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      if (!mounted) return;

      String userId = userCredential.user!.uid;

      navigateToHomePage(context, role, userId);
    } on FirebaseAuthException catch (e) {
      // If the Firebase sign-in fails, display the appropriate error message
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showErrorMessage('Invalid email or password');
      } else {
        showErrorMessage(e.code);
      }
    }
  }

  Future<bool> doesUserExistForRole(String role, String email) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(role) // Use the selected role to access the collection
          .doc(email) // Assume document ID is the email address
          .get();

      return userDoc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<String?> fetchTermsAndConditions() async {
    try {
      DocumentSnapshot termsSnapshot = await FirebaseFirestore.instance
          .collection('terms_and_conditions')
          .doc('terms')
          .get();

      String? termsText = termsSnapshot['text'];
      return termsText;
    } catch (e) {
      print('Error fetching terms and conditions: $e');
      return null;
    }
  }

  void _showTermsAndConditionsDialog() {
    fetchTermsAndConditions().then((termsText) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Terms and Conditions'),
            content: SingleChildScrollView(
              child: Text(
                termsText ?? 'Failed to retrieve terms.',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    });
  }

  void navigateToHomePage(BuildContext context, String role, String userId) {
    print('Selected Role: $role');
    if (role == 'teacher' || role == 'parent') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userRole: role, userId: userId),
        ),
      );
    } else {
      showErrorMessage('Invalid role selected');
    }
  }

  //error message wrong credentials
  void showErrorMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              errorMessage,
            ),
          ),
        );
      },
    );
  }

  void forgotPassword() async {
    String email = emailController.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Provide feedback to the user that the reset email has been sent
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text('A password reset email has been sent to $email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Failed to send password reset email. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity, // Expand to full height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.orange[100]!, Colors.orange[700]!],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // logo
                  Image.asset(
                    'lib/images/logo.png',
                    height: 150,
                  ),

                  const SizedBox(height: 30),

                  // welcome back, you've been missed!
                  Text(
                    'Please choose your ROLE',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),

                  //radio button for teacher and parent

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //teacher radio button
                      Radio<String>(
                        value: 'teacher',
                        groupValue: Provider.of<UserRole>(context).role,
                        onChanged: (value) {
                          setState(() {
                            Provider.of<UserRole>(context, listen: false)
                                .setRole(value!);
                            print('Role: $value');
                          });
                        },
                      ),
                      const Text('Teacher'),
                      //parent radio button
                      Radio<String>(
                        value: 'parent',
                        groupValue: Provider.of<UserRole>(context).role,
                        onChanged: (value) {
                          setState(() {
                            Provider.of<UserRole>(context, listen: false)
                                .setRole(value!);
                            print('Role: $value');
                          });
                        },
                      ),
                      const Text('Parent'),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: forgotPassword,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // sign in button
                  MyButton(
                    onTap: areTermsAccepted ? signUserIn : null,
                    buttonText: "Log in",
                  ),
                  // Checkbox for terms and conditions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: areTermsAccepted,
                        onChanged: (value) {
                          setState(() {
                            areTermsAccepted = value ?? false;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          _showTermsAndConditionsDialog();
                        },
                        child: Text(
                          'I agree to the terms and conditions',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or Sign In With',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // google sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google button
                      SquareTile(
                        onTap: areTermsAccepted
                            ? () {
                                final authService = AuthService();
                                final role = Provider.of<UserRole>(context,
                                        listen: false)
                                    .role;

                                if (role != null) {
                                  authService.signInWithGoogle(role);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Role Not Selected'),
                                        content: const Text(
                                          'Please select a role (parent or teacher) before signing up with Google.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            : null,
                        imagePath: 'lib/images/google.png',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
