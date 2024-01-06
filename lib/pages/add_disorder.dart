import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careability/components/my_button.dart';
import 'package:careability/components/my_textfield.dart';

import '../components/my_dropdown.dart';

class AddDisorderPage extends StatefulWidget {
  const AddDisorderPage({Key? key}) : super(key: key);

  @override
  _AddDisorderPageState createState() => _AddDisorderPageState();
}

class _AddDisorderPageState extends State<AddDisorderPage> {
  final disorderNameController = TextEditingController();
  final disorderIdController = TextEditingController();
  final howToDealController = TextEditingController();
  final dosController = TextEditingController();
  final dontsController = TextEditingController();
  final symptomsController = TextEditingController();
  final treatmentController = TextEditingController();
  final firstAidController = TextEditingController();

  Future<void> addDisorder() async {
    try {
      // Firestore collection reference
      CollectionReference mentalDisorderCollection =
          FirebaseFirestore.instance.collection('mental_disorder');

      // Add the disorder data to Firestore
      await mentalDisorderCollection.add({
        'disorder_name': disorderNameController.text,
        'how_to_deal': howToDealController.text,
        'dos': dosController.text,
        'donts': dontsController.text,
        'symptoms': symptomsController.text,
        'treatment': treatmentController.text,
        'first_aid': firstAidController.text,
      });

      // Display success message or perform any necessary actions after adding the disorder
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disorder added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Clear text fields after adding the disorder
      disorderNameController.clear();
      howToDealController.clear();
      dosController.clear();
      dontsController.clear();
      symptomsController.clear();
      treatmentController.clear();
      firstAidController.clear();

      print('Disorder added successfully!');
    } catch (e) {
      print('Error adding disorder: $e');
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
                  const Text(
                    'Please Add Child Impairments Information.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: disorderNameController,
                    hintText: 'Impairment',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: howToDealController,
                    hintText: 'How to Deal',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: dosController,
                    hintText: 'Dos',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: dontsController,
                    hintText: "Dont's",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: symptomsController,
                    hintText: "Symptoms",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: treatmentController,
                    hintText: 'Treatment',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: firstAidController,
                    hintText: 'FirstAid',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: addDisorder,
                    buttonText: 'Add',
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
