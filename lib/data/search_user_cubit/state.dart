import '../../model/user_model.dart';

abstract class SearchUserState{}

class SearchLoadingState extends SearchUserState{}

class SearchInitialState extends SearchUserState{}

class UserSuccessState extends SearchUserState{
  UserModel userModel;
  UserSuccessState(this.userModel);

}

class SearchSuccessState extends SearchUserState{
  List<UserModel> userList;
  UserModel currentUserModel;
  SearchSuccessState(this.userList,this.currentUserModel);
}

class SearchEmptyState extends SearchUserState{}

