import 'package:firebase_demo/model/cahtroom_model.dart';

abstract class ChatRoomState{}

class ChatRoomLoadingState extends ChatRoomState{}
class ChatRoomInitialState extends ChatRoomState{}
class ChatRoomSuccessState extends ChatRoomState{
  ChatRoomModel chatRoomModel;
  ChatRoomSuccessState(this.chatRoomModel);
}
class ChatRoomErrorState extends ChatRoomState{}