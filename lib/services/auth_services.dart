import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> signInWithGoogle(String? role) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final user = userCredential.user;

        if (user != null) {
          print('Google User Email: ${user.email}');
          print('Google User Display Name: ${user.displayName}');

          // Check if the user's email exists in the specified role collection
          final roleSnapshot = await FirebaseFirestore.instance
              .collection(role!)
              .doc(user.email)
              .get();

          // Check if the user's email exists in the 'teacher' collection
          final teacherSnapshot = await FirebaseFirestore.instance
              .collection('teacher')
              .doc(user.email)
              .get();

          // Check if the user's email exists in the 'parent' collection
          final parentSnapshot = await FirebaseFirestore.instance
              .collection('parent')
              .doc(user.email)
              .get();

          if (roleSnapshot.exists) {
            print('User found in $role collection. Proceeding with sign-in.');
            // User found in the specified role collection, proceed with sign-in
            print('Google Sign-In successful: ${userCredential.user}');
          } else if (teacherSnapshot.exists || parentSnapshot.exists) {
            print(
                'User found in teacher or parent collection but role does not match. Signing out.');
            // User found in other collection, but not in specified role collection, sign out
            await FirebaseAuth.instance.signOut();
          } else {
            print('User not found in any collection. Signing out.');
            // User not found in any collection, sign out
            await FirebaseAuth.instance.signOut();
          }
        }
      }
    } catch (e, stackTrace) {
      print('Error signing in with Google: $e');
      print('Stack Trace: $stackTrace');
      // Handle the error accordingly
    }
  }

  Future<void> signUpWithGoogle(String? role, BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        print('Google : ${googleUser}');

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print('Google Sign-In successful: ${userCredential.user}');

        final user = userCredential.user;

        print('Google User: ${user}');

        if (user != null) {
          print('Google User Email: ${user.email}');
          print('Google User Display Name: ${user.displayName}');

          // Save to Firestore based on role
          Map<String, dynamic> userData = {
            'email': user.email,
            'firstName': user.displayName,
            'profileCompleted': false,
            'contact': 'Please add',
            'address': 'Please add',
          };

          if (role == 'teacher') {
            print('Recognized role: teacher');
            // Save to teacher collection
            await FirebaseFirestore.instance
                .collection('teacher')
                .doc(user.email)
                .set(userData);
          } else if (role == 'parent') {
            print('Recognized role: parent');
            // Save to parent collection
            await FirebaseFirestore.instance
                .collection('parent')
                .doc(user.email)
                .set(userData);
          } else {
            print('Unrecognized role: $role');
            // Handle unrecognized role
          }
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content:
                  Text('Signed up successfully. Click back to go to Homepage.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the AlertDialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e, stackTrace) {
      print('Error signing in with Google: $e');
      print('Stack Trace: $stackTrace');
      // Handle the error accordingly
    }
  }
}
