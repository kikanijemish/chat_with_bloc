import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{

  String? uid;
  String? firstName;
  String? lastName;
  String? age;
  String? gender;
  String? mobNumber;
  String? email;
  String? profilePicture;
  String?status;
  Timestamp? createdOn;

  UserModel({this.lastName,this.firstName,this.age,this.uid,this.status,this.gender,this.mobNumber,this.createdOn,this.email,this.profilePicture});

  UserModel.fromMap(Map<String,dynamic>map){
    uid=map["uid"];
    firstName=map["firstName"];
    lastName=map["lastName"];
    age=map["age"];
    gender=map["gender"];
    mobNumber=map["mobNumber"];
    email=map["email"];
    profilePicture=map["profilePicture"];
    status=map["status"];
    createdOn=map["createdOn"];
  }

  Map<String,dynamic> toMap(){
    return{
      "uid":uid,
      "firstName":firstName,
      "lastName":lastName,
      "age":age,
      "gender":gender,
      "mobNumber":mobNumber,
      "email":email,
      "profilePicture":profilePicture,
      "status":status,
      "createdOn":createdOn,
    };
  }
}