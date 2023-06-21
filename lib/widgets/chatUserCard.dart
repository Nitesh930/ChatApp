import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/ChatScreen.dart';
import 'package:my_chat/auth/login.dart';
import 'package:my_chat/helper/my_date.dart';
import 'package:my_chat/models/message.dart';

import '../apiFolder/api.dart';
import '../models/chat_user.dart';
import '../splash.dart';




class chatUserCard extends StatefulWidget {
   final ChatApp user;
  const chatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
    Messages? _messages;
  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user:widget.user)));
      },
       child: StreamBuilder(
         stream: Api.getLastMessages(widget.user),
         builder: (context,snapshot){
           final data=snapshot.data?.docs;
           final list = data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
           //  log('Data : ${jsonEncode(data![0].data())}');
           if(list.isNotEmpty){
             _messages=list[0];
           }


           return  ListTile(
             //leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
             //for giving option to the user to change the profile
               leading: ClipRRect(
                 borderRadius: BorderRadius.circular(mq.height * .5),
                 child: CachedNetworkImage(
                   height:mq.height * .95,
                   width: mq.width * .055,
                   imageUrl: widget.user.images,
                   // placeholder: (context, url) => CircularProgressIndicator(),
                   errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
                 ),
               ),
               title: Text(widget.user.name) ,
               subtitle: Text(_messages != null ? _messages!.msg:widget.user.about,maxLines: 1,),
               trailing: _messages == null ?null :
              _messages!.read.isEmpty && _messages!.fromId != Api.users.uid ?

               Container(
                 width: 15,
                 height: 15,
                 decoration: BoxDecoration(color: Colors.greenAccent.shade400,borderRadius: BorderRadius.circular(10)),
               ):
                  Text(MyDate.getLastMsgTime(context: context, time: _messages!.sent),
                  )
             // trailing: Text('12:00 PM',style: TextStyle(color: Colors.black54),)
           );
         }
       )
    ),
    );
  }
}
