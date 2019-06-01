import 'dart:async';

class IsSearching{
  final StreamController<int> status = StreamController<int>.broadcast();

  Stream get getStatus => status.stream;

  void updateStatus(int newStatus){
    status.sink.add(newStatus);
  }

  void dispose(){
    status.close();
  }
}

final IsSearching isSearching = IsSearching();
final IsSearching isSearchingExpert = IsSearching();