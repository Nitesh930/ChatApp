import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chat/helper/dialog.dart';
import 'package:my_chat/home.dart';

import '../apiFolder/api.dart';



late Size mq;
class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool  _isAnimate = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate=true;
      });
    });
  }
_handlegooglebutton(){
    dialog.showProgressbar(context);

  _signInWithGoogle().then((user) async {
    Navigator.pop(context);
    if(user !=null){
      log('\nUser:${user.user}');

      log('\nUser:${user.additionalUserInfo}');
      if((await Api.userExists())){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const home()));
      }
      else{
      await Api.createUser().then((value){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const home()));
      });
      }

    }
  });
}
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Api.auth.signInWithCredential(credential);
    }
    catch (e) {
      log('\nSignin with google,$e');
      dialog.showSnackbar(context, 'Something went wrong');
      return null;
    }

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
        AnimatedPositioned(
            top: mq.height * .05,
            width: mq.width * .5,
            right:_isAnimate ? mq.width *.25: -mq.width*.5,
            duration: const Duration(seconds: 1),

            child: Image.asset('images/meetme.png')),

        Positioned(
            bottom: mq.height * .15,
            width: mq.width * .8,
            left: mq.width *.09,
            height: mq.height *0.045,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen.shade50,shape: const StadiumBorder()),
                onPressed: () {
                 _handlegooglebutton();
                }, icon:Image.asset('images/google.png'),
                label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [

                        TextSpan(text: 'SignIn with '),
                        TextSpan(text: 'Google',style:TextStyle(fontWeight:FontWeight.w500)),
                      ]),
                )

            ))


      ]),
    );
  }
}
