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
      isFloating: true,
    );
  }
}

class ExpertTextField extends StatefulWidget {
  @override
  _ExpertTextField createState() => _ExpertTextField();
}

class _ExpertTextField extends State<ExpertTextField> {
  static String initialValue = '';
  final TextEditingController _controller =
      TextEditingController(text: initialValue);
  final List results = [];
  bool isSearchingStatus;

  @override
  void initState() {
    getSearchingStatus();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getSearchingStatus() async {
    isSearchingExpert.getStatus.listen((value) {
      if (value != isSearchingStatus) {
        setState(() {
          isSearchingStatus = value;
        });
      }
    });
  }

  void search(string) {
    initialValue = _controller.text;
    if (_controller.text == '') {
      isSearchingExpert.updateStatus(false);
    } else {
      isSearchingExpert.updateStatus(true);
      expertSearchBloc.updateResult(_controller.text.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(primaryColor: Theme.of(context).accentColor),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: search,
        style: TextStyle(fontSize: 17),
        onSubmitted: search,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            size: 20,
          ),
          suffixIcon: (isSearchingStatus)
              ? InkWell(
                  onTap: () {
                    _controller.clear();
                    isSearchingExpert.updateStatus(false);
                  },
                  child: Icon(
                    CupertinoIcons.clear_thick_circled,
                  ),
                )
              : null,
          hintText: 'search by name',
        ),
      ),
    );
  }
}
