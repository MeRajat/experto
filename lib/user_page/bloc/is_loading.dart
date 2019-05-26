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