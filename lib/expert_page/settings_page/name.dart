import 'package:experto/global_data.dart';
import 'package:experto/utils/authentication_page_utils.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'Update.dart';
import 'package:experto/utils/bloc/syncDocuments.dart' as sync;

final Update update = new Update();

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<FocusNode> focusNode = List.generate(2, (_) => FocusNode());
  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    Data newExpert;
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    newExpert = await update.updateEmail(expert, key, context);
    if (newExpert != null) {
      expert = newExpert;
      sync.syncDocument.updateStatus(newExpert);
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated, Starting Logout...',
          leading: Icon(Icons.done, color: Colors.green, size: 23),
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
              AppbarContainer("Email"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                        (value) {
                          update.setPass(value);
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
                          update.setEmail(value);
                        },
                        focusNode: focusNode[1],
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
                  onPressed: () {
                    updateData(context);
                  },
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
                  child: Text("Submit"),
                ),
              ),
              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.height*.3)),
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
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<FocusNode> focusNode = List.generate(3, (_) => FocusNode());

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool stat = await update.updatePassword(expert, key, context);
    sync.syncDocument.updateStatus(expert);
    if (stat) {
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(Icons.done, color: Colors.green, size: 23),
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
                          update.setPass(value);
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
                          update.setNewPass(value);
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
                          update.setRetypedPass(value);
                        },
                        isPassword: true,
                        focusNode: focusNode[2],
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
                  onPressed: () {
                    updateData(context);
                  },
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
                  child: Text("Submit"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*.3),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Skype extends StatefulWidget {
  @override
  _SkypeState createState() => _SkypeState();
}

class _SkypeState extends State<Skype> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<FocusNode> focusNode = List.generate(2, (_) => FocusNode());

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool stat = await update.updateField(expert, "SkypeUser", key, context);
    sync.syncDocument.updateStatus(expert);
    if (stat) {
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(Icons.done, color: Colors.green, size: 23),
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
              AppbarContainer("Skype"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                        (value) {
                          update.setPass(value);
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
                        "Enter new Skype username",
                        (value) {
                          update.setSkype(value);
                        },
                        focusNode: focusNode[1],
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 5),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
                child: RaisedButton(
                  onPressed: () {
                    updateData(context);
                  },
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
                  child: Text("Submit"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*.3),
              )
            ],
          );
        },
      ),
    );
  }
}

class City extends StatefulWidget {
  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<City> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<FocusNode> focusNode = List.generate(2, (_) => FocusNode());

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool stat = await update.updateField(expert, "City", key, context);
    sync.syncDocument.updateStatus(expert);
    if (stat) {
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(Icons.done, color: Colors.green, size: 23),
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
              AppbarContainer("City"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                        (value) {
                          update.setPass(value);
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
                        "Enter new City",
                        (value) {
                          update.setCity(value);
                        },
                        focusNode: focusNode[1],
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 5),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
                child: RaisedButton(
                  onPressed: () {
                    updateData(context);
                  },
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
                  child: Text("Submit"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*.3),
              )
            ],
          );
        },
      ),
    );
  }
}

class Description extends StatefulWidget {
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<FocusNode> focusNode = List.generate(2, (_) => FocusNode());

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool stat = await update.updateField(expert, "Description", key, context);
    sync.syncDocument.updateStatus(expert);
    if (stat) {
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(Icons.done, color: Colors.green, size: 23),
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
              AppbarContainer("Description"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                        (value) {
                          update.setPass(value);
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
                        "Enter new Discription",
                        (value) {
                          update.setDescription(value);
                        },
                        inputType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: null,
                        maxLength: 150,
                        initailValue: expert.detailsData["Description"],
                        inputAction: TextInputAction.newline,
                        focusNode: focusNode[1],
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 5),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
                child: RaisedButton(
                  onPressed: () {
                    updateData(context);
                  },
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
                  child: Text("Submit"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*.3),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WorkExperience extends StatefulWidget {
  @override
  _WorkExperienceState createState() => _WorkExperienceState();
}

class _WorkExperienceState extends State<WorkExperience> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<FocusNode> focusNode = List.generate(2, (_) => FocusNode());

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool stat =
        await update.updateField(expert, "Work Experience", key, context);
    sync.syncDocument.updateStatus(expert);
    if (stat) {
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(Icons.done, color: Colors.green, size: 23),
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
              AppbarContainer("Work Experience"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                        (value) {
                          update.setPass(value);
                        },
                        isPassword: true,
                        focusNode: focusNode[0],
                        nextTextField: focusNode[1],
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 30, bottom: 5),
                    ),
                    Padding(
                      /*child: InputField(
                        "Enter new City",
                            (value) {
                          update.setCity(value);
                        },
                      ),*/
                      child: InputField(
                        "Enter Work Experience",
                        (value) {
                          update.setWorkExperience(value);
                        },
                        inputType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: null,
                        maxLength: 250,
                        initailValue: expert.detailsData['Work Experience'],
                        inputAction: TextInputAction.newline,
                        focusNode: focusNode[1],
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 5),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
                child: RaisedButton(
                  onPressed: () {
                    updateData(context);
                  },
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
                  child: Text("Submit"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*.3),
              ),
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
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  List<FocusNode> focusNode = List.generate(2, (_) => FocusNode());

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData(context) async {
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    bool status = await update.deleteAccount(expert, key, context);
    if (status) {
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(Icons.done, color: Colors.green, size: 23),
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
              AppbarContainer("Delete Account"),
              Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: InputField(
                        "Enter password for confirmation",
                        (value) {
                          update.setPass(value);
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
                          update.setEmail(value);
                        },
                        focusNode: focusNode[1],
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
                  onPressed: () {
                    updateData(context);
                  },
                  color: Theme.of(context).errorColor,
                  child: Text("Delete Account"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*.3),
              ),
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
        ));
  }
}
