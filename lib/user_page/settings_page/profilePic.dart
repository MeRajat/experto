import 'package:cached_network_image/cached_network_image.dart';
import 'package:experto/user_authentication/userData.dart';
import 'package:experto/user_page/settings_page/Update.dart';
import 'package:experto/utils/authentication_page_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/utils/bloc/syncDocuments.dart';

class ProfilePicUpdate extends StatefulWidget {
  @override
  _ProfilePicUpdateState createState() => _ProfilePicUpdateState();
}

class _ProfilePicUpdateState extends State<ProfilePicUpdate> {
  DocumentSnapshot user;
  bool uploading;
  final Update update=new Update();

  @override
  void initState() {
    uploading = false;
    super.initState();
  }

  @override
  didChangeDependencies() {
    user = UserDocumentSync.of(context).user;
    print(user['profilePic']);
    super.didChangeDependencies();
  }

  Future<void > updateData()async{
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    user= await update.updateProfilePic(user);
    syncDocumentUser.updateStatus(user);
    setState(() {
      showAuthSnackBar(
        context: context,
        title: 'Uploaded',
        leading: Icon(Icons.done, color: Colors.green, size: 23),
        persistant: false,
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: updateData,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: uploading == true
            ? CircularProgressIndicator()
            : Hero(
                tag: "profilePic",
                child: user['profilePic'] == null
                    ? Icon(
                        Icons.person,
                        size: 110,
                      )
                    :  CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                                  width: 350.0,
                                  height: 350.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                            imageUrl: user['profilePic'],
                            placeholder: (context, a) =>
                                CircularProgressIndicator(),
                          ),
              ),
      ),
    );
  }
}