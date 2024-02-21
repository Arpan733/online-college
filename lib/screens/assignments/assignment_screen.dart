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
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AssignmentProvider>(context, listen: false).getAssignmentList(context: context);
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
          Consumer<AssignmentProvider>(
            builder: (context, assignment, _) {
              List<AssignmentModel> assignmentList = [];

              if (UserSharedPreferences.role == 'student') {
                for (var element in assignment.assignmentList) {
                  if (UserSharedPreferences.year == element.year) {
                    assignmentList.add(element);
                  }
                }
              } else {
                assignmentList = assignment.assignmentList;
              }

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
                      'Assignments',
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
                      itemCount: assignmentList.isEmpty ? 1 : assignmentList.length,
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

                        if (assignmentList.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: Text(
                                'There is no assignment',
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

                        AssignmentModel a = assignmentList[index];

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
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black38,
                                width: 1,
                              ),
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
                                          context, arguments: a, Routes.assignmentDetail);
                                    } else {
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

                                      assignment.setIsLoading(loading: true);

                                      if (!mounted) return;
                                      assignment.getAssignmentList(context: context);
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
                                              : 'SUBMIT  ASSIGNMENT',
                                      style: GoogleFonts.rubik(
                                        color: assignment.checkStudentInList(assignment: a)
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
              );
            },
          ),
        ],
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
    );
  }
}
