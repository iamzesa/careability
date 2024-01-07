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
  Map<String, String> mentalDisorderMap = {};
  String? selectedDisorderId;
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
      final parentReference =
          FirebaseFirestore.instance.doc('parent/$parentEmail');
      final selectedDisorderId =
          mentalDisorderMap[selectedMentalDisorder ?? ''];
      final mentalDisorderReference = selectedDisorderId != null
          ? FirebaseFirestore.instance
              .doc('mental_disorder/$selectedDisorderId')
          : null;

      final studentData = {
        'student_name': studentNameController.text,
        'parent': parentReference,
        'parent_name': parentNameController.text,
        'teacher': FirebaseFirestore.instance.doc('teacher/$teacherEmail'),
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
            duration: Duration(seconds: 2),
          ),
        );
        print('Student added successfully!');
      } catch (e) {
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
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('mental_disorder').get();

      Map<String, String> tempMap = {}; // Temporary map

      for (var doc in querySnapshot.docs) {
        final disorderName = doc['disorder_name'];
        final disorderId = doc.id; // Retrieve the document ID

        tempMap[disorderName] = disorderId; // Store name-ID pair in the map
      }

      setState(() {
        mentalDisorderMap = tempMap; // Assign tempMap to mentalDisorderMap
        mentalDisorderList =
            mentalDisorderMap.keys.toList(); // Update disorder list
      });

      // Print retrieved data
      print('Retrieved Mental Disorders:');
      for (var entry in mentalDisorderMap.entries) {
        print('Name: ${entry.key}, ID: ${entry.value}');
      }
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
                    hintText: 'Parent Email',
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
                        selectedDisorderId = mentalDisorderMap[newValue ?? ''];
                        print('Selected Disorder ID: $selectedDisorderId');
                      });
                    },
                    hintText: 'Child Impairment',
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
