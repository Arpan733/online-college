import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/model/result_model.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/providers/result_provider.dart';
import 'package:provider/provider.dart';

import '../../consts/routes.dart';
import '../../consts/user_shared_preferences.dart';
import '../../providers/all_user_provider.dart';

class ResultScreenForTeacher extends StatefulWidget {
  const ResultScreenForTeacher({super.key});

  @override
  State<ResultScreenForTeacher> createState() => _ResultScreenForTeacherState();
}

class _ResultScreenForTeacherState extends State<ResultScreenForTeacher> {
  String currentYear = '1st Year';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllUserProvider>(context, listen: false).getAllUser(context: context);
      Provider.of<ResultProvider>(context, listen: false).getResultList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ResultProvider>(
        builder: (context, result, child) {
          List<ResultModel> resultsList = [];
          List<StudentUserModel> studentsList = [];

          for (var element in result.results) {
            for (var re in element.result!) {
              if (re.year == currentYear) {
                resultsList.add(element);
              }
            }
          }

          Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((element) {
            for (var re in resultsList) {
              if (re.sid == element.id) {
                studentsList.add(element);
              }
            }
          });

          studentsList.sort(
            (a, b) {
              int aRoll = int.parse(a.rollNo!);
              int bRoll = int.parse(b.rollNo!);
              return aRoll.compareTo(bRoll);
            },
          );

          List<ResultModel> sortedResultsList = [];

          for (var student in studentsList) {
            ResultModel result = resultsList.firstWhere((result) => result.sid == student.id);
            sortedResultsList.add(result);
          }

          resultsList = sortedResultsList;

          return Stack(
            children: [
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/background 1.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              CustomScrollView(
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
                      'Results',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Flexible(
                              child: DropdownButtonFormField<String>(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                value: currentYear,
                                items: [
                                  DropdownMenuItem(
                                    value: '1st Year',
                                    child: Text(
                                      '1st Year',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '2nd Year',
                                    child: Text(
                                      '2nd Year',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '3rd Year',
                                    child: Text(
                                      '3rd Year',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '4th Year',
                                    child: Text(
                                      '4th Year',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    currentYear = value;
                                    setState(() {});
                                  }
                                },
                                dropdownColor: Colors.white,
                                iconEnabledColor: Colors.white,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF2855AE),
                                    size: 30,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.builder(
                      itemCount: resultsList.length,
                      itemBuilder: (context, index) {
                        if (result.isLoading) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2855AE),
                              ),
                            ),
                          );
                        }

                        if (resultsList.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: Text(
                                'There is no result for $currentYear student',
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

                        StudentUserModel sum = studentsList[index];
                        ResultModel resultModel = resultsList[index];
                        Result res = Result(
                            year: currentYear, spi: '0.0', data: [Datum(subject: 'a', marks: '0')]);

                        for (var element in resultModel.result!) {
                          if (element.year == currentYear) {
                            res = element;
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                arguments: {'resultModel': resultModel, 'result': res},
                                Routes.addEditResult);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black45,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    sum.rollNo!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  color: Colors.black38,
                                  width: 1,
                                  height: 50,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '${sum.name} - ${sum.year}',
                                  style: GoogleFonts.rubik(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CPI',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black45,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      resultModel.cpi!,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SPI',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black45,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      res.spi!,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: UserSharedPreferences.role == 'teacher'
          ? GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.addEditResult),
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
            )
          : null,
    );
  }
}
