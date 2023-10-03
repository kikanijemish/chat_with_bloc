import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String? sender;
  String? messageId;
  String? msg;
  bool?seen;
  Timestamp? createdOn;

  MessageModel({this.createdOn,this.msg,this.seen,this.sender,this.messageId});

  MessageModel.fromMap(Map<String,dynamic>map){
    sender=map["sender"];
    messageId=map["messageId"];
    msg=map["msg"];
    seen=map["seen"];
    createdOn=map["createdOn"];
  }
  Map<String,dynamic> toMap(){
    return {
      "sender":sender,
      "messageId":messageId,
      "msg":msg,
      "seen":seen,
      "createdOn":createdOn,
    };
  }
}