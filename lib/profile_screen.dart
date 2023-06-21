

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat/auth/login.dart';

import 'package:my_chat/helper/dialog.dart';
import 'package:my_chat/models/chat_user.dart';
import 'package:my_chat/splash.dart';
import 'package:my_chat/widgets/chatUserCard.dart';
import 'dart:developer';
import 'apiFolder/api.dart';


class profile extends StatefulWidget {
  final ChatApp user;

  const profile({Key? key, required this.user}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('User Profile'),

          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                dialog.showProgressbar(context);
                await Api.auth.signOut().then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => login()));
                });
                await GoogleSignIn().signOut();
              },
              icon: const Icon(Icons.logout),
              label: Text('LogOut'),),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .06),
            child: Column(
              children: [
                SizedBox(width: mq.width,
                    height: mq.height * .03),
                Stack(
                  children: [
                    _image != null ? ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .1),
                      child: Image.file(
                        File(_image!),
                        height: mq.height * .2,
                        width: mq.width * .4,
                        fit: BoxFit.fill,

                      ),
                    ):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .1),
                      child: CachedNetworkImage(
                        height: mq.height * .2,
                        width: mq.width * .4,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.images,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            CircleAvatar(child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                    Positioned(bottom: 0, right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          child: Icon(Icons.edit, color: Colors.blue,),
                          color: Colors.white,
                          shape: CircleBorder(),))
                  ],
                ),
                SizedBox(height: mq.height * .02),
                Text(widget.user.email,
                    style: TextStyle(color: Colors.black54, fontSize: 16)),
                SizedBox(height: mq.height * .05),
                TextFormField(
                  initialValue: widget.user.name,
                  decoration: InputDecoration(border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ), prefix: Icon(Icons.person, color: Colors.blue,),
                      hintText: "ex: Abc singh",
                      label: const Text('Name')),
                ),
                SizedBox(height: mq.height * .02),
                TextFormField(
                  initialValue: widget.user.about,
                  decoration: InputDecoration(border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      prefix: Icon(Icons.info_outline, color: Colors.blue,),
                      hintText: "ex: Anything about you",
                      label: Text('About')),
                ),
                SizedBox(height: mq.height * .06),
                ElevatedButton.icon(onPressed: () {},
                  icon: Icon(Icons.edit, size: 25,),
                  label: Text('Update', style: TextStyle(fontSize: 18),),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder(),
                      minimumSize: Size(mq.width * .5, mq.height * .065)),)
              ],

            ),
          )
      ),
    );
  }
    void  _showBottomSheet(){
      showModalBottomSheet(context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))),
          builder: (_){
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: mq.height *.06,bottom: mq.height*.06),
          children: [
            Text("Pick Profile Picture",textAlign:TextAlign.center,style: TextStyle(fontSize: 26,fontWeight:FontWeight.w500)),
            SizedBox(height: mq.height *.05,width: mq.width*.05,),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    fixedSize: Size(mq.width*.3, mq.height*.15)
                  ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
// Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                      if(image!=Null){
                        log('image path: ${image?.path}');
                        setState(() {
                          _image=image?.path;
                        });
                        Api.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }

                    },
                    child: Image.asset('images/addImg.png')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: CircleBorder(),
                        fixedSize: Size(mq.width*.3, mq.height*.15)
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
// Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                      if(image!=Null){
                        log('image path: ${image!.path}');
                        setState(() {
                          _image=image.path;
                        });
                        Api.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset('images/camera.png'))
              ],
            )
          ],
        );
      });
    }
  }


