import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

import '../bloc/search_bloc.dart';
import '../bloc/is_searching.dart';
import 'package:experto/global_app_bar.dart';

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
            child: ExpertTextField(),
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
      'Expert',
      CustomFlexibleSpace(),
      isFloating:true,
    );
  }
}

class ExpertTextField extends StatefulWidget {
  final List experts = [
    'Pravin Gupta',
    'Rahul Saini',
    'Anand Panwal',
    'Himanshu Pandey',
    'Nihal Sharma',
    'Rahul Gupta',
    'Dhruv Khosla',
  ];

  @override
  _ExpertTextField createState() => _ExpertTextField();
}

class _ExpertTextField extends State<ExpertTextField> {
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
      isSearchingExpert.updateStatus(0);
      return;
    } else {
      expertSearchBloc.updateResult(_controller.text.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: search,
      style: TextStyle(fontSize: 17),
      onSubmitted: search,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, size: 20,),
        hintText: 'search by name',
      ),
    );
  }
}
