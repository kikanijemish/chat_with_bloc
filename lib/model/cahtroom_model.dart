import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel{
   String? chatRoomId;
   String? lastMessage;
   Map<String,dynamic>? particepate;
   Timestamp? createdOn;
   ChatRoomModel({this.createdOn,this.chatRoomId,this.particepate,this.lastMessage});

   ChatRoomModel.fromMap(Map<String,dynamic> map){
     chatRoomId=map["chatRoomId"];
     particepate=map["particepate"];
     createdOn=map["createdOn"];
     lastMessage=map["lastMessage"];
   }

   Map<String,dynamic> toMap(){
     return {
       "chatRoomId":chatRoomId,
       "particepate":particepate,
       "createdOn":createdOn,
       "lastMessage":lastMessage,
     };
   }

}