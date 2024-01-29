import 'package:flutter/material.dart';
import 'package:poc_mobile_app/screens/auth/login_or_register_page.dart';
import 'package:poc_mobile_app/screens/home_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // checkLoginStatus();
  }

  // Future<void> checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   setState(() {
  //     isLoggedIn = loggedIn;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: isLoggedIn ? const HomePage() : const LoginOrRegisterPage(),
      home: const LoginOrRegisterPage(),
      routes: {
        '/home_page': (context) => const HomePage(),
      },
    );
  }
}
