import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shifa_clothe_app/users/authentication/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shifa Clothes App',
      debugShowCheckedModeBanner: false,
      initialRoute: "${const LoginScreen()}",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple
        )
      ),
      home: FutureBuilder(
        future: null,
        builder: (context, dataSnapShot) {
          return const LoginScreen();
        },
      ),
    );
  }
}


