import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/model/user_model.dart';

class GetUserModel{

  UserModel?userModel;

  Future<UserModel?> getModel(String uid)async{

    DocumentSnapshot dtaSnapShot=await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(dtaSnapShot!=null){
      userModel=await UserModel.fromMap(dtaSnapShot.data()as Map<String,dynamic> );}
    return userModel;

  }
}