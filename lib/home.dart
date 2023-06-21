

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chat/models/chat_user.dart';
import 'package:my_chat/profile_screen.dart';
import 'package:my_chat/widgets/chatUserCard.dart';
import 'apiFolder/api.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
   List<ChatApp> _list=[];
  final List<ChatApp> _searchlist=[];
  bool _isSearching =false;

   @override
  void initState() {
     super.initState();
    Api.getSelfInfo();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching=!_isSearching;
            });
            return Future.value(false);
          }
          else{
              return Future.value(true);
          }
        },
        child: Scaffold(

          appBar: AppBar(
            title: _isSearching ? TextFormField(
              decoration: InputDecoration(border: InputBorder.none,hintText: 'Write something here...'),
              autofocus: true,
              onChanged: (val){
                _searchlist.clear();
                for(var i in _list){
                  if(i.name.toLowerCase().contains(val.toLowerCase())||  i.email.toLowerCase().contains(val.toLowerCase())){
                        _searchlist.add(i);
                  }
                  setState(() {
                    _searchlist;
                  });

                }
              },
            ):Text('Messenger'),
            leading: const Icon(CupertinoIcons.home),
            actions: [
              IconButton(onPressed: () {
                  setState(() {

                    _isSearching=!_isSearching;
                  });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid :Icons.search)),
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>profile(user: Api.me)));
              }, icon: const Icon(Icons.more_vert))
            ],
          ),
          floatingActionButton: FloatingActionButton(onPressed: () async {
            await Api.auth.signOut();
            await GoogleSignIn().signOut();
          },
            child: const Icon(Icons.add_circle_rounded),
          ),
          body: StreamBuilder(
            stream: Api.getAllUsers(),
          builder: (context,snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:


                  final data=snapshot.data?.docs;
                _list = data?.map((e) => ChatApp.fromJson(e.data())).toList() ?? [];




               if(_list.isNotEmpty){
                 return ListView.builder(
                     itemCount: _isSearching? _searchlist.length:_list.length,
                     itemBuilder: (context,index){
                       return  chatUserCard(user: _isSearching? _searchlist[index]:_list[index]) ;
                       //return Text('Name,${list[index]}');
                     });
               }
               else{
                 return Center(
                   child:  Text('No user Found!!',style: TextStyle(fontSize: 20)),
                 );
               }
              }

            },
          ),
        ),
      ),
    );
  }


  }

