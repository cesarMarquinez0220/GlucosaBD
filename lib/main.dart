import 'package:flutter/material.dart';
import 'package:glucosapp/Dashboard/dashboard.dart';
import 'package:glucosapp/src/welcomePage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyLarge: GoogleFonts.montserrat(textStyle: textTheme.bodyLarge),
        ),
        useMaterial3: true,
      ),
      home: const Dashboard(),
      home: const WelcomePage(),
    );
  }
}
