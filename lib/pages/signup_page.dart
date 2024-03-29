import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:careability/components/my_button.dart';
import 'package:careability/components/my_textfield.dart';
import 'package:provider/provider.dart';

import '../components/square_tile.dart';
import '../services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user_role.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late AuthService authService;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final advisoryController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();

  bool areTermsAccepted = false;

  // sign user in method
  void signUserUp() async {
    final role = Provider.of<UserRole>(context, listen: false).role;

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (role == 'teacher') {
          await FirebaseFirestore.instance
              .collection('teacher')
              .doc(emailController.text)
              .set({
            'email': emailController.text,
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'advisory': advisoryController.text,
            'address': firstNameController.text,
            'contact': lastNameController.text,
          });
        } else if (role == 'parent') {
          await FirebaseFirestore.instance
              .collection('parent')
              .doc(emailController.text)
              .set({
            'email': emailController.text,
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'address': firstNameController.text,
            'contact': lastNameController.text,
          });
        }

        // Close loading dialog
        Navigator.pop(context);
        showSuccessMessage('User signed up successfully!');

        Future.delayed(const Duration(seconds: 2), () {
          resetTextFields();
          Navigator.pop(context);
        });
      } else {
        showErrorMessage('Passwords do not match');
        Navigator.pop(context); // Close the loading dialog
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the loading dialog
      showErrorMessage(e.code);
    }
  }

  void resetTextFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    advisoryController.clear();
    contactController.clear();
    addressController.clear();
  }

  void showSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<UserRole>(context, listen: false).role;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                  const SizedBox(height: 30),

                  // logo
                  Image.asset(
                    'lib/images/logo.png',
                    height: 100,
                  ),

                  // welcome back, you've been missed!
                  Text(
                    'Please choose your ROLE',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),
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
                  //firstname and lastname
                  MyTextField(
                    controller: firstNameController,
                    hintText: 'First Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: lastNameController,
                    hintText: 'Last Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  if (role == 'parent')
                    Column(
                      children: [
                        MyTextField(
                          controller: addressController,
                          hintText: 'Address',
                          obscureText: false,
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: contactController,
                          hintText: 'Contact Number',
                          obscureText: false,
                        ),
                      ],
                    ),

                  const SizedBox(height: 10),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),
                  if (role == 'teacher')
                    Column(
                      children: [
                        MyTextField(
                          controller: advisoryController,
                          hintText: 'Advisory',
                          obscureText: false,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // sign up button
                  MyButton(
                    onTap: areTermsAccepted ? signUserUp : null,
                    buttonText: 'Sign Up',
                  ),
                  const SizedBox(height: 10),

                  // Checkbox sa terms and conditions ug text

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
                  const SizedBox(height: 20),

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
                            'Or continue with',
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
                  SizedBox(height: 15),

                  // google sign up buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google button for sign-up
                      SquareTile(
                        onTap: areTermsAccepted
                            ? () async {
                                final authService =
                                    AuthService(); // Create an instance of AuthService
                                final role = Provider.of<UserRole>(context,
                                        listen: false)
                                    .role;

                                if (role == null || role.isEmpty) {
                                  // Show an error dialog if the role is not selected
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
                                } else {
                                  print('Role from SquareTile 04/04 $role');
                                  authService.signUpWithGoogle(role, context);
                                }
                              }
                            : null,
                        imagePath: 'lib/images/google.png',
                      ),
                    ],
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
