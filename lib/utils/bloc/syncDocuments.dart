import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class SyncDocument{
  final StreamController<DocumentSnapshot> status = StreamController<DocumentSnapshot>.broadcast();

  Stream get getStatus => status.stream;

  void updateStatus(DocumentSnapshot newStatus){
    status.sink.add(newStatus);
  }

  void dispose(){
    status.close();
  }
}

final SyncDocument syncDocumentUser = SyncDocument();
final SyncDocument syncDocumentExpert = SyncDocument();
