import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role.dart';
import 'parent_homepage.dart';
import 'parent_profile_page.dart';
import 'parent_student_page.dart';
import 'teacher_homepage.dart';
import 'teacher_profile_page.dart';
import 'teacher_student_page.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final String userRole; // Accepting user role as a parameter
  final String userId;

  const MyBottomNavigationBar(
      {Key? key, required this.userRole, required this.userId})
      : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserRole>(context);

    print('User Role in BottomNavigationBar: ${widget.userRole}');

    List<Widget> pages;

    if (userRole.role == 'teacher') {
      pages = <Widget>[
        TeacherHomePage(),
        TeacherStudentPage(),
        TeacherProfilePage(),
      ];
    } else {
      pages = <Widget>[
        ParentHomePage(),
        ParentStudentPage(),
        ParentProfilePage(),
      ];
    }

    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
