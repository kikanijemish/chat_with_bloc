import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/data/chat_room_cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../../model/cahtroom_model.dart';
import '../../model/user_model.dart';
import '../../sahared_preference/shared_preference_data.dart';
import '../../sahared_preference/shared_preference_key.dart';

class ChatRoomCubit extends Cubit<ChatRoomState>{
  ChatRoomCubit():super(ChatRoomInitialState());



  Future<ChatRoomModel?> getChatRoom(UserModel targetUser) async {
    var Cuid = SharedPrefsData().getStringData(SharedPrefsKey.authKey)!;
    var uid = uuid.v1();
    log(Cuid);
    log("${targetUser.uid.toString()}");
emit(ChatRoomLoadingState());
    try{

      QuerySnapshot dataSnapShot = await FirebaseFirestore.instance
          .collection("chatRooms")
          .where("particepate.${Cuid}", isEqualTo: true)
          .where("particepate.${targetUser.uid}", isEqualTo: true)
          .get();
      log("length of docsa are=-=-${dataSnapShot.docs.length}");

      if (dataSnapShot.docs.length > 0) {
        log("existing");
        ChatRoomModel existingChatRoom = ChatRoomModel.fromMap(
            dataSnapShot.docs[0].data() as Map<String, dynamic>);
        emit(ChatRoomSuccessState(existingChatRoom));
        return existingChatRoom;
      } else {
        log("new chat room");

        ChatRoomModel newChatRoom = ChatRoomModel(
            createdOn: Timestamp.now(),
            chatRoomId: uid,
            particepate: {Cuid: true, "${targetUser.uid}": true});
        await FirebaseFirestore.instance
            .collection("chatRooms")
            .doc(uid)
            .set(newChatRoom.toMap());
emit(ChatRoomSuccessState(newChatRoom));
        return newChatRoom;
      }

    }catch(e){
      emit(ChatRoomErrorState());
    }


  }
}