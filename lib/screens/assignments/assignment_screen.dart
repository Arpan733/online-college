import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/assignment_model.dart';
import 'package:online_college/providers/assignment_provider.dart';
import 'package:online_college/repositories/assignment_firestore.dart';
import 'package:online_college/widgets/bottom_sheet_for_assignment.dart';
import 'package:provider/provider.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  String sort = 'All';
  String currentYear = '1st Year';

  List<String> yearsDropDownList = [
    "1st Year",
    "2nd Year",
    "3rd Year",
    "4th Year",
  ];

  List<String> dropDownList = ["All", "Created Date", "Due Date", "Submitted", "Not Submitted"];

  List<DropdownMenuItem<String>> dropDowns = [];
  List<DropdownMenuItem<String>> yearsDropDowns = [];

  List<AssignmentModel> showAssignmentList = [];

  @override
  void initState() {
    for (var element in yearsDropDownList) {
      yearsDropDowns.add(
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
      Provider.of<AssignmentProvider>(context, listen: false).getAssignmentList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<AssignmentProvider>(context, listen: false)
            .getAssignmentList(context: context);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<AssignmentProvider>(
          builder: (context, assignment, _) {
            showAssignmentList.clear();
            List<AssignmentModel> assignments = [];
            if (UserSharedPreferences.role == 'teacher') {
              for (var element in assignment.assignmentList) {
                if (element.year == currentYear) {
                  assignments.add(AssignmentModel.fromJson(element.toJson()));
                }
              }
            } else {
              for (var element in assignment.assignmentList) {
                if (UserSharedPreferences.year == element.year) {
                  assignments.add(element);
                }
              }
            }

            if (sort == 'All') {
              showAssignmentList = assignments;
            } else if (sort == 'Created Date') {
              showAssignmentList =
                  assignments.map((element) => AssignmentModel.fromJson(element.toJson())).toList();
              showAssignmentList.sort(
                (a, b) {
                  DateTime aDate = DateTime.parse(a.createdDateTime);
                  DateTime bDate = DateTime.parse(b.createdDateTime);
                  return aDate.compareTo(bDate);
                },
              );
            } else if (sort == 'Due Date') {
              showAssignmentList =
                  assignments.map((element) => AssignmentModel.fromJson(element.toJson())).toList();
              showAssignmentList.sort(
                (a, b) {
                  DateTime aDate = DateTime.parse(a.lastDateTime);
                  DateTime bDate = DateTime.parse(b.lastDateTime);
                  return aDate.compareTo(bDate);
                },
              );
            } else if (sort == 'Submitted') {
              for (var element in assignments) {
                if (assignment.checkStudentInList(assignment: element)) {
                  showAssignmentList.add(element);
                }
              }
            } else if (sort == 'Not Submitted') {
              for (var element in assignments) {
                if (!assignment.checkStudentInList(assignment: element)) {
                  showAssignmentList.add(element);
                }
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
                        'Assignments',
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
                                  items: yearsDropDowns,
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
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      sliver: SliverList.builder(
                        itemCount: showAssignmentList.isEmpty ? 1 : showAssignmentList.length,
                        itemBuilder: (context, index) {
                          if (assignment.isLoading) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF2855AE),
                                ),
                              ),
                            );
                          }

                          if (showAssignmentList.isEmpty) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: Center(
                                child: Text(
                                  UserSharedPreferences.role == 'teacher'
                                      ? (sort == 'Submitted'
                                          ? 'There is no assignment which is submitted by all students'
                                          : sort == 'Not Submitted'
                                              ? 'There is no assignment remaining which are not submitted by students'
                                              : 'There is no assignment')
                                      : (sort == 'Submitted'
                                          ? 'You have not submit any assignment.'
                                          : sort == 'Not Submitted'
                                              ? 'You submit all the assignments'
                                              : 'There is no assignment'),
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

                          AssignmentModel a = showAssignmentList[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black38,
                                width: 1,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: assignment.checkStudentInList(assignment: a)
                                    ? Colors.green.withOpacity(0.2)
                                    : DateTime.now().isAfter(DateTime.parse(a.lastDateTime))
                                        ? Colors.red.withOpacity(0.2)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE6EFFF),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          a.year,
                                          style: GoogleFonts.rubik(
                                            color: const Color(0xFF6789CA),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE6EFFF),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          a.subject,
                                          style: GoogleFonts.rubik(
                                            color: const Color(0xFF6789CA),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    a.title,
                                    style: GoogleFonts.rubik(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Assign Date",
                                        style: GoogleFonts.rubik(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd MMM yy')
                                            .format(DateTime.parse(a.createdDateTime))
                                            .toString(),
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Due Date",
                                        style: GoogleFonts.rubik(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd MMM yy')
                                            .format(DateTime.parse(a.lastDateTime))
                                            .toString(),
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (UserSharedPreferences.role == 'teacher') {
                                        Navigator.pushNamed(
                                            context, arguments: a.aid, Routes.assignmentDetail);
                                      } else if (!DateTime.now()
                                          .isAfter(DateTime.parse(a.lastDateTime))) {
                                        if (!assignment.checkStudentInList(assignment: a)) {
                                          assignment.setIsLoading(loading: true);

                                          final value = await FilePicker.platform.pickFiles();
                                          String url = '';

                                          if (value != null) {
                                            if (!context.mounted) return;
                                            url = await AssignmentFireStore().uploadFile(
                                                  context: context,
                                                  pickedFile: value.files[0],
                                                  aid: a.aid,
                                                ) ??
                                                '';
                                          }

                                          if (url != '') {
                                            Submitted submitted = Submitted(
                                                sid: UserSharedPreferences.id,
                                                url: url,
                                                submitTime: DateTime.now().toString());

                                            if (!context.mounted) return;
                                            await assignment.addStudentInAssignmentList(
                                                context: context,
                                                submitted: submitted,
                                                assignmentModel: a);
                                          }

                                          assignment.setIsLoading(loading: false);

                                          if (!context.mounted) return;
                                          assignment.getAssignmentList(context: context);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft,
                                          colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                        ),
                                      ),
                                      child: Text(
                                        UserSharedPreferences.role == 'teacher'
                                            ? 'DETAILS'
                                            : assignment.checkStudentInList(assignment: a)
                                                ? 'SUBMITTED'
                                                : DateTime.now()
                                                        .isAfter(DateTime.parse(a.lastDateTime))
                                                    ? 'TIME LEFT'
                                                    : 'SUBMIT  ASSIGNMENT',
                                        style: GoogleFonts.rubik(
                                          color: assignment.checkStudentInList(assignment: a) ||
                                                  DateTime.now().isAfter(
                                                          DateTime.parse(a.lastDateTime)) &&
                                                      UserSharedPreferences.role == 'student'
                                              ? Colors.white54
                                              : Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
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
                onTap: () => bottomSheetForAssignment(context: context),
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
