import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/leave_application_model.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/leave_application_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_leave_application.dart';
import 'package:provider/provider.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({Key? key}) : super(key: key);

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  String status = 'waiting';
  String currentYear = '1st Year';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LeaveApplicationProvider>(context, listen: false)
          .getLeaveApplicationList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<LeaveApplicationProvider>(context, listen: false)
            .getLeaveApplicationList(context: context);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<LeaveApplicationProvider>(
          builder: (context, leave, child) {
            List<LeaveApplicationModel> leaves = [];

            if (UserSharedPreferences.role == 'teacher') {
              List<StudentUserModel> students = [];

              Provider.of<AllUserProvider>(context).studentsList.forEach((element) {
                if (element.year == currentYear) {
                  students.add(element);
                }
              });

              for (var element in leave.leaveApplicationList) {
                for (var e in students) {
                  if (e.id == element.sid) {
                    if (element.status == status) {
                      leaves.add(element);
                    }
                  }
                }
              }
            } else {
              for (var element in leave.leaveApplicationList) {
                if (element.status == status && element.sid == UserSharedPreferences.id) {
                  leaves.add(element);
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
                        'Leaves',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              children: [
                                UserSharedPreferences.role == 'teacher'
                                    ? Flexible(
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
                                      )
                                    : Expanded(child: Container()),
                                Flexible(
                                  child: DropdownButtonFormField<String>(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    value: status,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'waiting',
                                        child: Text(
                                          'waiting',
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'approved',
                                        child: Text(
                                          'approved',
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'rejected',
                                        child: Text(
                                          'rejected',
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
                                        status = value;
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
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      sliver: SliverList.builder(
                        itemCount: leaves.isEmpty ? 1 : leaves.length,
                        itemBuilder: (context, index) {
                          if (leave.isLoading) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF2855AE),
                                ),
                              ),
                            );
                          }

                          if (leaves.isEmpty) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: Center(
                                child: Text(
                                  status == 'waiting'
                                      ? (UserSharedPreferences.role == 'student'
                                          ? 'There is no leaves which are waiting'
                                          : 'There are no leaves for approval')
                                      : status == 'approved'
                                          ? 'There are not any leave which are approved'
                                          : 'There are not any leave which are rejected',
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

                          LeaveApplicationModel l = leaves[index];

                          Widget container = Container(
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: l.status == "rejected"
                                    ? Colors.red.withOpacity(0.1)
                                    : l.status == "approved"
                                        ? Colors.green.withOpacity(0.1)
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        l.title,
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: l.status == "rejected"
                                              ? Colors.red.withOpacity(0.3)
                                              : l.status == "approved"
                                                  ? Colors.green.withOpacity(0.3)
                                                  : const Color(0xFFE6EFFF),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          l.status,
                                          style: GoogleFonts.rubik(
                                            color: l.status == "rejected"
                                                ? Colors.red
                                                : l.status == "approved"
                                                    ? Colors.green
                                                    : const Color(0xFF6789CA),
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
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.date_range_outlined,
                                        color: Color(0xFF6789CA),
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${DateFormat('dd MMM').format(DateTime.parse(l.startDate))} - ${DateFormat('dd MMM').format(DateTime.parse(l.endDate))}',
                                        style: GoogleFonts.rubik(
                                          color: const Color(0xFF6789CA),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    l.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rubik(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: UserSharedPreferences.role == 'teacher'
                                ? Dismissible(
                                    key: Key(l.lid),
                                    direction: DismissDirection.horizontal,
                                    onDismissed: (direction) {
                                      if (direction == DismissDirection.endToStart) {
                                        LeaveApplicationModel leaveApplication = l;
                                        leaveApplication.status = 'approved';

                                        leave.updateLeaveApplication(
                                            context: context,
                                            leaveApplicationModel: leaveApplication);
                                      } else if (direction == DismissDirection.startToEnd) {
                                        LeaveApplicationModel leaveApplication = l;
                                        leaveApplication.status = 'rejected';

                                        leave.updateLeaveApplication(
                                            context: context,
                                            leaveApplicationModel: leaveApplication);
                                      }
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      padding: const EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                      color: Colors.green,
                                      padding: const EdgeInsets.only(right: 10),
                                      alignment: Alignment.centerRight,
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    child: container,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (l.status == 'waiting') {
                                        bottomSheetForLeaveApplication(
                                            context: context,
                                            isEdit: true,
                                            leaveApplicationModel: l);
                                      }
                                    },
                                    child: container,
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
        floatingActionButton: UserSharedPreferences.role == 'student'
            ? GestureDetector(
                onTap: () => bottomSheetForLeaveApplication(context: context),
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
