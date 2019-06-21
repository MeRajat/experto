import 'dart:async';
import 'package:experto/global_data.dart';

class SyncDocument {
  final StreamController<Data> status = StreamController<Data>.broadcast();

  Stream get getStatus => status.stream;

  void updateStatus(newStatus) {
    status.sink.add(newStatus);
  }

  void dispose() {
    status.close();
  }
}

final SyncDocument syncDocument = SyncDocument();
