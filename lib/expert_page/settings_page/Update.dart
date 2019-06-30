import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/utils/bloc/is_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:experto/global_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as Im;

class Update {
  CollectionReference expertReference;
  Map<String, dynamic> details;
  String retypedPass, newPass;
  Update() {
    //_isSignIn = false;
    details = {
      "Name": "",
      "password": "",
      "emailID": "",
      "Skypeexpert": "",
      "City": "",
      "Mobile": '',
      "Description": "",
      "Work Experience": ''
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

  setPass(String x) => details['password'] = x;

  setRetypedPass(String x) => retypedPass = x;

  setNewPass(String x) => newPass = x;

  setCity(String x) => details['City'] = x;

  setSkype(String x) => details['Skypeexpert'] = x;

  getMobile(String x) => details['Mobile'] = x;

  setEmail(String x) => details['emailID'] = x;

  setDescription(String x) => details['Description'] = x;

  setWorkExperience(String x) => details['Work Experience'] = x;

  Future<bool> updatePassword(
      Data expert, GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try {
        if (newPass.compareTo(retypedPass) != 0) {
          throw ("Passwords don't match!");
        } else if (newPass.compareTo(details['password']) == 0) {
          throw ("New Password cannot be same as old!");
        }
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: expert.profileData.email, password: details['password']);
        await expert.profileData.updatePassword(newPass);
        expert.profileData=await FirebaseAuth.instance.currentUser();
        return true;
      } catch (e) {
        print(e);
        _ackAlert(
            context,
            "SignUp Failed!",
            e == "Passwords don't match!" ||
                    e == "New Password cannot be same as old!"
                ? e
                : "Old password is incorrect!");
        return false;
      }
    }
    return false;
  }

  Future<Data> updateEmail(
      Data expert, GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: expert.profileData.email, password: details['password']);
        if (details['emailID'].compareTo(expert.profileData.email) == 0) {
          throw ("New Email cannot be same as old!");
        }
        await expert.profileData.updateEmail(details['emailID']);
        expert.profileData=await FirebaseAuth.instance.currentUser();
        await expert.detailsData.reference.updateData({'emailID': details['emailID']});
        expert.detailsData =await expert.detailsData.reference.get();
        return expert;
      } catch (e) {
        print(e);
        _ackAlert(
            context,
            "SignUp Failed!",
            e == "New Email cannot be same as old!"
                ? e
                : "Old password is incorrect!");
        return null;
      }
    }
    return null;
  }

  Future<bool> updateField(Data expert, String field,
      GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: expert.profileData.email, password: details['password']);
        print("Before update: " + field + ": " + expert.detailsData.data[field]);
        if (details[field].compareTo(expert.detailsData.data[field]) == 0) {
          throw ("New " + field + "cannot be same as old!");
        }
        Firestore.instance.runTransaction((Transaction t) async {
          await expert.detailsData.reference.updateData({field: details[field]});
        });
        expert.detailsData =await expert.detailsData.reference.get();
        expert.profileData.sendEmailVerification();
        return true;
      } on PlatformException catch (e) {
        if (e.code == "ERROR_WRONG_PASSWORD") {
          _ackAlert(context, "Update Failed", "Incorrect Password entered");
          return false;
        }
        throw e;
      } catch (e) {
        print(e);
        _ackAlert(context, "Update Failed!", e);
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteAccount(
      Data expert, GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      isLoadingLogin.updateStatus(true);
      Future.delayed(Duration(seconds: 5));
      formState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: expert.profileData.email, password: details['password']);
        await expert.profileData.delete();
        //await expert.profileData.reload();
        await expertReference.document(expert.detailsData.documentID).delete();
        return true;
      } catch (e) {
        print(e);
        _ackAlert(
            context,
            "SignUp Failed!",
            e == "New Email cannot be same as old!"
                ? e
                : "Old password is incorrect!");
        return false;
      }
    }
    return false;
  }


  Future<Data> updateProfilePic(Data expert) async {
    StorageUploadTask task,task2;
    UserUpdateInfo expertUpdateInfo=new UserUpdateInfo();
    String path = await FilePicker.getFilePath(type: FileType.IMAGE);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("/Expert Profile Photos/" + expert.profileData.uid),storageReference2 = FirebaseStorage.instance
        .ref()
        .child("/Expert Profile Photos/thumbs/" + expert.profileData.uid);
    print(storageReference.getPath().then((x) => print(x)));
    File file = File(path);
    Im.Image image = Im.decodeImage(file.readAsBytesSync());
    if(image.height>2800&&image.width>2800)
      image=Im.copyResizeCropSquare(image, 2800);
    else if(image.height>2800||image.height>image.width)
      image=Im.copyResizeCropSquare(image, image.width);
    else if(image.width>2800||image.width>image.height)
      image=Im.copyResizeCropSquare(image, image.height);
    Im.Image thumbnail = Im.copyResize(image, width: 500);
    task2=storageReference2.putData( Im.encodeJpg(thumbnail,quality: 75));
    task=storageReference.putData(Im.encodeJpg(image,quality: 95));
    await task.onComplete;
    await task2.onComplete;
    String url = await storageReference.getDownloadURL(),url2=await storageReference2.getDownloadURL();
    expertUpdateInfo.photoUrl=url;
    await expert.profileData.updateProfile(expertUpdateInfo);
    expert.profileData=await FirebaseAuth.instance.currentUser();
    await expertReference.document(expert.detailsData.documentID).updateData({'profilePic': url,'profilePicThumb': url2});
    expert.detailsData = await expertReference.document(expert.detailsData.documentID).get();
    return expert;
  }
}
