import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/model/quiz_question_model.dart';
import 'package:online_college/providers/quiz_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_quiz_question.dart';
import 'package:provider/provider.dart';

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({super.key});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<QuizProvider>(context, listen: false).getQuizQuestionList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<QuizProvider>(context, listen: false)
            .getQuizQuestionList(context: context);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
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
                return StatefulBuilder(
                  builder: (context, set) => CustomScrollView(
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
                          'Quiz Questions',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList.builder(
                          itemCount:
                              quiz.quizQuestionList.isEmpty ? 1 : quiz.quizQuestionList.length,
                          itemBuilder: (context, index) {
                            if (quiz.isLoading) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2855AE),
                                  ),
                                ),
                              );
                            }

                            if (quiz.quizQuestionList.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: Center(
                                  child: Text(
                                    'There is no questions for the Quiz',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }

                            QuizQuestionModel qq = quiz.quizQuestionList[index];

                            return GestureDetector(
                              onLongPress: () {
                                bottomSheetForQuizQuestion(
                                    context: context, isEdit: true, quizQuestionModel: qq);
                              },
                              child: Container(
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
                                              width: MediaQuery.of(context).size.width - 85,
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
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: GestureDetector(
          onTap: () => bottomSheetForQuizQuestion(context: context),
          child: Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
              ),
            ),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
