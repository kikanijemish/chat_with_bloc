abstract class LoginState{}

class LoginLoadingState extends LoginState{}
class LoginInitialState extends LoginState{}

class LoginSSuccessState extends LoginState{
  String uid;
  LoginSSuccessState(this.uid);

}

class LoginErrorState extends LoginState{
  String error;
  LoginErrorState(this.error);
}