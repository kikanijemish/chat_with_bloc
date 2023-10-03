import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/main.dart';
import 'package:firebase_demo/model/cahtroom_model.dart';
import 'package:firebase_demo/model/message_model.dart';
import 'package:firebase_demo/model/user_model.dart';
import 'package:firebase_demo/ui/const/container_const.dart';
import 'package:firebase_demo/ui/const/text_field_const.dart';
import 'package:firebase_demo/utils/colors.dart';
import 'package:firebase_demo/utils/image_path_const.dart';
import 'package:firebase_demo/utils/text_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoomModel;

  const ChatPage(
      {super.key, required this.targetUser, required this.chatRoomModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  Size? size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: appBarConst(),
        ),
        body: bodyData(),
      ),
    );
  }

  Widget bodyData() {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatRooms")
                  .doc(widget.chatRoomModel.chatRoomId)
                  .collection("messages")
                  .orderBy("createdOn", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapShot =
                  snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    reverse: true,
                    itemCount: dataSnapShot.docs.length,
                    itemBuilder: (context, index) {
                      MessageModel currentMessage = MessageModel.fromMap(
                          dataSnapShot.docs[index].data()
                              as Map<String, dynamic>);
                      return messageContainerConst(currentMessage);
                    },
                  );
                }
                return textBold(text: "Error ocured", fontSize: 12);
              },
            ),
          ),
        ),
        messageFieldConst()
      ],
    );
  }

  Widget messageContainerConst(MessageModel messageModel){
    var user = FirebaseAuth.instance.currentUser!.uid.toString();
    log("key arae =-=-${user}");
    return
      Column(
      crossAxisAlignment: messageModel.sender==user? CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        ContainerConstWithoutHW(
          topPadding: 2,
          leftPadding:messageModel.sender==user?100:10,
          rightPadding:messageModel.sender==user?10:100,

          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              textRegular(text:messageModel.msg.toString(), fontSize: 14,fontColor: AppColors().whiteColor,topPadding:8,bottomPadding: 0,rightPadding: 20),
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textRegular(text:  DateFormat('hh:mm a').format(messageModel.createdOn!.toDate()), fontSize: 8,fontColor: AppColors().whiteColor,topPadding: 0,rightPadding: 2,leftPadding: 15),
                    Icon(Icons.done_all_outlined,color: AppColors().whiteColor,size: 10,)
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget messageFieldConst() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 10),
          child: Row(
            children: [
              Flexible(
                child: TextFormFieldConst(
                  hintText: "Type message...",
                  controller: messageController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send_outlined,
                        color: AppColors().primaryColor)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appBarConst() {
    return AppBar(
      backgroundColor: AppColors().primaryColor,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: widget.targetUser.profilePicture == ""
                ? const AssetImage(ImagePathConst.profileImage)
                : NetworkImage(widget.targetUser.profilePicture.toString())
                    as ImageProvider,
          ),
          textSemiBold(
              text: widget.targetUser.firstName.toString(),
              fontSize: 14,
              fontColor: AppColors().whiteColor,
              topPadding: 0)
        ],
      ),
    );
  }

  sendMessage() {
    String msg = messageController.text.trim();
    var user = FirebaseAuth.instance.currentUser!.uid.toString();
    var uid = uuid.v1obj();
    if (msg != "") {
      MessageModel messageModel = MessageModel(
          createdOn: Timestamp.now(),
          messageId: uid.toString(),
          msg: msg,
          seen: false,
          sender: user);

      FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(widget.chatRoomModel.chatRoomId)
          .collection("messages")
          .doc(uid.toString())
          .set(messageModel.toMap());
      
      widget.chatRoomModel.createdOn=Timestamp.now();
      widget.chatRoomModel.lastMessage=msg;
      FirebaseFirestore.instance.collection("chatRooms").doc(widget.chatRoomModel.chatRoomId).set(widget.chatRoomModel.toMap());
    }
    messageController.clear();
  }
}
