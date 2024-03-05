import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/quiz_model.dart';
import 'package:online_college/model/quiz_question_model.dart';

class QuizFireStore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addQuizQuestionToFireStore(
      {required BuildContext context, required QuizQuestionModel quizQuestionModel}) async {
    try {
      await firestore
          .collection('quizQuestions')
          .doc(quizQuestionModel.qqid)
          .set(quizQuestionModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Quiz Question Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateQuizQuestionAtFireStore(
      {required BuildContext context, required QuizQuestionModel quizQuestionModel}) async {
    try {
      await firestore
          .collection('quizQuestions')
          .doc(quizQuestionModel.qqid)
          .update(quizQuestionModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Quiz Question Edited');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteQuizQuestionFromFireStore(
      {required BuildContext context, required String qqid}) async {
    try {
      await firestore.collection('quizQuestions').doc(qqid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Quiz Question Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<QuizQuestionModel>> getQuizQuestionListFromFireStore(
      {required BuildContext context}) async {
    try {
      return (await firestore.collection('quizQuestions').get())
          .docs
          .map((e) => QuizQuestionModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<QuizQuestionModel?> getQuizQuestionFromFireStore(
      {required BuildContext context, required String qqid}) async {
    try {
      return QuizQuestionModel.fromJson(
          (await firestore.collection('quizQuestions').doc(qqid).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }

  Future<void> addQuizToFireStore(
      {required BuildContext context, required QuizModel quizModel}) async {
    try {
      await firestore.collection('quizzes').doc(quizModel.qid).set(quizModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Quiz Added');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> updateQuizAtFireStore(
      {required BuildContext context, required QuizModel quizModel}) async {
    try {
      await firestore.collection('quizzes').doc(quizModel.qid).update(quizModel.toJson());

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Quiz Edited');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<void> deleteQuizFromFireStore({required BuildContext context, required String qid}) async {
    try {
      await firestore.collection('quizzes').doc(qid).delete();

      if (!context.mounted) return;
      Utils().showToast(context: context, message: 'Quiz Deleted');
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }
  }

  Future<List<QuizModel>> getQuizListFromFireStore({required BuildContext context}) async {
    try {
      return (await firestore.collection('quizzes').get())
          .docs
          .map((e) => QuizModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return [];
  }

  Future<QuizModel?> getQuizFromFireStore(
      {required BuildContext context, required String qid}) async {
    try {
      return QuizModel.fromJson((await firestore.collection('quizzes').doc(qid).get()).data()!);
    } catch (e) {
      Utils().showToast(context: context, message: e.toString());
    }

    return null;
  }
}
