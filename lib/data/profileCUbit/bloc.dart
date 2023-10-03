import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/data/profileCUbit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/user_model.dart';

class ProfileCubit extends Cubit<ProfileState>{
  ProfileCubit(): super(initialState());

  updateProfile(UserModel userModel,uid) async {
    emit(LoadingState());
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "firstName":userModel.firstName,
      "lastName":userModel.lastName,
      "mobNumber":userModel.mobNumber,
      "profilePicture":userModel.profilePicture,
      "gender":userModel.gender,
      "age":userModel.age,
    }).then((value) async {
      DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel=UserModel.fromMap(snapshot.data() as Map<String,dynamic>);
      emit(ProfileSuccessState(userModel));
    });
  }

}