import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDetailsViewOnly extends StatefulWidget {
  final Map<String, dynamic> studentDetails;

  const StudentDetailsViewOnly({
    Key? key,
    required this.studentDetails,
  }) : super(key: key);

  @override
  State<StudentDetailsViewOnly> createState() => _StudentDetailsViewOnlyState();
}

class _StudentDetailsViewOnlyState extends State<StudentDetailsViewOnly> {
  late String status;
  late String information;

  late DocumentSnapshot? mentalDisorderSnapshot;
  late DocumentSnapshot? parentEmailSnapshot;

  @override
  void initState() {
    super.initState();
    fetchMentalDisorderDetails();
    fetchParentEmailDetails();

    status = widget.studentDetails['status'];
    information = widget.studentDetails['information'];
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parent Email: ${parentEmailSnapshot!['email']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),

              SizedBox(height: 8.0),
              Text(
                'Status: ${widget.studentDetails['status']}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Information: ${widget.studentDetails['information']}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),

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
