import 'package:experto/expert_authentication/expertData.dart';
import 'package:experto/utils/authentication_page_utils.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'Update.dart';
import 'package:experto/utils/bloc/syncDocuments.dart';

final Update update=new Update();

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  ExpertData expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = ExpertDocumentSync.of(context).expert;
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
    expert=await update.updateEmail(expert,key,context);
    if(expert!=null)
      syncDocumentUser.updateStatusExpert(expert);
    setState(() {
      showAuthSnackBar(
        context: context,
        title: expert!=null?'Updated':"Error",
        leading: Icon(expert!=null?Icons.done:Icons.error, color: Colors.green, size: 23),
        persistant: false,
      );
    });
    if(expert!=null)
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              Hero(
                  child:AppbarContainer("Email"),
                  tag:"settingEmail"
              ),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                            (value) {update.getPass(value);},
                        isPassword: true,
                      ),
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 30,
                      ),
                    ),
                    Padding(
                      child: InputField(
                        "Enter new email",
                            (value) {update.getEmail(value);},
                      ),
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                child: RaisedButton(
                  onPressed: updateData,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue[800]
                      : Colors.blue,
                  child: Text("Submit"),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  ExpertData expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = ExpertDocumentSync.of(context).expert;
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
    bool stat=await update.updatePassword(expert,key,context);
    syncDocumentUser.updateStatusExpert(expert);
    setState(() {
      showAuthSnackBar(
        context: context,
        title: stat?'Updated':"Error",
        leading: Icon(stat?Icons.done:Icons.error, color: Colors.green, size: 23),
        persistant: false,
      );
    });
    if(stat)
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              Hero(
                  child:AppbarContainer("Password"),
                  tag:"settingPassword"
              ),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter previouw password",
                            (value) {update.getPass(value);},
                        isPassword: true,
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 30, bottom: 5),
                    ),
                    Padding(
                      child: InputField(
                        "Enter new passowrd",
                            (value) {update.getPass(value);},
                        isPassword: true,
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 5),
                    ),
                    Padding(
                      child: InputField(
                        "Confirm passowrd",
                            (value) {update.getPass(value);},
                        isPassword: true,
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 20),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                child: RaisedButton(
                  onPressed: updateData,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue[800]
                      : Colors.blue,
                  child: Text("Submit"),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  ExpertData expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = ExpertDocumentSync.of(context).expert;
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
    bool status=await update.deleteAccount(expert,key,context);
    setState(() {
      showAuthSnackBar(
        context: context,
        title: status?'Updated':"Error",
        leading: Icon(status?Icons.done:Icons.error, color: Colors.green, size: 23),
        persistant: false,
      );
    });
    if(status)
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              Hero(
                  child:AppbarContainer("Delete Account"),
                  tag:"settingDelete Account"
              ),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                            (value) {update.getPass(value);},
                        isPassword: true,
                      ),
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 30,
                      ),
                    ),
                    Padding(
                      child: InputField(
                        "Enter email for confirmation",
                            (value) {update.getEmail(value);},
                      ),
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                child: RaisedButton(
                  onPressed: updateData,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.red[800]
                      : Colors.red,
                  child: Text("Delete Account"),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class AppbarContainer extends StatelessWidget {
  final String title;

  AppbarContainer(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 180,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).appBarTheme.color,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(title, style: Theme.of(context).textTheme.title),
      ),
    );
  }
}
