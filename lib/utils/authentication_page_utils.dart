import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:experto/home_page/home_page.dart";

class InputField extends StatelessWidget {
  final String hintText, initailValue;
  final TextInputType inputType;
  final bool isPassword;
  final void Function(String) fn;
  final int minLines, maxLines, maxLength;
  final TextInputAction inputAction;
  final FocusNode nextTextField, focusNode;

  InputField(
    this.hintText,
    this.fn, {
    this.inputType: TextInputType.text,
    this.isPassword: false,
    this.minLines: 1,
    this.maxLines: 2,
    this.inputAction: TextInputAction.next,
    this.maxLength: 0,
    this.initailValue: '',
    this.focusNode,
    this.nextTextField,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.only(left: 13, right: 13, top: 13, bottom: 13),
          child: TextFormField(
            obscureText: isPassword,
            focusNode: focusNode,
            initialValue: initailValue,
            textInputAction: inputAction,
            keyboardType: inputType,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: (maxLength == 0) ? null : maxLength,
            onSaved: (input) => fn(input),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              filled: true,
              //fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: -.6,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'please enter this field';
              }
              if (maxLength != 0 && value.length > maxLength) {
                return 'max length exceeded';
              }
            },
            onFieldSubmitted: (nextTextField == null)
                ? null
                : (_) {
                    FocusScope.of(context).requestFocus(nextTextField);
                  },
          ),
        ),
      ),
    );
  }
}

class CustomFlatButton extends StatelessWidget {
  final String text;
  final onPressedFunction;
  final Color color;

  CustomFlatButton(
      {@required this.text, @required this.onPressedFunction, this.color});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(
            color: (color == null)
                ? Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black
                : color),
      ),
      onPressed: onPressedFunction,
    );
  }
}

class SignupPageRedirect extends StatelessWidget {
  final String text;
  final String redirectLink;
  final Function callback;

  SignupPageRedirect({
    @required this.text,
    @required this.redirectLink,
    @required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          top: 15,
        ),
        child: Row(
          children: <Widget>[
            Text(text,
                style: Theme.of(context)
                    .primaryTextTheme
                    .body2
                    .copyWith(fontSize: 12)),
            InkWell(
              onTap: callback,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  redirectLink,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body2
                      .copyWith(fontSize: 12, color: Colors.blue),
                ),
              ),
            ),
          ],
        ));
  }
}

void showAuthSnackBar(
    {@required BuildContext context,
    @required String title,
    @required leading,
    bool persistant: true}) {
  try {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black87,
        content: Align(
          alignment: Alignment.centerLeft,
          heightFactor: 1,
          child: Padding(
            child: Row(
              children: <Widget>[
                leading,
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 130,
                    child: Text(
                      title,
                      softWrap: true,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body2
                          .copyWith(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.all(5),
          ),
        ),
        duration: (persistant) ? Duration(hours: 1) : Duration(seconds: 3),
      ),
    );
  } catch (e) {}
}

class SignupTimeSelector extends StatelessWidget {
  final Function callbackFunc;
  final String headingText, slot;
  final Color selector1Color, selector2Color;
  final Map availablity;

  SignupTimeSelector({
    @required this.callbackFunc,
    @required this.headingText,
    @required this.slot,
    @required this.availablity,
    this.selector1Color: Colors.blue,
    this.selector2Color: Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    String timeStart = (availablity == null || availablity['start'] == null)
        ? "Start"
        : '${availablity['start'].toDate().hour.toString()}:${availablity['start'].toDate().minute.toString()}';

    String timeEnd = (availablity == null || availablity['end'] == null)
        ? "End"
        : '${availablity['end'].toDate().hour.toString()}:${availablity['end'].toDate().minute.toString()}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          headingText,
          style: Theme.of(context)
              .primaryTextTheme
              .body2
              .copyWith(color: Colors.grey[400]),
        ),
        Padding(padding: EdgeInsets.only(left: 20)),
        CustomFlatButton(
          text: timeStart,
          color: selector1Color,
          onPressedFunction: () {
            callbackFunc(slot, 'start');
          },
        ),
        CustomFlatButton(
          text: timeEnd,
          color: selector2Color,
          onPressedFunction: () {
            callbackFunc(slot, 'end');
          },
        ),
      ],
    );
  }
}

class SignupSkillSelector extends StatelessWidget {
  final Map<String, Map<String, dynamic>> skillsSelected;
  final Function callbackFunc;
  final Color color;
  final String correspondingSkill;

  SignupSkillSelector({
    @required this.skillsSelected,
    @required this.callbackFunc,
    @required this.correspondingSkill,
    this.color: Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CustomFlatButton(
          text: "Select Skill",
          onPressedFunction: callbackFunc,
        ),
        Text(
            (skillsSelected[correspondingSkill]['name'] == ''
                ? (correspondingSkill == 'skill1') ? "Required" : "Optional"
                : skillsSelected[correspondingSkill]['name']),
            style:
                Theme.of(context).primaryTextTheme.body2.copyWith(color: color))
      ],
    );
  }
}

Future<void> logOut(BuildContext context) async {
  showAuthSnackBar(
    context: context,
    title: "Logging Out...",
    leading: CircularProgressIndicator(),
  );

  final pref = await SharedPreferences.getInstance();
  await pref.setString("account_type", null);

  await Future.delayed(Duration(seconds: 2));
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (buildContext) => HomePage()),
        ModalRoute.withName(':'));
  } catch (e) {
    showAuthSnackBar(
      context: context,
      title: "Error...",
      leading: Icon(Icons.error, size: 23, color: Colors.green),
    );
  }
}
