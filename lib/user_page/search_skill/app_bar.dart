import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import "package:experto/utils/bloc/search_bloc.dart";
import "package:experto/utils/bloc/is_searching.dart";
import "package:experto/utils/global_app_bar.dart";

class CustomFlexibleSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(right: 17, left: 17, bottom: 20),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: SkillTextField(),
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      130,
      'Skill',
      CustomFlexibleSpace(),
      isFloating:true,
    );
  }
}

class SkillTextField extends StatefulWidget {
  @override
  _SkillTextField createState() => _SkillTextField();
}

class _SkillTextField extends State<SkillTextField> {
  static String initialValue = '';
  final TextEditingController _controller =
      TextEditingController(text: initialValue);
  final List results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void search(string) {
    initialValue = _controller.text;
    if (_controller.text == '') {
      isSearching.updateStatus(0);
      return;
    } else {
      searchBloc.updateResult(_controller.text.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: search,
      onSubmitted: search,
      style: TextStyle(fontSize: 17),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, size: 20),
        hintText: 'search by name',
      ),
    );
  }
}
