// this is the studentDetails are passed from import 'package:careability/pages/student_details.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'add_student_page.dart';

// class TeacherStudentPage extends StatefulWidget {
//   @override
//   _TeacherStudentPageState createState() => _TeacherStudentPageState();
// }

// class _TeacherStudentPageState extends State<TeacherStudentPage> {
//   TextEditingController _searchController = TextEditingController();
//   List<Map<String, dynamic>> students = [];
//   String?
//       selectedDisorder; // Holds the selected disorder value from the dropdown

//   @override
//   void initState() {
//     super.initState();
//     fetchStudents(); // Call method to fetch student data
//   }

//   Future<void> fetchStudents() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('student').get();

//       List<Map<String, dynamic>> studentData = [];

//       for (var doc in querySnapshot.docs) {
//         String studentName = doc['student_name'];
//         String status = doc['status'];
//         String parentName =
//             doc['parent_name'] ?? ''; // Fetch parent_name directly
//         String information = doc['information'];

//         DocumentReference mentalDisorderRef = doc['mental_disorder'];
//         DocumentReference parentEmailRef = doc['parent'];

//         Map<String, dynamic> data = {
//           'student_name': studentName,
//           'parent_name': parentName,
//           'status': status,
//           'information': information,
//           'mental_disorder': mentalDisorderRef,
//           'parent': parentEmailRef,
//         };

//         studentData.add(data);
//       }

//       setState(() {
//         students = studentData;
//       });
//     } catch (e) {
//       print('Error fetching students: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Teacher Students'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),
//                 hintText: 'Search for student names',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 // TODO: Implement search functionality
//                 print('Searching for: $value');
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               //  Navigate to the new page for adding a student
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       const AddStudentPage(), // Replace with your page name
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               fixedSize: Size(150, 50),
//               primary: Colors.orange,
//             ),
//             child: Text('Add Student'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: students.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   height: 100,
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Text(students[index]['student_name']),
//                         subtitle:
//                             Text('Parent: ${students[index]['parent_name']}'),

//                         // TODO: Implement onTap for student details or editing
//                         onTap: () {
//                           if (students.isNotEmpty &&
//                               index >= 0 &&
//                               index < students.length) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => StudentDetailsPage(
//                                   studentDetails: students[index],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             print('Error: Student details not available');
//                           }
//                         },
//                       ),
//                       Divider(
//                         height: 1, // Adjust the height of the divider as needed
//                         color: Colors
//                             .grey, // Change the color of the divider if necessary
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }