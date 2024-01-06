import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherProfilePage extends StatelessWidget {
  const TeacherProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher's Profile"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('teacher')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final teacherDocs = snapshot.data?.docs;

          if (teacherDocs == null || teacherDocs.isEmpty) {
            return const Center(
              child: Text('No teacher data found.'),
            );
          }

          final teacherData = teacherDocs.first.data() as Map<String, dynamic>;

          final firstName = teacherData['firstName'] as String?;
          final lastName = teacherData['lastName'] as String?;
          final advisory = teacherData['advisory'] as String?;
          final email = teacherData['email'] as String?;

          print(
              'Advisory: $advisory'); // Add this line to check the value of advisory

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'lib/images/logo.png',
                    height: 150,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'First Name: $firstName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Last Name: $lastName',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Advisory: $advisory',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
