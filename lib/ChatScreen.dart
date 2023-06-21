import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';



import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat/models/chat_user.dart';
import 'package:my_chat/widgets/message_card.dart';

import 'apiFolder/api.dart';
import 'auth/login.dart';
import 'models/message.dart';
import 'models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatApp user;

  const ChatScreen ({super.key, required this.user,});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 List<Messages> _list=[];
 bool _showEmoji=false;
 final _textController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(

        child: Scaffold(

                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace:_appBar(),

                ),
          body: Column(children: [
         Expanded(
           child: StreamBuilder(

                stream: Api.getAllMessages(widget.user),
                builder: (context,snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return SizedBox();
                    case ConnectionState.active:
                    case ConnectionState.done:


                      final data=snapshot.data?.docs;
                    //  log('Data : ${jsonEncode(data![0].data())}');
                      _list = data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];



                      if(_list.isNotEmpty){
                        return ListView.builder(
                            itemCount:_list.length,
                            itemBuilder: (context,index){
                              return MessageCard(message: _list[index]);
                            });
                      }
                      else{
                        return Center(
                          child:  Text('Say Hii! 👋',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                        );
                      }
                  }

                },
              ),
         ),
            _chatInput(),

            if(_showEmoji)
            SizedBox(
              height: mq.height * .35,
              child: EmojiPicker(


              textEditingController: _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
              config: Config(
                bgColor: CupertinoColors.white,
              columns: 8,
              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894

      ),
      ),
            )
          ],),
         ),

      ),
    );
  }
  Widget _appBar(){
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .1),
            child: CachedNetworkImage(
              height: mq.height * .04,
              width: mq.width * .08,
              fit: BoxFit.cover,
              imageUrl: widget.user.images,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),
              SizedBox(height: 5),
              Text('Last seen not available')
            ],
          )
        ],
      ),
    );

  }
  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(children: [
          IconButton(onPressed: (){
              setState(() {
                _showEmoji=!_showEmoji;
              });
          }, icon: Icon(Icons.emoji_emotions,color: Colors.black,)),

          Expanded(
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                onTap: (){
                  if(_showEmoji){
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _showEmoji=!_showEmoji;
                    });
                  }
                },
                maxLines: null,
                decoration:
              InputDecoration(
                  hintText: 'Write anything here..',
                  hintStyle: TextStyle(color: Colors.blueAccent)
                  ,border: InputBorder.none),
              )
          ),
          SizedBox(width: 6,),
          IconButton(onPressed: (){}, icon: Icon(Icons.image,color: Colors.black,size: 24,)),
          IconButton(onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
            if(image!=Null) {
              log('image path: ${image?.path}');

              await Api.sendChatImage(widget.user, File(image!.path));
            }
          },

        icon: Icon(Icons.camera,color: Colors.black,size: 24,)),
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              Api.sendMessage(widget.user, _textController.text,Type.text);
              _textController.text='';
            }
          },shape: CircleBorder(),color: Colors.green,child: Icon(Icons.send,color: Colors.white,size: 24,),)
        ],
        ),
      ),
    );
  }
}
