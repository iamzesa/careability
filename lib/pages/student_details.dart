import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> studentDetails;

  const StudentDetailsPage({
    Key? key,
    required this.studentDetails,
  }) : super(key: key);

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  late String status;
  late String information;

  late DocumentSnapshot? mentalDisorderSnapshot;
  late DocumentSnapshot? parentEmailSnapshot;

  late TextEditingController _statusController;
  late TextEditingController _informationController;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    fetchMentalDisorderDetails();
    fetchParentEmailDetails();

    status = widget.studentDetails['status'];
    information = widget.studentDetails['information'];

    _statusController = TextEditingController(text: status);
    _informationController = TextEditingController(text: information);
  }

  @override
  void dispose() {
    _statusController.dispose();
    _informationController.dispose();

    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditable = !isEditable;
    });
  }

  Future<void> fetchMentalDisorderDetails() async {
    final mentalDisorderRef =
        widget.studentDetails['mental_disorder'] as DocumentReference;

    mentalDisorderSnapshot = await mentalDisorderRef.get();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchParentEmailDetails() async {
    final parentEmailRef = widget.studentDetails['parent'] as DocumentReference;

    parentEmailSnapshot = await parentEmailRef.get();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateStudentDetails() async {
    try {
      String studentName = widget.studentDetails['student_name'];
      print('Student Name to search: $studentName');

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('student_name', isEqualTo: studentName)
          .limit(1)
          .get();

      // Check if the document exists
      if (snapshot.docs.isNotEmpty) {
        String documentId = snapshot.docs.first.id; // Get the document ID
        print(
            'Document ID to update: $documentId'); // Print the retrieved document ID

        // Update the document using the retrieved ID
        await FirebaseFirestore.instance
            .collection('student')
            .doc(documentId)
            .update({
          'status': _statusController.text,
          'information': _informationController.text,
        });

        setState(() {
          status = _statusController.text;
          information = _informationController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Details updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('No matching document found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update details: $e'),
          duration: Duration(seconds: 2),
        ),
      );
      print('Failed to update details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Name: ${widget.studentDetails['student_name']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Parent Name: ${widget.studentDetails['parent_name']}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              if (parentEmailSnapshot != null && parentEmailSnapshot!.exists)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parent Email: ${parentEmailSnapshot!['email']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              if (parentEmailSnapshot == null || !parentEmailSnapshot!.exists)
                Text(
                  'Mental disorder details not found',
                  style: TextStyle(fontSize: 16.0),
                ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                enabled: isEditable,
                onChanged: (value) {
                  status = value;
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _informationController,
                decoration: InputDecoration(
                  labelText: 'Information',
                  border: OutlineInputBorder(),
                ),
                enabled: isEditable,
                onChanged: (value) {
                  information = value;
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.orange, // Set the desired color here
                  ),
                ),
                onPressed: () async {
                  if (isEditable) {
                    await updateStudentDetails();
                  }
                  toggleEditMode();
                },
                child: Text(isEditable ? 'Save Changes' : 'Edit Details'),
              ),

              Divider(
                height: 1,
                color: Colors.grey,
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(height: 10.0),

              Text(
                'Child Impairment Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              // Display mental disorder details
              if (mentalDisorderSnapshot != null &&
                  mentalDisorderSnapshot!.exists)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' ${mentalDisorderSnapshot!['disorder_name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),

                    SizedBox(height: 8.0),
                    Text(
                      'Dos:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      '${mentalDisorderSnapshot!['dos']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Donts:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      '${mentalDisorderSnapshot!['donts']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Symptoms:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      '${mentalDisorderSnapshot!['symptoms']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'First Aid:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      '${mentalDisorderSnapshot!['first_aid']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Treatment:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      '${mentalDisorderSnapshot!['treatment']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'How to Deal:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      '${mentalDisorderSnapshot!['how_to_deal']}',
                      style: TextStyle(fontSize: 16.0),
                    ),

                    // Add more Text widgets for other details if needed
                  ],
                ),
              if (mentalDisorderSnapshot == null ||
                  !mentalDisorderSnapshot!.exists)
                Text(
                  'Mental disorder details not found',
                  style: TextStyle(fontSize: 16.0),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
