import 'package:firebase_demo/model/user_model.dart';

abstract class ProfileState{}

class LoadingState extends ProfileState{}
class initialState extends ProfileState{}

class ProfileSuccessState extends ProfileState{
  final UserModel userModel;
  ProfileSuccessState(this.userModel);
}

class ErrorState extends ProfileState{}