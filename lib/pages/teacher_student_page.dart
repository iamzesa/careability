import 'package:careability/pages/add_student_page.dart';
import 'package:careability/pages/student_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

class TeacherStudentPage extends StatefulWidget {
  @override
  _TeacherStudentPageState createState() => _TeacherStudentPageState();
}

class _TeacherStudentPageState extends State<TeacherStudentPage> {
  TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _studentsStream;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

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

  void _loadStudents() async {
    // String? parentEmail = await getCurrentUserEmail();

    if (userEmail != null) {
      print('Parent Email: $userEmail'); // Print parent's email

      _studentsStream = FirebaseFirestore.instance
          .collection('student')
          .where('teacher',
              isEqualTo: FirebaseFirestore.instance.doc('teacher/$userEmail'))
          .snapshots();
    } else {
      print('Teacher Email is null');
    }
  }

  void _deleteStudent(String documentId) {
    FirebaseFirestore.instance
        .collection('student')
        .doc(documentId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student deleted successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete student: $error')));
    });
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
            builder: (context) => StudentDetailsPage(
              studentDetails: {
                'student_name': student['student_name'],
                'parent_name': student['parent_name'],
                'status': student['status'],
                'information': student['information'],
                'mental_disorder': student['mental_disorder'],
                'parent': student['parent'],
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
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _deleteStudent(student.id); // Call delete function with document ID
        },
      ),
    );
  }

  Widget _buildStudentListView() {
    return StreamBuilder<QuerySnapshot>(
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
              return _buildStudentListTile(snapshot.data!.docs[studentIndex]);
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
        title: Text('Teacher Students'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for student names',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
                print('Searching for: $value');
                // Modify the _studentsStream based on the search value
                if (value.isNotEmpty) {
                  _studentsStream = FirebaseFirestore.instance
                      .collection('student')
                      .where('student_name', isGreaterThanOrEqualTo: value)
                      .where('student_name',
                          isLessThanOrEqualTo: value + '\uf8ff')
                      .snapshots();
                } else {
                  _loadStudents(); // Reset to the original stream
                }
                setState(() {}); // Trigger a rebuild to reflect changes
              },
            ),
          ),
          Expanded(child: _buildStudentListView()),
          MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddStudentPage(), // Replace with your page name
                  ),
                );
              },
              buttonText: "Add Student Information")
        ],
      ),
    );
  }
}
