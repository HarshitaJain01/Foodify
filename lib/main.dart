import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodify/screens/home_page/bloc/homerecipes_bloc.dart';
import 'package:foodify/screens/home_page/home_page.dart';
import 'package:foodify/screens/loginpage/LoginPage.dart';

import 'package:foodify/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodify',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: BlocProvider(
        create: (context) => HomeRecipesBloc(),
        child: const HomeRecipeScreen(),
      ),
    );
  }
}
