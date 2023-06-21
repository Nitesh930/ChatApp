import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_chat/models/chat_user.dart';
import 'package:my_chat/models/message.dart';

class Api{
  static FirebaseAuth auth= FirebaseAuth.instance;

  static FirebaseFirestore firestore= FirebaseFirestore.instance;
  static FirebaseStorage storage= FirebaseStorage.instance;
  static late ChatApp me;
  static User get users => auth.currentUser!;
  static Future<bool> userExists() async{
return(await firestore.collection('users').doc(users.uid).get()).exists;
  }
  static Future<void> getSelfInfo() async{
    await firestore.collection('users').doc(users.uid).get().then((users) async {
            if(users.exists){
              me=ChatApp.fromJson(users.data()!);
            }
            else{
              await createUser().then((value) =>getSelfInfo() );
            }
    });
  }



  static Future<void> createUser() async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatApp(images: users.photoURL.toString(), about: 'I am a developer', name: users.displayName.toString(),
        createdAt: time, isOnline: false, id: users.uid, lastActive: time, pushToken: '', email: users.email.toString());
    return await firestore
        .collection('users')
        .doc(users.uid)
        .set(chatUser.toJson());


  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users').where('id',isNotEqualTo: users.uid).snapshots();
  }
  static Future<void> updateUsersInfo() async {
   await firestore.collection('users').doc(users.uid).update({
     'name':me.name,
     'about':me.about
   });
  }
  static Future<void> updateProfilePicture(File file)async {
    final ext=file.path.split('.').last;
    log('extension: $ext');
      final ref = storage.ref().child('profilePicture/${users.uid}.$ext');
      await ref
          .putFile(file,SettableMetadata(contentType: 'image/$ext'))
          .then((p0){
        log('data transferred: ${p0.bytesTransferred / 1000} kb');
      });
      me.images= await ref.getDownloadURL();
    await firestore.collection('users').doc(users.uid).update({
      'images':me.images
    });
  }

  static String getCoversationId(String id)=> users.uid.hashCode <= id.hashCode
      ?'${users.uid}_$id'
      :'${id}_${users.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatApp user){
    return firestore
        .collection('chats/${getCoversationId(user.id)}/messages')
        .snapshots();
  }

  static Future<void> sendMessage(ChatApp Chatuser, String msg,Type type) async{
    final time =DateTime.now().millisecondsSinceEpoch.toString();

    final Messages message=   Messages(msg: msg, toId: Chatuser.id, read: '', type: type, sent: time, fromId: users.uid);

    final ref=
        firestore.collection('chats/${getCoversationId(Chatuser.id)}/messages');
      await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMsgReadStatus(Messages messages) async{
    firestore.collection(
        'chats/${getCoversationId(messages.fromId)}/messages')
        .doc(messages.sent)
        .update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }

    static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(ChatApp user){
    return firestore
        .collection('chats/${getCoversationId(user.id)}/messages')
    .orderBy('sent',descending: true)
      .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatApp chatUser,File file) async {
    final ext=file.path.split('.').last;

    final ref = storage.ref().child('images/${getCoversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file,SettableMetadata(contentType: 'image/$ext'))
        .then((p0){
      log('data transferred: ${p0.bytesTransferred / 1000} kb');
    });
    final imageUrl= await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);

  }
}
