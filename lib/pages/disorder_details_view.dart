import 'package:flutter/material.dart';

class DisorderViewPage extends StatelessWidget {
  final String disorderName;
  final String howToDeal;
  final String doInfo;
  final String dontInfo;
  final String symptoms;
  final String treatment;
  final String firstAid;

  DisorderViewPage({
    required this.disorderName,
    required this.howToDeal,
    required this.doInfo,
    required this.dontInfo,
    required this.symptoms,
    required this.treatment,
    required this.firstAid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Impairment Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$disorderName',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            _buildDetailField('How to Deal', howToDeal),
            _buildDetailField('Dos', doInfo),
            _buildDetailField('Don\'ts', dontInfo),
            _buildDetailField('Symptoms', symptoms),
            _buildDetailField('Treatment', treatment),
            _buildDetailField('First Aid', firstAid),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        Text(value),
        SizedBox(height: 10.0),
        Divider(), // Optional: Adds a divider between fields
        SizedBox(height: 10.0),
      ],
    );
  }
}
