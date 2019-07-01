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

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    super.didChangeDependencies();
  }

  Future<void> updateData() async {
    Data newExpert;
    setState(() {
      showAuthSnackBar(
        context: context,
        title: "Updating...",
        leading: Icon(Icons.file_upload, size: 23, color: Colors.green),
      );
    });
    newExpert = await update.updateEmail(expert, key, context);
    if (expert != null) {
      expert = newExpert;
      sync.syncDocument.updateStatus(newExpert);
      setState(() {
        showAuthSnackBar(
          context: context,
          title: 'Updated',
          leading: Icon(Icons.done, color: Colors.green, size: 23),
          persistant: false,
        );
      });
      //Navigator.of(context).pop();
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
              Hero(child: AppbarContainer("Email"), tag: "settingEmail"),
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
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
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
                        "Enter previous password",
                        (value) {
                          update.setPass(value);
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
                          update.setNewPass(value);
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
                          update.setRetypedPass(value);
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
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
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

class Skype extends StatefulWidget {
  @override
  _SkypeState createState() => _SkypeState();
}

class _SkypeState extends State<Skype> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
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
              Hero(child: AppbarContainer("Skype"), tag: "settingSkype"),
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
                  onPressed: updateData,
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
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

class City extends StatefulWidget {
  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<City> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
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
              Hero(child: AppbarContainer("City"), tag: "settingCity"),
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
                  onPressed: updateData,
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
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

class Description extends StatefulWidget {
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
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
                  child: AppbarContainer("Description"),
                  tag: "settingDescription"),
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
                  onPressed: updateData,
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
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

class WorkExperience extends StatefulWidget {
  @override
  _WorkExperienceState createState() => _WorkExperienceState();
}

class _WorkExperienceState extends State<WorkExperience> {
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
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
                  child: AppbarContainer("Work Experience"),
                  tag: "settingWorkExperience"),
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
                  onPressed: updateData,
                  // color: Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.blue[800]
                  //     : Colors.blue,
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
  Data expert;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
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
                          update.setPass(value);
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
                          update.setEmail(value);
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
                  color: Theme.of(context).errorColor,
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
