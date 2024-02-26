import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/model/quiz_model.dart';
import 'package:online_college/model/quiz_question_model.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/quiz_provider.dart';
import 'package:provider/provider.dart';

class QuizDetailScreen extends StatefulWidget {
  final String qid;

  const QuizDetailScreen({super.key, required this.qid});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  List<StudentUserModel> student = [];
  List<QuizQuestionModel> questions = [];
  QuizModel quizModel = QuizModel(
    qid: 'qid',
    sid: 'sid',
    createdDateTime: 'createdDateTime',
    questions: [],
    takenTime: 'takenTime',
    right: 'right',
    wrong: 'wrong',
    skip: 'skip',
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<QuizProvider>(context, listen: false)
          .getQuiz(context: context, qid: widget.qid);

      if (!mounted) return;
      quizModel = Provider.of<QuizProvider>(context, listen: false).quiz;
      questions =
          Provider.of<QuizProvider>(context, listen: false).quizQuestionList.where((element) {
        for (var e in quizModel.questions) {
          if (e.qqid == element.qqid) {
            return true;
          }
        }

        return false;
      }).toList();
      student = Provider.of<AllUserProvider>(context, listen: false)
          .studentsList
          .where((element) => element.id == quizModel.sid)
          .toList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/background 1.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Consumer<QuizProvider>(
            builder: (context, quiz, _) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    foregroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                          ),
                        ),
                        child: Image.asset('assets/images/background.png'),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size(MediaQuery.of(context).size.width, 40),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      'Quiz Result',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            height: 100,
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF6688CA),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6688CA).withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFF6688CA), width: 2),
                                  ),
                                  child: quiz.isLoading
                                      ? const SizedBox(
                                          height: 30,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF2855AE),
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Hero(
                                            tag: 'profilePhoto',
                                            child: Image.network(
                                              student.first.photoUrl,
                                              fit: BoxFit.fitHeight,
                                              errorBuilder: (BuildContext context, Object error,
                                                  StackTrace? stackTrace) {
                                                return Image.asset('assets/images/student.png');
                                              },
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: quiz.isLoading
                                      ? const Center(
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF2855AE),
                                            ),
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student.first.name,
                                              style: GoogleFonts.rubik(
                                                color: Colors.black87,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '${quiz.quiz.right}/10',
                                              style: GoogleFonts.rubik(
                                                color: int.parse(quiz.quiz.right) > 8
                                                    ? Colors.green.withOpacity(0.8)
                                                    : int.parse(quiz.quiz.right) > 4
                                                        ? Colors.yellow.withOpacity(0.8)
                                                        : Colors.red.withOpacity(0.8),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.date_range_outlined,
                                                  color: Colors.black54,
                                                  size: 18,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  DateFormat('dd/MM/yyyy hh:mm aa').format(
                                                      DateTime.parse(quiz.quiz.createdDateTime)),
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.builder(
                      itemCount: quiz.isLoading ? 1 : 10,
                      itemBuilder: (context, index) {
                        if (quiz.isLoading) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2855AE),
                              ),
                            ),
                          );
                        }

                        QuizQuestionModel qq = questions[index];

                        return Container(
                          width: MediaQuery.of(context).size.width - 60,
                          margin: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black38,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Question:',
                                style: GoogleFonts.rubik(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                qq.question,
                                style: GoogleFonts.rubik(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Options:',
                                style: GoogleFonts.rubik(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                itemBuilder: (context, i) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: quiz.quiz.questions[index].result[7] ==
                                                (i + 1).toString()
                                            ? Icon(
                                                qq.options[i].isAnswer != 'false'
                                                    ? Icons.check_outlined
                                                    : Icons.close_outlined,
                                                color: qq.options[i].isAnswer != 'false'
                                                    ? Colors.green.withOpacity(0.8)
                                                    : Colors.red.withOpacity(0.8),
                                              )
                                            : null,
                                      ),
                                      Text(
                                        i == 0
                                            ? 'A: '
                                            : i == 1
                                                ? 'B: '
                                                : i == 2
                                                    ? 'C: '
                                                    : 'D: ',
                                        style: GoogleFonts.rubik(
                                          color: qq.options[i].isAnswer == 'false'
                                              ? Colors.black54
                                              : Colors.green.withOpacity(0.54),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width - 120,
                                        child: Text(
                                          qq.options[i].option,
                                          style: GoogleFonts.rubik(
                                            color: qq.options[i].isAnswer == 'false'
                                                ? Colors.black87
                                                : Colors.green.withOpacity(0.87),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
