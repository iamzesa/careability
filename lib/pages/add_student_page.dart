import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careability/components/my_button.dart';
import 'package:careability/components/my_textfield.dart';

import '../components/my_dropdown.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final studentNameController = TextEditingController();
  final parentNameController = TextEditingController();
  final mentalDisorderController = TextEditingController();
  final informationController = TextEditingController();
  final statusController = TextEditingController();

  List<String> mentalDisorderList = []; // List to hold mental disorder names
  String? selectedMentalDisorder; // Selected mental disorder value

  Future<void> addStudent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final teacherEmail = user.email;

      final parentEmail = emailController.text;
      final parentReference = 'parent/$parentEmail';

      final mentalDisorderReference =
          'mental_disorder/${mentalDisorderController.text}';

      final studentData = {
        'student_name': studentNameController.text,
        'parent': parentReference,
        'parent_name': parentNameController.text,
        'teacher': 'teacher/$teacherEmail',
        'mental_disorder': mentalDisorderReference,
        'status': statusController.text,
        'information': informationController.text,
        // Add other fields here...
      };

      try {
        await FirebaseFirestore.instance.collection('student').add(studentData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student added successfully!'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );

        print('Student added successfully!');
      } catch (e) {
        // Show an error message or handle the error appropriately.
        print('Error adding student: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch mental disorders from Firestore
    fetchMentalDisorders();
  }

  Future<void> fetchMentalDisorders() async {
    try {
      // Replace 'mental_disorder' with your collection name
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('mental_disorder').get();

      List<String> disorders = [];

      for (var doc in querySnapshot.docs) {
        disorders.add(doc['disorder_name']);
      }

      setState(() {
        mentalDisorderList = disorders;
      });
    } catch (e) {
      print('Error fetching mental disorders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        height: double.infinity,
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
                  const SizedBox(height: 20),
                  Text(
                    'Please Enter the Student Information below',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: studentNameController,
                    hintText: 'Student Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: parentNameController,
                    hintText: 'Parent Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  //dropdown choices
                  MyDropdownField(
                    value: selectedMentalDisorder,
                    items: mentalDisorderList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMentalDisorder = newValue;
                      });
                    },
                    hintText: 'Mental Disorder',
                  ),

                  const SizedBox(height: 10),
                  MyTextField(
                    controller: informationController,
                    hintText: 'Information',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: statusController,
                    hintText: 'Status',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: addStudent,
                    buttonText: 'Add Student',
                  ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
