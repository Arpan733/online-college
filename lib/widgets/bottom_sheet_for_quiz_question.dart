import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/quiz_question_model.dart';
import 'package:online_college/providers/quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

bottomSheetForQuizQuestion({
  bool isEdit = false,
  QuizQuestionModel? quizQuestionModel,
  required BuildContext context,
}) {
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();

  FocusNode questionFocusNode = FocusNode();
  FocusNode option1FocusNode = FocusNode();
  FocusNode option2FocusNode = FocusNode();
  FocusNode option3FocusNode = FocusNode();
  FocusNode option4FocusNode = FocusNode();

  String? answer;

  if (isEdit) {
    questionController.text = quizQuestionModel!.question;
    option1Controller.text = quizQuestionModel.options[0].option;
    option2Controller.text = quizQuestionModel.options[1].option;
    option3Controller.text = quizQuestionModel.options[2].option;
    option4Controller.text = quizQuestionModel.options[3].option;

    for (var element in quizQuestionModel.options) {
      if (element.isAnswer == 'true') {
        answer = quizQuestionModel.options.indexOf(element) == 0
            ? 'Option 1'
            : quizQuestionModel.options.indexOf(element) == 1
                ? 'Option 2'
                : quizQuestionModel.options.indexOf(element) == 2
                    ? 'Option 3'
                    : 'Option 4';
      }
    }
  }

  showModalBottomSheet(
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, set) {
        return FocusScope(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 530,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/background 2.png'),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: questionController,
                      focusNode: questionFocusNode,
                      cursorColor: const Color(0xFF6688CA),
                      cursorWidth: 3,
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                      style: GoogleFonts.rubik(
                        color: const Color(0xFF6688CA),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.question_mark_outlined,
                          color: Color(0xFF6688CA),
                        ),
                        label: Text(
                          'Question',
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                          ),
                        ),
                        hintText: 'Question',
                        hintStyle: GoogleFonts.rubik(
                          color: const Color(0xFF6688CA),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: option1Controller,
                                focusNode: option1FocusNode,
                                cursorColor: const Color(0xFF6688CA),
                                cursorWidth: 3,
                                textCapitalization: TextCapitalization.sentences,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(option2FocusNode);
                                },
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.question_answer_outlined,
                                    color: Color(0xFF6688CA),
                                  ),
                                  label: Text(
                                    'Option 1',
                                    style: GoogleFonts.rubik(
                                      color: const Color(0xFF6688CA),
                                    ),
                                  ),
                                  hintText: 'Option 1',
                                  hintStyle: GoogleFonts.rubik(
                                    color: const Color(0xFF6688CA),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: option2Controller,
                                focusNode: option2FocusNode,
                                cursorColor: const Color(0xFF6688CA),
                                cursorWidth: 3,
                                textCapitalization: TextCapitalization.sentences,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(option3FocusNode);
                                },
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.question_answer_outlined,
                                    color: Color(0xFF6688CA),
                                  ),
                                  label: Text(
                                    'Option 2',
                                    style: GoogleFonts.rubik(
                                      color: const Color(0xFF6688CA),
                                    ),
                                  ),
                                  hintText: 'Option 2',
                                  hintStyle: GoogleFonts.rubik(
                                    color: const Color(0xFF6688CA),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: option3Controller,
                                focusNode: option3FocusNode,
                                cursorColor: const Color(0xFF6688CA),
                                cursorWidth: 3,
                                textCapitalization: TextCapitalization.sentences,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(option4FocusNode);
                                },
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.question_answer_outlined,
                                    color: Color(0xFF6688CA),
                                  ),
                                  label: Text(
                                    'Option 3',
                                    style: GoogleFonts.rubik(
                                      color: const Color(0xFF6688CA),
                                    ),
                                  ),
                                  hintText: 'Option 3',
                                  hintStyle: GoogleFonts.rubik(
                                    color: const Color(0xFF6688CA),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: option4Controller,
                                focusNode: option4FocusNode,
                                cursorColor: const Color(0xFF6688CA),
                                cursorWidth: 3,
                                textCapitalization: TextCapitalization.sentences,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                },
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.question_answer_outlined,
                                    color: Color(0xFF6688CA),
                                  ),
                                  label: Text(
                                    'Option 4',
                                    style: GoogleFonts.rubik(
                                      color: const Color(0xFF6688CA),
                                    ),
                                  ),
                                  hintText: 'Option 4',
                                  hintStyle: GoogleFonts.rubik(
                                    color: const Color(0xFF6688CA),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            RadioListTile<String>(
                              activeColor: Colors.white,
                              value: 'Option 1',
                              groupValue: answer,
                              onChanged: (value) {
                                set(() {
                                  answer = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            RadioListTile<String>(
                              activeColor: Colors.white,
                              value: 'Option 2',
                              groupValue: answer,
                              onChanged: (value) {
                                set(() {
                                  answer = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            RadioListTile<String>(
                              activeColor: Colors.white,
                              value: 'Option 3',
                              groupValue: answer,
                              onChanged: (value) {
                                set(() {
                                  answer = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            RadioListTile<String>(
                              activeColor: Colors.white,
                              value: 'Option 4',
                              groupValue: answer,
                              onChanged: (value) {
                                set(() {
                                  answer = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (questionController.text.isEmpty) {
                            Utils().showToast(
                                context: context, message: 'Please fill the question for the quiz');
                          } else if (option1Controller.text.isEmpty) {
                            Utils().showToast(
                                context: context, message: 'Please fill the option 1 for the quiz');
                          } else if (option2Controller.text.isEmpty) {
                            Utils().showToast(
                                context: context, message: 'Please fill the option 2 for the quiz');
                          } else if (option3Controller.text.isEmpty) {
                            Utils().showToast(
                                context: context, message: 'Please fill the option 3 for the quiz');
                          } else if (option4Controller.text.isEmpty) {
                            Utils().showToast(
                                context: context, message: 'Please fill the option 4 for the quiz');
                          } else if (answer == null) {
                            Utils().showToast(
                                context: context, message: 'Please select the answer for the quiz');
                          } else {
                            if (isEdit) {
                            } else {
                              String qqid = const UuidV4().generate().toString();

                              Provider.of<QuizProvider>(context, listen: false).addQuizQuestion(
                                context: context,
                                quizQuestionModel: QuizQuestionModel(
                                  qqid: qqid,
                                  question: questionController.text.toString().trim(),
                                  options: [
                                    Option(
                                      option: option1Controller.text.toString().trim(),
                                      isAnswer: (answer == 'Option 1').toString(),
                                    ),
                                    Option(
                                      option: option2Controller.text.toString().trim(),
                                      isAnswer: (answer == 'Option 2').toString(),
                                    ),
                                    Option(
                                      option: option3Controller.text.toString().trim(),
                                      isAnswer: (answer == 'Option 3').toString(),
                                    ),
                                    Option(
                                      option: option4Controller.text.toString().trim(),
                                      isAnswer: (answer == 'Option 4').toString(),
                                    ),
                                  ],
                                ),
                              );

                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isEdit ? 'Edit' : 'Add',
                            style: GoogleFonts.rubik(
                              color: const Color(0xFF6688CA),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}
