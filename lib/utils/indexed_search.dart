import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> getQuerySet(CollectionReference doc, String searchQuery,List<DocumentSnapshot> querySetResult,List tempResult) async {
  QuerySnapshot searchSnapshot = await doc
      .where("Index", isEqualTo: searchQuery.toUpperCase())
      .getDocuments()
      .timeout(Duration(seconds: 10), onTimeout: () {
  });

  
  searchSnapshot.documents.forEach((snapshot) {
    querySetResult.add(snapshot);
    tempResult.add(snapshot);
  });
}
