import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/utils/bloc/is_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:experto/user_authentication/userData.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Update{
  CollectionReference userReference;
  List<String> details;
  Update(){
    //_isSignIn = false;
    details = new List<String>();
    getUser();
  }
  getUser() async {
    userReference = Firestore.instance.collection("Users");
  }

  getName(String x) => details.add(x);
  getPass(String x) => details.add(x);
  getCity(String x) => details.add(x);
  getMobile(String x) => details.add(x);
  getEmail(String x) => details.add(x);
  Future<DocumentSnapshot> updateName(DocumentSnapshot user,GlobalKey<FormState> _formKey) async{
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try{
        UserUpdateInfo userUpdateInfo=new UserUpdateInfo();
        userUpdateInfo.displayName=details[0];
        await UserData.usr.updateProfile(userUpdateInfo);
        await UserData.usr.reload();
        print(user);
        await userReference.document(user.documentID).updateData({"Name":details[0]});
        user=await userReference.document(user.documentID).get();
      }
      catch(e){}
    }
    return user;
  }
  Future<DocumentSnapshot> updateProfilePic(DocumentSnapshot user) async {
    StorageUploadTask task;
    UserUpdateInfo userUpdateInfo=new UserUpdateInfo();
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    print(path);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("/Profile Photos/" + user["emailID"]);
    print(storageReference.getPath().then((x) => print(x)));
    File file = File(path);
    task=storageReference.putFile(file);
    await task.onComplete;
    String url = await storageReference.getDownloadURL();
    userUpdateInfo.photoUrl=url;
    await UserData.usr.updateProfile(userUpdateInfo);
    await userReference.document(user.documentID).updateData({'profilePic': url});
    user = await userReference.document(user.documentID).get();
    return user;
  }
}