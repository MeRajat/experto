import 'dart:async';

class IsLoading{
  final StreamController<bool> status = StreamController<bool>.broadcast();

  Stream get getStatus => status.stream;

  void updateStatus(bool newStatus){
    status.sink.add(newStatus);
  }

  void dispose(){
    status.close();
  }
}

final IsLoading isLoadingLogin = IsLoading();
final IsLoading isLoadingSignup = IsLoading();
final IsLoading isLoadingSignupExpert = IsLoading();
final IsLoading isLoadingLoginExpert = IsLoading();
final IsLoading feedbackSubmission = IsLoading();
