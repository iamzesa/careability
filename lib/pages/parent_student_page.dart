import 'package:careability/pages/add_student_page.dart';
import 'package:careability/pages/student_details.dart';
import 'package:careability/pages/student_details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

class ParentStudentPage extends StatefulWidget {
  @override
  _ParentStudentPageState createState() => _ParentStudentPageState();
}

class _ParentStudentPageState extends State<ParentStudentPage> {
  TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _studentsStream;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Future<String?> getCurrentUserEmail() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;

  //   if (user != null) {
  //     return user.email;
  //   }

  //   return null;
  // }

  void _loadStudents() async {
    // String? parentEmail = await getCurrentUserEmail();

    if (userEmail != null) {
      print('Parent Email: $userEmail'); // Print parent's email

      _studentsStream = FirebaseFirestore.instance
          .collection('student')
          .where('parent',
              isEqualTo: FirebaseFirestore.instance.doc('parent/$userEmail'))
          .snapshots();

      setState(() {
        _isLoading = false;
      });
    } else {
      print('Parent Email is null');
    }
  }

  Widget _buildStudentListTile(DocumentSnapshot student) {
    return ListTile(
      tileColor: Color.fromARGB(255, 240, 236, 236),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetailsViewOnly(
              studentDetails: {
                'student_name': student['student_name'],
                'parent_name': student['parent_name'],
                'status': student['status'],
                'information': student['information'],
                'mental_disorder': student['mental_disorder'],
                'parent': student['parent'],
                'teacher': student['teacher'],
              },
            ),
          ),
        );
      },
      leading: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey, // Set icon color if desired
      ),
      title: Text(
        'Student: ${student['student_name']}',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
        ),
      ),
      subtitle: Text(
        'Parent: ${student['parent_name']}',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildStudentListView() {
    return _isLoading
        ? Center(child: CircularProgressIndicator()) // Show loading indicator
        : StreamBuilder<QuerySnapshot>(
            stream: _studentsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length * 2 - 1,
                  itemBuilder: (context, index) {
                    if (index.isOdd) {
                      return Divider();
                    }
                    final studentIndex = index ~/ 2;
                    return _buildStudentListTile(
                        snapshot.data!.docs[studentIndex]);
                  },
                );
              }

              return const Center(child: Text('No students found.'));
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Students'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 12,
          ),
          Expanded(child: _buildStudentListView()),
        ],
      ),
    );
  }
}
