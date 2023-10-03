import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/data/search_user_cubit/state.dart';
import 'package:firebase_demo/model/get_user_model_const.dart';
import 'package:firebase_demo/model/user_model.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_data.dart';
import 'package:firebase_demo/sahared_preference/shared_preference_key.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  SearchUserCubit() : super(SearchInitialState());

  List<UserModel> allUSerList = [];
  List<UserModel> searchedUserList = [];
  UserModel? userModel;

  getAllUser() async {
    allUSerList.clear();
    emit(SearchLoadingState());

    log("list are  empty");
    String uid = SharedPrefsData().getStringData(SharedPrefsKey.authKey)!;
    userModel = (await GetUserModel().getModel(uid))!;
    emit(UserSuccessState(userModel!));
    log("firet name are =-=-${userModel!.firstName.toString()}");
    QuerySnapshot dataSnapShot =
        await FirebaseFirestore.instance.collection("users").get();
    if (dataSnapShot.docs.length == 0) {
      emit(SearchEmptyState());
    } else {
      log("list are not empty");
      for (int i = 0; i < dataSnapShot.docs.length; i++) {
        UserModel model = UserModel.fromMap(
            dataSnapShot.docs[i].data() as Map<String, dynamic>);
        if (model.uid == userModel!.uid) {
        } else {
          allUSerList.add(model);
        }
      }
      searchedUserList = allUSerList;
      emit(SearchSuccessState(searchedUserList, userModel!));
    }
  }

  getSearchedUser(String userName) {
    if (userName == "") {
      searchedUserList = allUSerList;
      emit(SearchSuccessState(searchedUserList, userModel!));
    } else {
      searchedUserList = allUSerList
          .where((user) =>
              user.firstName!.toLowerCase().contains(userName.toLowerCase()))
          .toList();
      emit(SearchSuccessState(searchedUserList, userModel!));
    }
  }
}
