import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:experto/user_authentication/userAdd.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePicUpdate extends StatefulWidget {
  @override
  _ProfilePicUpdateState createState() => _ProfilePicUpdateState();
}

class _ProfilePicUpdateState extends State<ProfilePicUpdate> {
  Future<void> imagePick() async {
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    print(path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("/Profile Photos");
    print(storageReference.getPath().then((x) => print(x)));
    File file = File(path);
    storageReference.putFile(file).onComplete;
    String url = await storageReference.getDownloadURL();
    Firestore.instance
        .collection("Users")
        .document(UserData.currentUser.documentID)
        .updateData({'profilePic': url});
    UserData.currentUser = await Firestore.instance
        .collection("Users")
        .document(UserData.currentUser.documentID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: imagePick,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: "profilePic",
          child: UserData.currentUser['profilePic'] == null
              ? Icon(
                  Icons.person,
                  size: 110,
                )
              : CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                        width: 350.0,
                        height: 350.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                  imageUrl: UserData.currentUser['profilePic'],
                  placeholder: (context, a) => CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
