import 'package:flutter/material.dart';
import 'package:sajiwara/screens/login.dart';
import 'package:sajiwara/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Sajiwara',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepOrange,
          ).copyWith(secondary: Colors.deepOrange[400]),
        ),
        // home: MyHomePage(),
        home:  MyHomePage(),
      ),
    );
  }
}
