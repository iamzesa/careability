import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class ParentProfilePage extends StatefulWidget {
  const ParentProfilePage({Key? key}) : super(key: key);

  @override
  State<ParentProfilePage> createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  @override
  Widget build(BuildContext context) {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent's Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              if (result != null && result) {
                setState(() {});
              }
            },
            icon: Icon(Icons.edit),
          ),
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
            return Center(
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
            return Center(
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

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    FirebaseFirestore.instance
        .collection('parent')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final parentDoc = snapshot.docs.first;
        final parentData = parentDoc.data() as Map<String, dynamic>;

        setState(() {
          _firstNameController.text = parentData['firstName'] ?? '';
          _lastNameController.text = parentData['lastName'] ?? '';
          _addressController.text = parentData['address'] ?? '';
          _contactController.text = parentData['contact'] ?? '';
        });
      }
    }).catchError((error) {
      print("Error fetching document: $error");
    });
  }

  void _saveChanges() {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    FirebaseFirestore.instance
        .collection('parent')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final parentDoc = snapshot.docs.first;
        parentDoc.reference.update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'address': _addressController.text,
          'contact': _contactController.text,
        }).then((_) {
          Navigator.pop(context, true); // Send a true value to indicate update
        }).catchError((error) {
          print("Error updating document: $error");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Contact'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
