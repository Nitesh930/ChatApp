
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/auth/login.dart';
import 'package:my_chat/helper/my_date.dart';

import '../apiFolder/api.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);
  final Messages  message;

  @override
  State<MessageCard> createState() => _MessageState();
}

class _MessageState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return  Api.users.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }
  Widget _blueMessage(){
    if(widget.message.read.isEmpty){
      Api.updateMsgReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child:
            Container(
              padding: EdgeInsets.all(mq.width *.04),
              margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
              decoration: BoxDecoration(color: Colors.blue.shade100,border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30))),

              child:
              Text(widget.message.msg,style: const TextStyle(fontSize: 15,color: Colors.black87),
              )
              ),
            ),

        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
    MyDate.getFormattedTime(context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13,color: Colors.black54),),
        )
      ],
    );
  }
  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width * .04 ),
            if(widget.message.read.isNotEmpty)
            Icon(Icons.done_all_rounded,color: Colors.blue,size: 19,),
            SizedBox(width:2),
            Text(MyDate.getFormattedTime(context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13,color: Colors.black54),),
          ],
        ),
        Flexible(
          child:
          Container(
            padding: EdgeInsets.all(mq.width *.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(color: Colors.lightGreen.shade100,border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),

            child:

            Text(widget.message.msg,style: const TextStyle(fontSize: 15,color: Colors.black87),
            )

            ),
          ),
      ],
    );
  }
}
