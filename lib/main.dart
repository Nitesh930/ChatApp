
import 'package:flutter/material.dart';
import 'package:my_chat/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() {

  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Messenger',
        theme: ThemeData(

            appBarTheme: const AppBarTheme(
              centerTitle: true,
              iconTheme: IconThemeData(color:Colors.black),
              titleTextStyle: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.normal),
              backgroundColor: Colors.white,
            )
        ),
        home: splash(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  }
_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}