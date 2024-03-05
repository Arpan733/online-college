import 'dart:async';

import 'package:dismissible_carousel_viewpager/dismissible_carousel_viewpager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/quiz_model.dart';
import 'package:online_college/model/quiz_question_model.dart';
import 'package:online_college/providers/quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late QuizProvider provider;
  List<QuizQuestionModel> questions = [];
  List<String> questionsRightAnswer = [];
  List<Question> questionsList = [];
  List<String> questionAnswers = [
    'Not Chosen',
    'Not Chosen',
    'Not Chosen',
    'Not Chosen',
    'Not Chosen',
    'Not Chosen',
    'Not Chosen',
    'Not Chosen',
    'Not Chosen',
    'Not Chosen'
  ];

  String dateTime = DateTime.now().toString();

  int index = 0;

  int secondsRemaining = 100;
  Timer? timer;

  int questionSecondsRemaining = 10;
  Timer? questionTimer;

  @override
  void initState() {
    provider = Provider.of<QuizProvider>(context, listen: false);
    questions = provider.quizQuestionList;
    questions.shuffle();
    questions = questions.sublist(0, 10);

    startTimer();
    startQuestionTimer();

    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (timer) {
        setState(() {
          if (secondsRemaining < 1) {
            timer.cancel();
          } else {
            secondsRemaining -= 1;
          }
        });
      },
    );
  }

  void startQuestionTimer() {
    const oneSec = Duration(seconds: 1);
    questionTimer = Timer.periodic(
      oneSec,
      (timer) async {
        if (questionSecondsRemaining < 2) {
          await addToFinals();

          if (questions.length != 1) {
            setState(() {});
          }
        } else {
          questionSecondsRemaining -= 1;
          setState(() {});
        }
      },
    );
  }

  Future<void> addToFinals() async {
    questionTimer?.cancel();
    startQuestionTimer();
    questionSecondsRemaining = 10;

    String ans = 'Option 1';

    for (var element in questions[0].options) {
      if (element.isAnswer == 'true') {
        ans = 'Option ${questions[0].options.indexOf(element) + 1}';
      }
    }

    questionsRightAnswer.add(ans);
    questionsList.add(Question(qqid: questions[0].qqid, result: questionAnswers[index]));

    if (questions.length == 1) {
      String qid = const UuidV4().generate().toString();
      int right = 0;
      int wrong = 0;
      int skip = 0;

      for (int c = 0; c < questionAnswers.length; c++) {
        if (questionAnswers[c] == 'Not Chosen') {
          skip++;
        } else if (questionAnswers[c] == questionsRightAnswer[c]) {
          right++;
        } else {
          wrong++;
        }
      }

      await provider.addQuiz(
          context: context,
          quizModel: QuizModel(
              qid: qid,
              sid: UserSharedPreferences.id,
              createdDateTime: dateTime,
              questions: questionsList,
              takenTime: (100 - secondsRemaining).toString(),
              right: right.toString(),
              wrong: wrong.toString(),
              skip: skip.toString()));

      if (!mounted) return;
      Navigator.pop(context);
    } else {
      index++;
      questions.removeAt(0);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    questionTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
            width: MediaQuery.of(context).size.width - 40,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: 35,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Play Quiz',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        questionAnswers[index] = 'Not Chosen';
                        await addToFinals();

                        if (questions.length != 1) {
                          setState(() {});
                        }
                      },
                      child: Text(
                        'Skip',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF05518B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF05518B),
                      width: 3,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width - 46) * (secondsRemaining / 100),
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF46D9BF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$secondsRemaining Sec',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              Icons.timer_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${questionsList.length + 1}',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          '/ 10',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 50,
                        itemBuilder: (context, i) => Container(
                          height: 2,
                          width: (MediaQuery.of(context).size.width - 40) / 101,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 320,
            height: MediaQuery.of(context).size.height - 340,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: DismissibleCarouselViewPager(
                    initialPage: 0,
                    viewportFraction: (MediaQuery.of(context).size.width - 40) /
                        MediaQuery.of(context).size.width,
                    physics: const NeverScrollableScrollPhysics(),
                    dismissalConfig: DismissalConfig(
                      dismissalTypes: [
                        DismissalType.fadeOut(),
                        DismissalType.slideOut(),
                      ],
                    ),
                    itemCount: 10,
                    itemBuilder: (context, ind) => Container(
                      key: Key((DateTime.now().millisecondsSinceEpoch * ind).toString()),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[0].question,
                            style: GoogleFonts.rubik(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          StatefulBuilder(
                            builder: (context, set) => ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    set(() {
                                      questionAnswers[index] = 'Option ${i + 1}';
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width - 90,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: i + 1 ==
                                                int.parse(questionAnswers[index] == 'Not Chosen'
                                                    ? "5"
                                                    : questionAnswers[index][7])
                                            ? const Color(0xFF2855AE)
                                            : Colors.black54,
                                        width: i + 1 ==
                                                int.parse(questionAnswers[index] == 'Not Chosen'
                                                    ? "5"
                                                    : questionAnswers[index][7])
                                            ? 2
                                            : 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          i == 0
                                              ? 'A:   '
                                              : i == 1
                                                  ? 'B:   '
                                                  : i == 2
                                                      ? 'C:   '
                                                      : 'D:   ',
                                          style: GoogleFonts.rubik(
                                            color: i + 1 ==
                                                    int.parse(questionAnswers[index] == 'Not Chosen'
                                                        ? "5"
                                                        : questionAnswers[index][7])
                                                ? const Color(0xFF2855AE)
                                                : Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            questions[0].options[i].option,
                                            style: GoogleFonts.rubik(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          alignment: Alignment.centerRight,
                                          child: RadioListTile<String>(
                                            activeColor: const Color(0xFF2855AE),
                                            value: 'Option ${i + 1}',
                                            groupValue: questionAnswers[index],
                                            onChanged: (value) {
                                              set(() {
                                                questionAnswers[index] = value ?? 'Not Chosen';
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  if (questionAnswers[index] != 'Not Chosen') {
                                    await addToFinals();

                                    if (questions.length != 1) {
                                      setState(() {});
                                    }
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                    ),
                                  ),
                                  child: Text(
                                    "Next",
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
