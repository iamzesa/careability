import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> signInWithGoogle(String? selectedRole) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.additionalUserInfo!.isNewUser) {
          final user = userCredential.user;

          if (user != null) {
            print('Google User Email: ${user.email}');
            print('Google User Display Name: ${user.displayName}');

            // Save to Firestore based on selectedRole
            Map<String, dynamic> userData = {
              'email': user.email,
              'firstName': user.displayName,
              'profileCompleted': false, // Set profileCompleted to false
            };

            if (selectedRole == 'teacher') {
              // Save to teacher collection
              await FirebaseFirestore.instance
                  .collection('teacher')
                  .doc(user.email)
                  .set(userData);
            } else if (selectedRole == 'parent') {
              // Save to parent collection
              await FirebaseFirestore.instance
                  .collection('parent')
                  .doc(user.email)
                  .set(userData);
            }
          }
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      // Handle the error accordingly
    }
  }
}







// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   //Google Sign
//   signInWithGoogle() async {
//     //begin interactions sign in process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//     //obtain auth details
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;

//     //create a new credential for user
//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );

//     //sign in
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
// }
