import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/bottom_sheet_for_student.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  String currentYear = '1st Year';

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<AllUserProvider>(context, listen: false).getAllUser(context: context);
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<AllUserProvider>(
          builder: (context, users, child) {
            List<StudentUserModel> u = [];

            for (var element in users.studentsList) {
              if (element.year == currentYear) {
                u.add(element);
              }
            }

            u.sort(
              (a, b) {
                int aDate = int.parse(a.rollNo);
                int bDate = int.parse(b.rollNo);
                return aDate.compareTo(bDate);
              },
            );

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
                        'Students',
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
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      sliver: SliverList.builder(
                        itemCount: u.length,
                        itemBuilder: (context, index) {
                          if (users.isLoading) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF2855AE),
                                ),
                              ),
                            );
                          }

                          if (u.isEmpty) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: Center(
                                child: Text(
                                  'There is not student in the $currentYear.',
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }

                          StudentUserModel su = u[index];

                          return GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, arguments: su.id, Routes.userDetail),
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Hero(
                                    tag: su.id,
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft,
                                          colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        su.photoUrl,
                                        fit: BoxFit.fitHeight,
                                        errorBuilder: (BuildContext context, Object error,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                            'assets/images/student.png',
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          su.name,
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '+91 ${su.phoneNumber}',
                                          style: GoogleFonts.rubik(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    su.rollNo,
                                    style: GoogleFonts.rubik(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
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
        floatingActionButton: GestureDetector(
          onTap: () async {
            await bottomSheetForStudent(context: context);
          },
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
