import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import "package:experto/utils/bloc/is_loading.dart";
import "package:experto/utils/bloc/loading_completed.dart";

class ValidateFeedback {
  int rating;
  String review;
  CollectionReference feedbackCollection;
  Feedback feedback;
  DocumentReference expertReference;

  ValidateFeedback(DocumentSnapshot expertSnapshot) {
    getexpert(expertSnapshot);
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

  void saveFeedback(GlobalKey<FormState> key) {
    print("starting saving");
    FormState feedbackFormState = key.currentState;
    if (feedbackFormState.validate()) {
      feedbackFormState.save();
      feedbackSubmission.updateStatus(true);
      feedbackCollection = Firestore.instance.collection('Feedback');
      Feedback feedback = new Feedback(
        rating: rating,
        review: review,
        expertReference: expertReference,
      );
      Firestore.instance.runTransaction((Transaction t) async {
        await feedbackCollection.add(feedback.toJson());
        feedbackFormState.reset();
        feedbackSubmissionCompleted.updateStatus(true);
      });
    }
  }
}

class Feedback {
  int rating;
  String review;
  DocumentReference expertReference;
  Feedback(
      {@required this.rating,
      @required this.review,
      @required this.expertReference});

  Map<String, dynamic> toJson() {
    return {"Rating": rating, "Review": review, "Expert": expertReference};
  }
}
