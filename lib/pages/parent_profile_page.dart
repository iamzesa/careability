import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent's Profile"),
        actions: const [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('parent')
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

          final parentDocs = snapshot.data?.docs;

          if (parentDocs == null || parentDocs.isEmpty) {
            return const Center(
              child: Text('No parent data found.'),
            );
          }

          final parentData = parentDocs.first.data() as Map<String, dynamic>;

          final firstName = parentData['firstName'] as String?;
          final lastName = parentData['lastName'] as String?;
          final email = parentData['email'] as String?;
          final address = parentData['address'] as String?;
          final contact = parentData['contact'] as String?;

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
                  SizedBox(height: 5),
                  Text(
                    'Last Name: $lastName',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Contact: $contact',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Address: $address',
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
