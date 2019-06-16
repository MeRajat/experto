import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:experto/user_authentication/userData.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:experto/utils/bloc/syncDocuments.dart';

class ProfilePicUpdate extends StatefulWidget {
  @override
  _ProfilePicUpdateState createState() => _ProfilePicUpdateState();
}

class _ProfilePicUpdateState extends State<ProfilePicUpdate> {
  DocumentSnapshot user;
  StorageTaskSnapshot taskSnapshot;
  StorageUploadTask task;
  
  @override
  didChangeDependencies() {
    user = UserDocumentSync.of(context).user;
    print(user['profilePic']);
    super.didChangeDependencies();
  }
  
  Future<void> imagePick() async {
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    print(path);
    StorageReference storageReference =
    FirebaseStorage.instance.ref().child("/Profile Photos/" + user["emailID"]);
    print(storageReference.getPath().then((x) => print(x)));
    File file = File(path);
    task = storageReference.putFile(file);
    String url = await storageReference.getDownloadURL();
    Firestore.instance
        .collection("Users")
        .document(user.documentID)
        .updateData({'profilePic': url});
    print("uploaded");
    user = await user.reference.get();
    syncDocumentUser.updateStatus(user);
    setState(() {

    });
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
          child: user['profilePic'] == null
              ? Icon(
                  Icons.person,
                  size: 110,
                )
              : taskSnapshot == null || taskSnapshot.error == 0
              ? CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                        width: 350.0,
                        height: 350.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                  imageUrl: user['profilePic'],
                  placeholder: (context, a) => CircularProgressIndicator(),
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
