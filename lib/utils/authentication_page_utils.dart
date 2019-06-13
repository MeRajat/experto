import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

class InputField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final bool isPassword;
  final void Function(String) fn;
  final int minLines, maxLines, maxLength;
  final TextInputAction inputAction;

  InputField(
    this.hintText,
    this.fn, {
    this.inputType: TextInputType.text,
    this.isPassword: false,
    this.minLines: 1,
    this.maxLines: 2,
    this.inputAction: TextInputAction.next,
    this.maxLength: 0,
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
            validator: (value) {
              if (value.isEmpty) {
                return 'please enter this field';
              }
              if (maxLength != 0 && value.length > maxLength) {
                return 'max length exceeded';
              }
            },
            onSaved: (input) => fn(input),
            textInputAction: inputAction,
            keyboardType: inputType,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: (maxLength == 0) ? null : maxLength,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              filled: true,
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

  CustomFlatButton({
    @required this.text,
    @required this.onPressedFunction,
    this.color: Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
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

void showAuthSnackBar({
  @required BuildContext context,
  @required String title,
  @required leading,
}) {
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
                child: Text(
                  title,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body2
                      .copyWith(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
          padding: EdgeInsets.all(5),
        ),
      ),
      duration: Duration(hours: 1),
    ),
  );
}

class SignupTimeSelector extends StatelessWidget {
  final Function callbackFunc;
  final String headingText, slot;
  final Color selector1Color, selector2Color;
  final Map<String, Map<String, DateTime>> availablity;

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
    String timeStart = (availablity == null ||
            availablity[slot]['start'] == null)
        ? "Start"
        : '${availablity[slot]['start'].hour.toString()}:${availablity[slot]['start'].minute.toString()}';

    String timeEnd = (availablity == null || availablity[slot]['end'] == null)
        ? "End"
        : '${availablity[slot]['end'].hour.toString()}:${availablity[slot]['end'].minute.toString()}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          headingText,
          style: Theme.of(context)
              .primaryTextTheme
              .body2
              .copyWith(color: Colors.white),
        ),
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
                ? "Required"
                : skillsSelected[correspondingSkill]['name']),
            style:
                Theme.of(context).primaryTextTheme.body2.copyWith(color: color))
      ],
    );
  }
}
