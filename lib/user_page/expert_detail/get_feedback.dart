import 'dart:async';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import "package:experto/utils/bloc/is_loading.dart";
import "package:experto/utils/bloc/loading_completed.dart";
import "package:experto/user_authentication/userData.dart";

class ValidateFeedback {
  int rating;
  String review;
  bool submiting = false, submitted = false, updatedPreviousFeedback = false;
  CollectionReference feedbackCollection;
  QuerySnapshot feedbackSnapshot;
  Feedback feedback;
  DocumentReference expertReference;

  ValidateFeedback(DocumentSnapshot expertSnapshot) {
    getexpert(expertSnapshot);
  }

  Future<void> _ackAlert(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget submitButton(
      GlobalKey<FormState> feedbackFormKey, BuildContext context) {
    if (submitted) {
      return Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle, size: 25),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: (updatedPreviousFeedback)
                  ? Text("We have updated your response")
                  : Text("Your response is captured"),
            ),
          ],
        ),
      );
    }
    if (submiting) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (!submiting || !submitted) {
      return Padding(
        child: SizedBox(
          child: RaisedButton(
            onPressed: () {
              saveFeedback(feedbackFormKey, context);
            },
            child: Text("Submit",),
            elevation: 5,
            highlightElevation: 5,
            color: (Theme.of(context).brightness == Brightness.dark)
                ? Color.fromRGBO(42, 123, 249, 1)
                : Colors.blue,
          ),
        ),
        padding: EdgeInsets.only(
          left: 14,
          right: 14,
          bottom: 40,
        ),
      );
    } else {
      return Container();
    }
  }

  void getRating(int providedRating) {
    rating = providedRating;
    print(rating);
  }

  void getReview(String providedReview) {
    review = providedReview;
  }

  void getexpert(DocumentSnapshot expertSnapshot) {
    expertReference = expertSnapshot.reference;
  }

  void saveFeedback(GlobalKey<FormState> key, BuildContext context) async {
    FormState feedbackFormState = key.currentState;
    UserData user = UserDocumentSync.of(context).user;
    if (feedbackFormState.validate()) {
      feedbackFormState.save();
      submiting = true;
      feedbackSubmission.updateStatus(true);
      try {
        feedbackCollection = Firestore.instance.collection("Feedback");
        Feedback feedback = new Feedback(
          rating: rating,
          review: review,
          expertReference: expertReference,
          userReference: user.detailsData.reference,
        );
        await Firestore.instance
            .collection("Feedback")
            .where("User", isEqualTo: user.detailsData.reference)
            .where("Expert", isEqualTo: expertReference)
            .getDocuments()
            .timeout(Duration(seconds: 10), onTimeout: () {
          throw TimeoutException;
        }).catchError((e) {
          throw TimeoutException;
        }).then((QuerySnapshot feedbackSnapshot) async {
          if (feedbackSnapshot.documents.length == 0) {
            updatedPreviousFeedback = false;
            await Firestore.instance.runTransaction((Transaction t) async {
              await feedbackCollection.add(feedback.toJson());
            });
          } else {
            updatedPreviousFeedback = true;
            await feedbackSnapshot.documents[0].reference.updateData(
              feedback.toJson(),
            );
          }
        });

        submitted = true;
        feedbackSubmissionCompleted.updateStatus(true);
      } catch (e) {
        _ackAlert(context, "Feedback Falied", e.toString().split(',')[1]);
        submitted = false;
        feedbackSubmissionCompleted.updateStatus(false);
      } finally {
        feedbackFormState.reset();
        submiting = false;
        feedbackSubmission.updateStatus(false);
      }
    }
  }
}

class Feedback {
  int rating;
  String review;
  DocumentReference expertReference;
  DocumentReference userReference;
  Feedback({
    @required this.rating,
    @required this.review,
    @required this.expertReference,
    @required this.userReference,
  });

  Map<String, dynamic> toJson() {
    return {
      "Rating": rating,
      "Review": review,
      "Expert": expertReference,
      "User": userReference,
    };
  }
}
