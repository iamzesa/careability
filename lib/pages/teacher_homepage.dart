import 'package:careability/components/my_button.dart';
import 'package:careability/pages/add_disorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_page.dart';
import 'disorder_details_edit.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _disordersStream;

  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadDisorders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDisorders() {
    _disordersStream =
        FirebaseFirestore.instance.collection('mental_disorder').snapshots();
  }

  Widget _buildDisorderBlock(BuildContext context, DocumentSnapshot disorder) {
    String documentId = disorder.id;

    return GestureDetector(
      onTap: () {
        // Fetch details from the 'disorder' DocumentSnapshot

        String disorderName = disorder['disorder_name'];
        String howToDeal = disorder['how_to_deal'];
        String doInfo = disorder['dos'];
        String dontInfo = disorder['donts'];
        String symptoms = disorder['symptoms'];
        String treatment = disorder['treatment'];
        String firstAid = disorder['first_aid'];
        String description = disorder['description'];

        // Navigate to a new page to display disorder details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisorderDetailsPage(
              documentId: documentId,
              disorderName: disorderName,
              doInfo: doInfo,
              dontInfo: dontInfo,
              howToDeal: howToDeal,
              symptoms: symptoms,
              treatment: treatment,
              firstAid: firstAid,
              descrption: description,
            ),
          ),
        );
      },
      child: Card(
        color: Color.fromARGB(255, 240, 236, 236),
        elevation: 2,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.psychology,
              size: 40,
              color: Colors.grey, // Set icon color if desired
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                disorder['disorder_name'],
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisorderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _disordersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 8.0, // Spacing between columns
              mainAxisSpacing: 8.0, // Spacing between rows
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return _buildDisorderBlock(context, snapshot.data!.docs[index]);
            },
          );
        }

        return const Center(child: Text('No child impairments found.'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: Icon(Icons.logout),
          )
        ],
        title: const Text("Teacher's Home"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome Teacher! ',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for child impairments',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.orangeAccent, width: 1.0),
                ),
              ),
              onChanged: (value) {
                print('Searching for: $value');

                if (value.isNotEmpty) {
                  _disordersStream = FirebaseFirestore.instance
                      .collection('mental_disorder')
                      .where('disorder_name', isGreaterThanOrEqualTo: value)
                      .where('disorder_name',
                          isLessThanOrEqualTo: value + '\uf8ff')
                      .snapshots();
                } else {
                  _loadDisorders(); // Reset to the original stream
                }
                setState(() {}); // Trigger a rebuild to reflect changes
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Text(
                "List of Child Impairments.",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Click to View"),
            ],
          ),
          Expanded(child: _buildDisorderList()),
          MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddDisorderPage(), // Replace with your page name
                  ),
                );
              },
              buttonText: "Add Child's Impairment")
        ],
      ),
    );
  }
}
