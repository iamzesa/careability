import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role.dart';
import 'bottom_navigation.dart';

class HomePage extends StatefulWidget {
  final String userRole;
  final String userId;

  HomePage({Key? key, required this.userRole, required this.userId})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Update the constructor
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserRole>(context);

    print('User Role in HomePage: ${userRole.role}');

    return Scaffold(
      body: MyBottomNavigationBar(
          userRole: userRole.role, userId: widget.userId), //
    );
  }
}
