import 'package:flutter/cupertino.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/quiz_model.dart';
import 'package:online_college/model/quiz_question_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/repositories/quiz_firestore.dart';
import 'package:provider/provider.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizModel> _quizList = [];

  List<QuizModel> get quizList => _quizList;

  QuizModel _quiz = QuizModel(
    qid: 'qid',
    sid: 'sid',
    createdDateTime: 'createdDateTime',
    questions: [],
    takenTime: 'takenTime',
    right: 'right',
    wrong: 'wrong',
    skip: 'skip',
  );

  QuizModel get quiz => _quiz;

  List<QuizQuestionModel> _quizQuestionList = [];

  List<QuizQuestionModel> get quizQuestionList => _quizQuestionList;

  QuizQuestionModel _quizQuestion = QuizQuestionModel(
    options: [],
    qqid: '',
    question: '',
  );

  QuizQuestionModel get quizQuestion => _quizQuestion;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addQuizQuestion(
      {required BuildContext context, required QuizQuestionModel quizQuestionModel}) async {
    await QuizFireStore()
        .addQuizQuestionToFireStore(context: context, quizQuestionModel: quizQuestionModel);

    if (!context.mounted) return;
    await getQuizQuestionList(context: context);
  }

  Future<void> updateQuizQuestion(
      {required BuildContext context, required QuizQuestionModel quizQuestionModel}) async {
    await QuizFireStore()
        .updateQuizQuestionAtFireStore(context: context, quizQuestionModel: quizQuestionModel);

    if (!context.mounted) return;
    await getQuizQuestionList(context: context);
  }

  Future<void> deleteQuizQuestion({required BuildContext context, required String qqid}) async {
    await QuizFireStore().deleteQuizQuestionFromFireStore(context: context, qqid: qqid);

    if (!context.mounted) return;
    await getQuizQuestionList(context: context);
  }

  Future<void> getQuizQuestionList({required BuildContext context}) async {
    _quizQuestionList = [];
    _isLoading = true;
    notifyListeners();

    List<QuizQuestionModel> response =
        await QuizFireStore().getQuizQuestionListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _quizQuestionList = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getQuizQuestion({required BuildContext context, required String qqid}) async {
    _quizQuestion = QuizQuestionModel(
      options: [],
      qqid: '',
      question: '',
    );
    _isLoading = true;
    notifyListeners();

    QuizQuestionModel? response =
        await QuizFireStore().getQuizQuestionFromFireStore(context: context, qqid: qqid);

    if (response != null) {
      _quizQuestion = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addQuiz({required BuildContext context, required QuizModel quizModel}) async {
    await QuizFireStore().addQuizToFireStore(context: context, quizModel: quizModel);

    if (!context.mounted) return;
    await getQuizList(context: context);
  }

  Future<void> updateQuiz({required BuildContext context, required QuizModel quizModel}) async {
    await QuizFireStore().updateQuizAtFireStore(context: context, quizModel: quizModel);

    if (!context.mounted) return;
    await getQuizList(context: context);
  }

  Future<void> deleteQuiz({required BuildContext context, required String qid}) async {
    await QuizFireStore().deleteQuizFromFireStore(context: context, qid: qid);

    if (!context.mounted) return;
    await getQuizList(context: context);
  }

  Future<void> getQuizList({required BuildContext context}) async {
    _quizList = [];
    _isLoading = true;
    notifyListeners();

    List<QuizModel> response = await QuizFireStore().getQuizListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _quizList = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getQuiz({required BuildContext context, required String qid}) async {
    _quiz = QuizModel(
      qid: 'qid',
      sid: 'sid',
      createdDateTime: 'createdDateTime',
      questions: [],
      takenTime: 'takenTime',
      right: 'right',
      wrong: 'wrong',
      skip: 'skip',
    );
    _isLoading = true;
    notifyListeners();

    QuizModel? response = await QuizFireStore().getQuizFromFireStore(context: context, qid: qid);

    if (response != null) {
      _quiz = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  List<QuizModel> sortingForTeacher({
    required BuildContext context,
    required String sort,
  }) {
    List<QuizModel> showQuizList = [];

    if (sort == 'All') {
      showQuizList = quizList.map((element) => QuizModel.fromJson(element.toJson())).toList();
    } else if (sort == 'Given Date') {
      showQuizList = quizList.map((element) => QuizModel.fromJson(element.toJson())).toList();
      showQuizList.sort(
        (a, b) {
          DateTime aDate = DateTime.parse(a.createdDateTime);
          DateTime bDate = DateTime.parse(b.createdDateTime);
          return bDate.compareTo(aDate);
        },
      );
    } else if (sort == 'By Marks') {
      showQuizList = quizList.map((element) => QuizModel.fromJson(element.toJson())).toList();
      showQuizList.sort(
        (a, b) {
          int aDate = int.parse(a.right);
          int bDate = int.parse(b.right);
          return bDate.compareTo(aDate);
        },
      );
    } else if (sort == 'All Right') {
      for (var element in quizList) {
        if (element.right == '10') {
          showQuizList.add(QuizModel.fromJson(element.toJson()));
        }
      }
    } else if (sort == 'All Wrong') {
      for (var element in quizList) {
        if (element.wrong == '10') {
          showQuizList.add(QuizModel.fromJson(element.toJson()));
        }
      }
    } else if (sort == 'All Skip') {
      for (var element in quizList) {
        if (element.skip == '10') {
          showQuizList.add(QuizModel.fromJson(element.toJson()));
        }
      }
    } else {
      for (var element in quizList) {
        Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((e) {
          if (element.sid == e.id && e.year == sort) {
            showQuizList.add(element);
          }
        });
      }
    }

    return showQuizList;
  }

  List<QuizModel> sortingForStudent({
    required BuildContext context,
    required String sort,
  }) {
    List<QuizModel> showQuizList = [];
    List<QuizModel> quizzes =
        quizList.where((element) => element.sid == UserSharedPreferences.id).toList();

    if (sort == 'All') {
      showQuizList = quizzes.map((element) => QuizModel.fromJson(element.toJson())).toList();
    } else if (sort == 'Given Date') {
      showQuizList = quizzes.map((element) => QuizModel.fromJson(element.toJson())).toList();
      showQuizList.sort(
        (a, b) {
          DateTime aDate = DateTime.parse(a.createdDateTime);
          DateTime bDate = DateTime.parse(b.createdDateTime);
          return bDate.compareTo(aDate);
        },
      );
    } else if (sort == 'By Marks') {
      showQuizList = quizzes.map((element) => QuizModel.fromJson(element.toJson())).toList();
      showQuizList.sort(
        (a, b) {
          int aDate = int.parse(a.right);
          int bDate = int.parse(b.right);
          return bDate.compareTo(aDate);
        },
      );
    } else if (sort == 'All Right') {
      for (var element in quizzes) {
        if (element.right == '10') {
          showQuizList.add(QuizModel.fromJson(element.toJson()));
        }
      }
    } else if (sort == 'All Wrong') {
      for (var element in quizzes) {
        if (element.wrong == '10') {
          showQuizList.add(QuizModel.fromJson(element.toJson()));
        }
      }
    } else if (sort == 'All Skip') {
      for (var element in quizzes) {
        if (element.skip == '10') {
          showQuizList.add(QuizModel.fromJson(element.toJson()));
        }
      }
    }

    return showQuizList;
  }
}
//3234422142
