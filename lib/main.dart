import 'package:flutter/material.dart';
import 'package:mill_info/homeScreen.dart';
import 'package:shared_value/shared_value.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mill_info/input_screen.dart';
import 'package:mill_info/login_screen.dart';
import 'firebase_options.dart';

// ...
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SharedValue.wrapApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home:HomeScreen(),
      home:LoginSignupScreen(),

    );
  }
}

