import 'dart:async';

class LoadingCompleted{
  final StreamController<bool> status = StreamController<bool>.broadcast();

  Stream get getStatus => status.stream;

  void updateStatus(bool newStatus){
    status.sink.add(newStatus);
  }

  void dispose(){
    status.close();
  }
}


final LoadingCompleted feedbackSubmissionCompleted = LoadingCompleted();
