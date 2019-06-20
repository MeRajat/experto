import 'dart:async';
import 'package:experto/user_authentication/userData.dart';
import 'package:experto/expert_authentication/expertData.dart';

class SyncDocument{
  final StreamController<UserData> statusUser = StreamController<UserData>.broadcast();
  final StreamController<ExpertData> statusExpert = StreamController<ExpertData>.broadcast();

  Stream get getStatusUser => statusUser.stream;
  Stream get getStatusExpert => statusExpert.stream;

  void updateStatusUser(UserData newStatus){
    statusUser.sink.add(newStatus);
  }
  
  void updateStatusExpert(ExpertData newStatus) {
    statusExpert.sink.add(newStatus);
  }

  void dispose(){
    statusUser.close();
    statusExpert.close();
  }
}

final SyncDocument syncDocumentUser = SyncDocument();
final SyncDocument syncDocumentExpert = SyncDocument();
