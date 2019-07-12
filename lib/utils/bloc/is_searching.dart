import 'dart:async';

import 'package:rxdart/subjects.dart';

class IsSearching{
  final BehaviorSubject<bool> status = BehaviorSubject<bool>.seeded(false);

  Stream get getStatus => status.stream;

  void updateStatus(bool newStatus){
    status.sink.add(newStatus);
  }

  void dispose(){
    status.close();
  }
}

final IsSearching isSearching = IsSearching();
final IsSearching isSearchingExpert = IsSearching();