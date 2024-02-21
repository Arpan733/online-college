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
  String sort = UserSharedPreferences.role == 'teacher' ? 'Created Date' : 'All';

  List<String> dropDownList = UserSharedPreferences.role == 'teacher'
      ? [
          "Created Date",
          "Due Date",
          "Submitted By All Student",
          "Not Submitted By All Student",
          "1st Year",
          "2nd Year",
          "3rd Year",
          "4th Year"
        ]
      : ["All", "Submitted", "Not Submitted"];

  List<DropdownMenuItem<String>> dropDowns = [];

  List<AssignmentModel> showAssignmentList = [];

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
              fontSize:
                  ['Submitted By All Student', 'Not Submitted By All Student'].contains(element)
                      ? 16
                      : 18,
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
            Consumer<AssignmentProvider>(
              builder: (context, assignment, _) {
                showAssignmentList = UserSharedPreferences.role == 'teacher'
                    ? assignment.sortingForTeacher(context: context, sort: sort)
                    : assignment.sortingForStudent(context: context, sort: sort);

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
                                    showAssignmentList = UserSharedPreferences.role == 'teacher'
                                        ? assignment.sortingForTeacher(context: context, sort: sort)
                                        : assignment.sortingForStudent(
                                            context: context, sort: sort);
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
                                        ? (sort == 'Submitted By All Student'
                                            ? 'There is no assignment which is submitted by all students'
                                            : sort == 'Not Submitted By All Student'
                                                ? 'There is no assignment remaining which are not submitted by students'
                                                : ["1st Year", "2nd Year", "3rd Year", "4th Year"]
                                                        .contains(sort)
                                                    ? 'There is not any assignment for $sort students.'
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
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

                                          if (!context.mounted) return;
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
                  ),
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
      ),
    );
  }
}
