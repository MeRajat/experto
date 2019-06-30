import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/utils/bloc/is_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:experto/global_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as Im;

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

  Future<void> _ackAlert(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getName(String x) => details.add(x);
  getPass(String x) => details.add(x);
  getCity(String x) => details.add(x);
  getMobile(String x) => details.add(x);
  getEmail(String x) => details.add(x);

  Future<Data> updateName(BuildContext context,Data user,GlobalKey<FormState> _formKey) async{
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try{
        UserUpdateInfo userUpdateInfo=new UserUpdateInfo();
        userUpdateInfo.displayName=details[0];
        await user.profileData.updateProfile(userUpdateInfo);
        user.profileData=await FirebaseAuth.instance.currentUser();
        await user.detailsData.reference.updateData({"Name":details[0]});
        user.detailsData=await user.detailsData.reference.get();
      }
      catch(e){
        _ackAlert(
            context,
            "Update Failed!","An error occured while updating name!");}
    }
    return user;
  }

  Future<bool> updatePassword(Data user,GlobalKey<FormState> _formKey,BuildContext context) async{
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try{
        if(details[1].compareTo(details[2])!=0){throw("Passwords don't match!");}
        else if(details[1].compareTo(details[0])==0){throw("New Password cannot be same as old!");}
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.profileData.email, password: details[0]);
        await user.profileData.updatePassword(details[1]);
        user.profileData=await FirebaseAuth.instance.currentUser();
        return true;
      }
      catch(e){
        _ackAlert(
            context,
            "Update Failed!",e=="Passwords don't match!"||e=="New Password cannot be same as old!"?e:"Old password is incorrect!");
        return false;
      }
    }
    return false;
  }

  Future<Data> updateEmail(Data user,GlobalKey<FormState> _formKey,BuildContext context) async{
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.profileData.email, password: details[0]);
        if(details[1].compareTo(user.profileData.email)==0){throw("New Email cannot be same as old!");}
        await user.profileData.updateEmail(details[1]);
        user.profileData=await FirebaseAuth.instance.currentUser();
//        await userReference.document(user.detailsData.documentID).updateData({'emailID':details[1]});
//        user.detailsData=await userReference.document(user.detailsData.documentID).get();
        return user;
      }
      catch(e){
        _ackAlert(
            context,
            "Update Failed!",e=="New Email cannot be same as old!"?e:"Old password is incorrect!");
        return null;
      }
    }
    return null;
  }

  Future<bool> deleteAccount(Data user,GlobalKey<FormState> _formKey,BuildContext context) async{
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.profileData.email, password: details[0]);
        await user.profileData.delete();
        //user.profileData=await FirebaseAuth.instance.currentUser();
        await userReference.document(user.detailsData.documentID).delete();
        return true;
      }
      catch(e){
        _ackAlert(
            context,
            "Delete Failed!","Old password is incorrect!");
        return false;
      }
    }
    return false;
  }


  Future<Data> updateProfilePic(Data user) async {
    StorageUploadTask task,task2;
    UserUpdateInfo userUpdateInfo=new UserUpdateInfo();
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("/Profile Photos/" + user.profileData.uid),storageReference2 = FirebaseStorage.instance
        .ref()
        .child("/Profile Photos/thumbs/" + user.profileData.uid);
    print(storageReference.getPath().then((x) => print(x)));
    print(storageReference2.getPath().then((x) => print(x)));
    File file = File(path);
    Im.Image image = Im.decodeImage(file.readAsBytesSync());
    Im.Image thumbnail = Im.copyResizeCropSquare(image, 600);
//    var compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(thumbnail, quality: 100);
    task2=storageReference2.putData( Im.encodeJpg(thumbnail,quality: 85));
    task=storageReference.putFile(file);
    await task.onComplete;
    print("task");
    await task2.onComplete;
    print("task2");
    String url = await storageReference.getDownloadURL(),url2=await storageReference2.getDownloadURL();
    userUpdateInfo.photoUrl=url;
    await user.profileData.updateProfile(userUpdateInfo);
    user.profileData=await FirebaseAuth.instance.currentUser();
    await userReference.document(user.detailsData.documentID).updateData({'profilePic': url,'profilePicThumb': url2});
    user.detailsData = await userReference.document(user.detailsData.documentID).get();
    return user;
  }

}

//  Future<Data> updateProfilePic(Data user) async {
//    StorageUploadTask task;
//    UserUpdateInfo userUpdateInfo=new UserUpdateInfo();
//    StorageReference storageReference = FirebaseStorage.instance
//        .ref()
//        .child("/Profile Photos/" + user.profileData.uid),storageReference2 = FirebaseStorage.instance
//        .ref()
//        .child("/Profile Photos/thumbs" + user.profileData.uid);
//    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
//    task=storageReference.putFile(file);
//    await task.onComplete;
//    String url = await storageReference.getDownloadURL();
//    userUpdateInfo.photoUrl=url;
//    await user.profileData.updateProfile(userUpdateInfo);
//    user.profileData=await FirebaseAuth.instance.currentUser();
//    await userReference.document(user.detailsData.documentID).updateData({'profilePic': url});
//    user.detailsData = await userReference.document(user.detailsData.documentID).get();
//    return user;
//  }
//
//}