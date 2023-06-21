
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/apiFolder/api.dart';
import 'package:my_chat/home.dart';
import 'auth/login.dart';


class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 1500),(){
      if(Api.auth.currentUser != null){
        log('\nUser:${Api.auth.currentUser}');

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const home() ));
      }
      else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const login() ));
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Messenger'),
        automaticallyImplyLeading: false,

      ),
      body: Stack(children: [
        Positioned(
            top: mq.height * .05,
            width: mq.width * .5,
            right: mq.width *.25,
            child: Image.asset('images/meetme.png')),

        Positioned(
            bottom: mq.height * .15,
            width: mq.width * .8,
            left: mq.width *.09,
            height: mq.height *0.045,
            child: const Text("MADE IN INDIA",textAlign:TextAlign.center,
                style: TextStyle(letterSpacing:0.5,fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)))


      ]),
    );
  }
}
