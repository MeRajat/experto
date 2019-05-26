import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String name,email,city;

  User({
    @required this.name,
    @required this.email,
    @required this.city,
  });

  Map<String, dynamic> toJson() =>
      {
        'Name':name,
        'emailID':email,
        'city':city,
      };

}