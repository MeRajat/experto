import 'dart:async';
import 'package:experto/user_authentication/userData.dart';

class SyncDocument{
  final StreamController<UserData> status = StreamController<UserData>.broadcast();

  Stream get getStatus => status.stream;

  void updateStatus(UserData newStatus){
    status.sink.add(newStatus);
  }

  void dispose(){
    status.close();
  }
}

final SyncDocument syncDocumentUser = SyncDocument();
final SyncDocument syncDocumentExpert = SyncDocument();
