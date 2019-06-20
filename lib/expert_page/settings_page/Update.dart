import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/utils/bloc/is_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:experto/expert_authentication/expertData.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Update{
  CollectionReference expertReference;
  Map<String, dynamic> details;
  Update(){
    //_isSignIn = false;
    details = {
      "name": "",
      "passowrd": "",
      "email": "",
      "skypeUsername": "",
      "city": "",
      "mobile": '',
      "description": "",
      "workExp": ''
    };
    getExpert();
  }
  getExpert() async {
    expertReference = Firestore.instance.collection("Experts");
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

  getName(String x) => details['name'] = x;

  getPass(String x) => details['password'] = x;

  getCity(String x) => details['city'] = x;

  getSkype(String x) => details['skypeUsername'] = x;

  getMobile(String x) => details['mobile'] = x;

  getEmail(String x) => details['email'] = x;

  getDescription(String x) => details['description'] = x;

  getWorkExperience(String x) => details['workExp'] = x;

  Future<bool> updatePassword(ExpertData expert,GlobalKey<FormState> _formKey,BuildContext context) async{
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try{
        if(details[1].compareTo(details[2])!=0){throw("Passwords don't match!");}
        else if(details[1].compareTo(details[0])==0){throw("New Password cannot be same as old!");}
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: expert.profileData.email, password: details[0]);
        await expert.profileData.updatePassword(details[1]);
        await expert.profileData.reload();
        return true;
      }
      catch(e){
        print(e);
        _ackAlert(
            context,
            "SignUp Failed!",e=="Passwords don't match!"||e=="New Password cannot be same as old!"?e:"Old password is incorrect!");
        return false;
      }
    }
    return false;
  }

  Future<ExpertData> updateEmail(ExpertData expert,GlobalKey<FormState> _formKey,BuildContext context) async{
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: expert.profileData.email, password: details[0]);
        if(details[1].compareTo(expert.profileData.email)==0){throw("New Email cannot be same as old!");}
        await expert.profileData.updateEmail(details[1]);
        await expert.profileData.reload();
        await expertReference.document(expert.detailsData.documentID).updateData({'emailID':details[1]});
        expert.detailsData=await expertReference.document(expert.detailsData.documentID).get();
        return expert;
      }
      catch(e){
        print(e);
        _ackAlert(
            context,
            "SignUp Failed!",e=="New Email cannot be same as old!"?e:"Old password is incorrect!");
        return null;
      }
    }
    return null;
  }

  Future<bool> deleteAccount(ExpertData expert,GlobalKey<FormState> _formKey,BuildContext context) async{
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: expert.profileData.email, password: details[0]);
        await expert.profileData.delete();
        //await user.profileData.reload();
        await expertReference.document(expert.detailsData.documentID).delete();
        return true;
      }
      catch(e){
        print(e);
        _ackAlert(
            context,
            "SignUp Failed!",e=="New Email cannot be same as old!"?e:"Old password is incorrect!");
        return false;
      }
    }
    return false;
  }

  Future<ExpertData> updateProfilePic(ExpertData expert) async {
    StorageUploadTask task;
    UserUpdateInfo userUpdateInfo=new UserUpdateInfo();
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    print(path);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("/Profile Photos/" + expert.detailsData["emailID"]);
    print(storageReference.getPath().then((x) => print(x)));
    File file = File(path);
    task=storageReference.putFile(file);
    await task.onComplete;
    String url = await storageReference.getDownloadURL();
    userUpdateInfo.photoUrl=url;
    await expert.profileData.updateProfile(userUpdateInfo);
    await expertReference.document(expert.detailsData.documentID).updateData({'profilePic': url});
    expert.detailsData = await expertReference.document(expert.detailsData.documentID).get();
    return expert;
  }

}