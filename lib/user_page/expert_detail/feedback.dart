import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import "package:experto/utils/bloc/is_loading.dart";
import "package:experto/utils/bloc/loading_completed.dart";
import './get_feedback.dart';

class Feedback extends StatelessWidget {
  final DocumentSnapshot expert;

  Feedback(this.expert);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeedbackForm(expert),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  final List<String> rating = ["Bad", "Fair", "Good", "Very Good", "Excellent"];
  final DocumentSnapshot expert;
  FeedbackForm(this.expert);
  @override
  _FeedbackForm createState() => _FeedbackForm();
}

class _FeedbackForm extends State<FeedbackForm> {
  int rating = 5;
  GlobalKey<FormState> feedbackFormKey = GlobalKey();
  ValidateFeedback providedFeedback;
  bool submiting = false, submitted = false;

  @override
  void dispose() {
    //feedbackSubmission.dispose();
    super.dispose();
  }

  @override
  void initState() {
    listenSubmission();
    listenSubmissionCompleted();
    providedFeedback = ValidateFeedback(widget.expert);
    super.initState();
  }

  void listenSubmission() async {
    feedbackSubmission.getStatus.listen((status) {
      if (status == true) {
        setState(() {
          submiting = true;
        });
      }
    });
  }

  void listenSubmissionCompleted() async {
    feedbackSubmissionCompleted.getStatus.listen((status) {
      if (status == true) {
        setState(() {
          submitted = true;
        });
      }
    });
  }

  Widget submitButton() {
    if (submitted) {
      return Padding(
        padding: EdgeInsets.only(bottom:40),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle, size: 25),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Your response is captured"),
            ),
          ],
        ),
      );
    }
    if (!submiting) {
      return Padding(
        child: SizedBox(
          child: RaisedButton(
            onPressed: () {
              providedFeedback.saveFeedback(feedbackFormKey);
            },
            child: Text("Submit", style: TextStyle(color: Colors.black)),
            elevation: 3,
            highlightElevation: 3,
            color: Colors.blueAccent,
          ),
        ),
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 40,
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: feedbackFormKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              color: Theme.of(context).appBarTheme.color,
              padding: EdgeInsets.only(left: 25, top: 50, bottom: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Feedback",
                  style:
                      Theme.of(context).textTheme.title.copyWith(fontSize: 35),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, top: 30, bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "How do you rate this expert ?",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body2
                      .copyWith(fontSize: 15),
                ),
              ),
            ),
            FormField(onSaved: (int value) {
              providedFeedback.getRating(rating);
            }, builder: (key) {
              return SizedBox(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: 5,
                  ),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Radio(
                            value: index + 1,
                            groupValue: rating,
                            onChanged: (value) {
                              setState(() {
                                rating = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          widget.rating[index],
                          style: Theme.of(context)
                              .primaryTextTheme
                              .body1
                              .copyWith(
                                  fontSize: 11,
                                  color: Color.fromRGBO(120, 120, 120, 1)),
                        ),
                      ],
                    );
                  },
                  itemCount: 5,
                ),
              );
            }),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 40, top: 20),
              child: Material(
                borderRadius: BorderRadius.circular(5),
                child: TextFormField(
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body2
                      .copyWith(letterSpacing: .4),
                  onSaved: (String review) {
                    providedFeedback.getReview(review);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter this field';
                    }
                  },
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Any appreciation or Improvement suggestion?",
                  ),
                  maxLines: null,
                  minLines: 15,
                ),
              ),
            ),
            submitButton(),
          ],
        ));
  }
}
