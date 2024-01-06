import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../user_role.dart';

class DisorderDetailsPage extends StatefulWidget {
  final String disorderName;
  final String howToDeal;
  final String doInfo;
  final String dontInfo;
  final String symptoms;
  final String treatment;
  final String firstAid;

  DisorderDetailsPage({
    required this.disorderName,
    required this.howToDeal,
    required this.doInfo,
    required this.dontInfo,
    required this.symptoms,
    required this.treatment,
    required this.firstAid,
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
  }

  @override
  void dispose() {
    _howToDealController.dispose();
    _doInfoController.dispose();
    _dontInfoController.dispose();
    _symptomsController.dispose();
    _treatmentController.dispose();
    _firstAidController.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditable = !isEditable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Impairment Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.disorderName}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _howToDealController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'How to Deal'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _doInfoController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Do\'s'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _dontInfoController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Don\'ts'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _symptomsController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Symptoms'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _treatmentController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'Treatment'),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _firstAidController,
                enabled: isEditable,
                decoration: InputDecoration(labelText: 'First Aid'),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
