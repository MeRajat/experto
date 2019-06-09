import 'dart:async';

class Reload{
  final StreamController<bool> status = StreamController<bool>.broadcast();

  Stream get getStatus => status.stream;

  void updateStatus(bool newStatus){
    status.sink.add(newStatus);
  }

  void dispose(){
    status.close();
  }
}

final Reload userSearchSkill = Reload();
final Reload userSearchExpert = Reload();
final Reload userInteractions = Reload();
final Reload userSearchSkillExpertList = Reload();
final Reload expertInteractions = Reload();