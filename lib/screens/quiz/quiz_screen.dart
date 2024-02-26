import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/quiz_model.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/quiz_provider.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String sort = 'All';

  List<String> dropDownList = UserSharedPreferences.role == 'teacher'
      ? [
          "All",
          "Given Date",
          "By Marks",
          "All Right",
          "All Wrong",
          "All Skip",
          "1st Year",
          "2nd Year",
          "3rd Year",
          "4th Year"
        ]
      : [
          "All",
          "Given Date",
          "By Marks",
          "All Right",
          "All Wrong",
          "All Skip",
        ];

  List<DropdownMenuItem<String>> dropDowns = [];

  List<QuizModel> showQuizList = [];

  @override
  void initState() {
    for (var element in dropDownList) {
      dropDowns.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            element,
            style: GoogleFonts.rubik(
              color: const Color(0xFF2855AE),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<QuizProvider>(context, listen: false).getQuizList(context: context);

      if (!mounted) return;
      await Provider.of<QuizProvider>(context, listen: false).getQuizQuestionList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<QuizProvider>(context, listen: false).getQuizList(context: context);
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
                showQuizList = UserSharedPreferences.role == 'teacher'
                    ? quiz.quizList
                    : quiz.quizList
                        .where((element) => element.sid == UserSharedPreferences.id)
                        .toList();

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
                          'Quiz',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              DropdownButtonFormField<String>(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                value: sort,
                                items: dropDowns,
                                onChanged: (value) {
                                  if (value != null) {
                                    sort = value;
                                    showQuizList = UserSharedPreferences.role == 'teacher'
                                        ? quiz.sortingForTeacher(context: context, sort: sort)
                                        : quiz.sortingForStudent(context: context, sort: sort);

                                    set(() {});
                                  }
                                },
                                dropdownColor: Colors.white,
                                iconEnabledColor: Colors.white,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.filter_alt_outlined,
                                    color: Color(0xFF2855AE),
                                    size: 20,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF2855AE),
                                    size: 30,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList.builder(
                          itemCount: showQuizList.isEmpty ? 1 : showQuizList.length,
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

                            if (showQuizList.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: Center(
                                  child: Text(
                                    UserSharedPreferences.role == 'teacher'
                                        ? (sort == 'All Right'
                                            ? 'There is not any quiz in which student had full marks'
                                            : sort == 'All Wrong'
                                                ? 'There is not any quiz in which student had zero marks'
                                                : sort == 'All Skip'
                                                    ? 'There is not any quiz in which student had skip all the quiz'
                                                    : [
                                                        "1st Year",
                                                        "2nd Year",
                                                        "3rd Year",
                                                        "4th Year"
                                                      ].contains(sort)
                                                        ? 'There is not any quiz given by $sort students.'
                                                        : 'There is no quiz')
                                        : (sort == 'All Right'
                                            ? 'There is not any quiz in which you had full marks'
                                            : sort == 'All Wrong'
                                                ? 'There is not any quiz in which you had zero marks'
                                                : sort == 'All Skip'
                                                    ? 'There is not any quiz in which you had skip all the quiz'
                                                    : 'There is no fee'),
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

                            QuizModel q = showQuizList[index];

                            Iterable<StudentUserModel> student =
                                Provider.of<AllUserProvider>(context, listen: false)
                                    .studentsList
                                    .where((element) => element.id == q.sid);

                            return GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, arguments: q.qid, Routes.quizDetail),
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
                                      student.first.name,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
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
                                          DateFormat('dd/MM/yyyy hh:mm aa')
                                              .format(DateTime.parse(q.createdDateTime)),
                                          style: GoogleFonts.rubik(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.timer_outlined,
                                          color: Colors.black54,
                                          size: 18,
                                        ),
                                        Text(
                                          '  Duration:  ',
                                          style: GoogleFonts.rubik(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '${q.takenTime} Sec',
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_outlined,
                                          color: Colors.green.withOpacity(0.8),
                                          size: 18,
                                        ),
                                        Text(
                                          '  Right:  ',
                                          style: GoogleFonts.rubik(
                                            color: Colors.green.withOpacity(0.8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          q.right,
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.close_outlined,
                                          color: Colors.red.withOpacity(0.8),
                                          size: 18,
                                        ),
                                        Text(
                                          '  Wrong:  ',
                                          style: GoogleFonts.rubik(
                                            color: Colors.red.withOpacity(0.8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          q.wrong,
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.skip_next_outlined,
                                          color: Colors.black54,
                                          size: 18,
                                        ),
                                        Text(
                                          '  Skip:  ',
                                          style: GoogleFonts.rubik(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          q.skip,
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
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
        floatingActionButton: UserSharedPreferences.role == 'teacher'
            ? GestureDetector(
                onTap: () => Navigator.pushNamed(context, Routes.quizQuestion),
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
                    Icons.quiz_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => Navigator.pushNamed(context, Routes.quizPlay),
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
