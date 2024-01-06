import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:careability/pages/auth_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/signup_page.dart';
import 'user_role.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserRole(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color:
              Colors.orange[700], // Set your desired color for the AppBar here
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
