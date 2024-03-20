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
  String sort = 'All';
  String currentYear = '1st Year';

  List<String> yearDropDownList = [
    "1st Year",
    "2nd Year",
    "3rd Year",
    "4th Year",
  ];

  List<String> dropDownList = [
    "All",
    "Fail",
    "Pass",
    "By Number",
    "By CPI",
  ];

  List<DropdownMenuItem<String>> dropDowns = [];
  List<DropdownMenuItem<String>> yearDropDowns = [];

  List<ResultModel> showResultList = [];

  @override
  void initState() {
    for (var element in yearDropDownList) {
      yearDropDowns.add(
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ResultProvider>(context, listen: false).getResultList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<ResultProvider>(context, listen: false).getResultList(context: context);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ResultProvider>(
          builder: (context, result, child) {
            showResultList = [];
            List<StudentUserModel> studentsList = [];
            List<ResultModel> results = [];

            for (var element in result.results) {
              Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((stu) {
                if (element.sid == stu.id && stu.year == currentYear) {
                  results.add(element);
                }
              });
            }

            if (sort == 'All') {
              showResultList = results.map((e) => e).toList();

              for (var element in showResultList) {
                Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((stu) {
                  if (element.sid == stu.id) {
                    studentsList.add(stu);
                  }
                });
              }
            } else if (sort == 'Fail') {
              for (var element in results) {
                if (double.parse(element.cpi!) < 0.33) {
                  showResultList.add(element);
                }
              }

              for (var element in showResultList) {
                Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((stu) {
                  if (element.sid == stu.id) {
                    studentsList.add(stu);
                  }
                });
              }
            } else if (sort == 'Pass') {
              for (var element in results) {
                if (double.parse(element.cpi!) > 0.33) {
                  showResultList.add(element);
                }
              }

              for (var element in showResultList) {
                Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((stu) {
                  if (element.sid == stu.id) {
                    studentsList.add(stu);
                  }
                });
              }
            } else if (sort == 'By Number') {
              for (var element in results) {
                Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((stu) {
                  if (element.sid == stu.id) {
                    studentsList.add(stu);
                  }
                });
              }

              studentsList.sort(
                (a, b) {
                  int aNumber = int.parse(a.rollNo);
                  int bNumber = int.parse(b.rollNo);
                  return aNumber.compareTo(bNumber);
                },
              );

              for (var element in studentsList) {
                for (var e in results) {
                  if (e.sid == element.id) {
                    showResultList.add(e);
                  }
                }
              }
            } else if (sort == 'By CPI') {
              showResultList = results.map((e) => e).toList();
              showResultList.sort(
                (a, b) {
                  double aCPI = double.parse(a.cpi!);
                  double bCPI = double.parse(b.cpi!);
                  return bCPI.compareTo(aCPI);
                },
              );

              for (var element in showResultList) {
                Provider.of<AllUserProvider>(context, listen: false).studentsList.forEach((stu) {
                  if (element.sid == stu.id) {
                    studentsList.add(stu);
                  }
                });
              }
            }

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
                                  items: yearDropDowns,
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
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  value: sort,
                                  items: dropDowns,
                                  onChanged: (value) {
                                    if (value != null) {
                                      sort = value;
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
                        itemCount: showResultList.isEmpty ? 1 : showResultList.length,
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

                          if (showResultList.isEmpty) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: Center(
                                child: Text(
                                  sort == 'Fail'
                                      ? 'There is all pass in $currentYear student'
                                      : sort == 'Pass'
                                          ? 'There is no pass in $currentYear student'
                                          : 'There is no result for $currentYear student',
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

                          print(studentsList);
                          print(showResultList);

                          StudentUserModel sum = studentsList[index];
                          ResultModel resultModel = showResultList[index];
                          Result res = Result(
                              year: currentYear,
                              spi: '0.0',
                              data: [Datum(subject: 'a', marks: '0')]);

                          for (var element in resultModel.result!) {
                            if (element.year == currentYear) {
                              res = element;
                            }
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black45,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: double.parse(res.spi!) > 0.3
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          sum.rollNo,
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
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: resultModel.result?.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          arguments: {
                                            'resultModel': resultModel,
                                            'result': resultModel.result?[index]
                                          },
                                          Routes.addEditResult,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Divider(
                                              color: Colors.black38,
                                            ),
                                            Text(
                                              resultModel.result?[index].year ?? '',
                                              style: GoogleFonts.rubik(
                                                color: Colors.black87,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: resultModel.result?[index].data?.length,
                                              itemBuilder: (context, i) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(
                                                            vertical: 3, horizontal: 10),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.black38,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          resultModel.result?[index].data?[i]
                                                                  .subject ??
                                                              '',
                                                          style: GoogleFonts.rubik(
                                                            color: Colors.black87,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 3, horizontal: 20),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black38,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        resultModel.result?[index].data?[i].marks ??
                                                            '',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.black87,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 3),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black38,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Text(
                                                    'SPI: ${resultModel.result?[index].spi}   ',
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
      ),
    );
  }
}
