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
  bool updating = false;

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      updating = true;
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    user = await update.updateName(context, user, key);
    syncDocument.updateStatus(user);
    setState(() {
      updating = false;
      showAuthSnackBar(
        context: context,
        title: 'Uploaded',
        leading: Icon(Icons.done, color: Colors.green, size: 23),
        persistant: false,
      );
    });
    await Future.delayed(Duration(milliseconds: 800));
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
              AppbarContainer("Name"),
              Form(
                key: key,
                child: Padding(
                  child: InputField(
                    "Enter new name",
                    (value) {
                      update.getName(value);
                    },
                    inputAction: TextInputAction.done,
                        func: () {
                          updateData(context);
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
                child: (updating)
                    ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))
                    : RaisedButton(
                        onPressed: () {
                          updateData(context);
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
              ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * .1),
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
  List<FocusNode> focusNode = List.generate(2, (_) => FocusNode());
  bool updating = false;

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    Data newUser;
    setState(() {
      updating = true;
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    newUser = await update.updateEmail(user, key, context);
    setState(() {
      updating = false;
    });
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
      await Future.delayed(Duration(milliseconds: 700));
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
              AppbarContainer("Email"),
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
                        focusNode: focusNode[0],
                        nextTextField: focusNode[1],
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
                        focusNode: focusNode[1],
                        inputAction: TextInputAction.done,
                        func: () {
                          updateData(context);
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
                child: (updating)
                    ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))
                    : RaisedButton(
                        onPressed: () {
                          updateData(context);
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
              ),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * .1)),
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
  List<FocusNode> focusNode = List.generate(3, (_) => FocusNode());
  bool updating = false;

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      updating = true;
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool stat = await update.updatePassword(user, key, context);
    syncDocument.updateStatus(user);
    setState(() {
      updating = false;
    });
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
      await Future.delayed(Duration(milliseconds: 800));
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
              AppbarContainer("Password"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter previous password",
                        (value) {
                          update.getPass(value);
                        },
                        isPassword: true,
                        focusNode: focusNode[0],
                        nextTextField: focusNode[1],
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
                        focusNode: focusNode[1],
                        nextTextField: focusNode[2],
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
                        focusNode: focusNode[2],
                        inputAction: TextInputAction.done,
                        func: () {
                          updateData(context);
                        },
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 20),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                child: (updating)
                    ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))
                    : RaisedButton(
                        onPressed: () {
                          updateData(context);
                        },
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue[800]
                            : Colors.blue,
                        child: Text("Submit",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .body2
                                .copyWith(color: Colors.white)),
                      ),
              ),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * .1)),
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
  List<FocusNode> focusNode = List.generate(2, (_) => FocusNode());
  bool updating = false;

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      updating = true;
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool status = await update.deleteAccount(user, key, context);
    setState(() {
      updating = false;
    });
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
      await Future.delayed(Duration(milliseconds: 800));
      logOut(context);
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
              AppbarContainer("Delete Account"),
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
                        focusNode: focusNode[0],
                        nextTextField: focusNode[1],
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
                        focusNode: focusNode[1],
                        inputAction: TextInputAction.done,
                        func: () {
                          updateData(context);
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
                child: (updating)
                    ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).errorColor),
                      )
                    : RaisedButton(
                        onPressed: () {
                          updateData(context);
                        },
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.red[800]
                            : Colors.red,
                        child: Text("Delete Account",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .body2
                                .copyWith(color: Colors.white)),
                      ),
              ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * .1),
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
    return Hero(
      tag: "setting" + title,
      child: Container(
        padding: EdgeInsets.all(20),
        height: 180,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).appBarTheme.color,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(title, style: Theme.of(context).textTheme.title),
        ),
      ),
    );
  }
}
