abstract class AuthState{}

class LoadState extends AuthState{}

class SuccessState extends AuthState{
  String uid;
  SuccessState(this.uid);
}
class initialState extends AuthState{}
class ErrorState extends AuthState{
  String error;
  ErrorState(this.error);
}