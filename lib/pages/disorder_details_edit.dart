import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisorderDetailsPage extends StatefulWidget {
  final String disorderName;
  final String howToDeal;
  final String doInfo;
  final String dontInfo;
  final String symptoms;
  final String treatment;
  final String firstAid;
  final String descrption;
  final String documentId;

  DisorderDetailsPage({
    super.key,
    required this.disorderName,
    required this.howToDeal,
    required this.doInfo,
    required this.dontInfo,
    required this.symptoms,
    required this.treatment,
    required this.firstAid,
    required this.descrption,
    required this.documentId,
  });

  @override
  _DisorderDetailsPageState createState() => _DisorderDetailsPageState();
}

class _DisorderDetailsPageState extends State<DisorderDetailsPage> {
  late TextEditingController _howToDealController;
  late TextEditingController _doInfoController;
  late TextEditingController _dontInfoController;
  late TextEditingController _symptomsController;
  late TextEditingController _treatmentController;
  late TextEditingController _firstAidController;
  late TextEditingController _descriptionController;
  late TextEditingController _disorderNameController;

  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    _howToDealController = TextEditingController(text: widget.howToDeal);
    _doInfoController = TextEditingController(text: widget.doInfo);
    _dontInfoController = TextEditingController(text: widget.dontInfo);
    _symptomsController = TextEditingController(text: widget.symptoms);
    _treatmentController = TextEditingController(text: widget.treatment);
    _firstAidController = TextEditingController(text: widget.firstAid);
    _descriptionController = TextEditingController(text: widget.descrption);
    _disorderNameController = TextEditingController(text: widget.disorderName);
  }

  @override
  void dispose() {
    _howToDealController.dispose();
    _doInfoController.dispose();
    _dontInfoController.dispose();
    _symptomsController.dispose();
    _treatmentController.dispose();
    _firstAidController.dispose();
    _descriptionController.dispose();
    _disorderNameController.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditable = !isEditable;
    });
  }

  void saveChanges() async {
    // Get updated values from text editing controllers
    String updatedHowToDeal = _howToDealController.text;
    String updatedDoInfo = _doInfoController.text;
    String updatedDontInfo = _dontInfoController.text;
    String updatedSymptoms = _symptomsController.text;
    String updatedTreatment = _treatmentController.text;
    String updatedFirstAid = _firstAidController.text;
    String updatedDescription = _descriptionController.text;
    String updatedDisorderName = _disorderNameController.text;

    try {
      // Update Firestore with the new values
      await FirebaseFirestore.instance
          .collection('mental_disorder')
          .doc(widget.documentId)
          .update({
        'description': updatedDescription,
        'how_to_deal': updatedHowToDeal,
        'dos': updatedDoInfo,
        'donts': updatedDontInfo,
        'symptoms': updatedSymptoms,
        'treatment': updatedTreatment,
        'first_aid': updatedFirstAid,
        'disorder_name': updatedDisorderName,
      });

      // Show a snackbar to inform the user that changes were saved successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully')),
      );
    } catch (error) {
      // Handle errors here (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes. Please try again.')),
      );
      // Optionally, log the error for debugging purposes
      print('Error: $error');
    }
  }

  void deleteDisorder() async {
    try {
      await FirebaseFirestore.instance
          .collection('mental_disorder')
          .doc(widget.disorderName)
          .delete();

      // Show a snackbar to inform the user that the disorder was deleted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Child Impairment deleted successfully')),
      );

      // Navigate back to the previous screen
      Navigator.of(context).pop();
    } catch (error) {
      // Handle errors here (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to delete Child Impairment. Please try again.')),
      );
      // Optionally, log the error for debugging purposes
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Impairment Details'),
        actions: [
          IconButton(
            icon: Icon(isEditable ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditable) {
                saveChanges();
              }
              toggleEditMode(); // Toggle edit mode regardless
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteDisorder();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _disorderNameController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Child Impairment'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _descriptionController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _howToDealController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'How to Deal'),
              ),
              TextFormField(
                controller: _doInfoController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Dos'),
              ),
              TextFormField(
                controller: _dontInfoController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Don\'ts'),
              ),
              TextFormField(
                controller: _symptomsController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Symptoms'),
              ),
              TextFormField(
                controller: _treatmentController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Treatment'),
              ),
              TextFormField(
                controller: _firstAidController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'First Aid'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
