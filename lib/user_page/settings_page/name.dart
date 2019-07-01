import 'package:experto/utils/authentication_page_utils.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'Update.dart';
import 'package:experto/utils/bloc/syncDocuments.dart';
import 'package:experto/global_data.dart';

final Update update = new Update();

class Name extends StatefulWidget {
  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  Data user;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData() async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    user = await update.updateName(context, user, key);
    syncDocument.updateStatus(user);
    setState(() {
      showAuthSnackBar(
        context: context,
        title: 'Uploaded',
        leading: Icon(Icons.done, color: Colors.green, size: 23),
        persistant: false,
      );
    });
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
              Hero(child: AppbarContainer("Name"), tag: "settingName"),
              Form(
                key: key,
                child: Padding(
                  child: InputField(
                    "Enter new name",
                    (value) {
                      update.getName(value);
                    },
                  ),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                    bottom: 20,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                child: RaisedButton(
                  onPressed: () {
                    updateData();
                  },
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
                  child: Text("Submit",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body2
                          .copyWith(color: Colors.white)),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  Data user;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData() async {
    Data newUser;
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    newUser = await update.updateEmail(user, key, context);
    if (newUser != null) {
      user = newUser;
      syncDocument.updateStatus(newUser);
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(
            Icons.done,
            color: Colors.green,
            size: 23,
          ),
          persistant: false,
        );
      });
      await logOut(context);
    }
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
              Hero(child: AppbarContainer("Email"), tag: "settingEmail"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                        (value) {
                          update.getPass(value);
                        },
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
                        (value) {
                          update.getEmail(value);
                        },
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
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
                  child: Text("Submit",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body2
                          .copyWith(color: Colors.white)),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Passowrd extends StatefulWidget {
  @override
  _PassowrdState createState() => _PassowrdState();
}

class _PassowrdState extends State<Passowrd> {
  Data user;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData() async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool stat = await update.updatePassword(user, key, context);
    syncDocument.updateStatus(user);
    if (stat == true) {
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(
            Icons.done,
            color: Colors.green,
            size: 23,
          ),
          persistant: false,
        );
      });
      Navigator.of(context).pop();
    }
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
              Hero(child: AppbarContainer("Password"), tag: "settingPassword"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter previouw password",
                        (value) {
                          update.getPass(value);
                        },
                        isPassword: true,
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 30, bottom: 5),
                    ),
                    Padding(
                      child: InputField(
                        "Enter new passowrd",
                        (value) {
                          update.getPass(value);
                        },
                        isPassword: true,
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 5),
                    ),
                    Padding(
                      child: InputField(
                        "Confirm passowrd",
                        (value) {
                          update.getPass(value);
                        },
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
                  child: Text("Submit",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body2
                          .copyWith(color: Colors.white)),
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
  Data user;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData() async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool status = await update.deleteAccount(user, key, context);
    if (status) {
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Done',
          leading: Icon(
            Icons.done,
            color: Colors.green,
            size: 23,
          ),
          persistant: false,
        );
      });
      Navigator.of(context).pop();
    }
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
                  child: AppbarContainer("Delete Account"),
                  tag: "settingDelete Account"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                        (value) {
                          update.getPass(value);
                        },
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
                        (value) {
                          update.getEmail(value);
                        },
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
                  child: Text("Delete Account",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body2
                          .copyWith(color: Colors.white)),
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
