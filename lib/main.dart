import 'package:flutter/material.dart';
import 'package:flutter_worker/pages/admin_page.dart';
import 'package:flutter_worker/pages/home_page.dart';
import 'package:flutter_worker/pages/login_home_page.dart';
import 'package:flutter_worker/pages/register_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginHomePage(),
        '/register': (context) => const RegisterHomePage(),
        '/home_page': (context) => const HomePage(),
        '/admin_page': (context) => const AdminPage(),
      },
    );
  }
}
