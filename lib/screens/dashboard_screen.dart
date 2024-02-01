import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/route_name.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/providers/teacher_data_local_storage_provider.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF21827E),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 125,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<TeacherSharedPreferencesProvider>(
                    builder: (context, teacher, _) => Text(
                      'Hi, ${teacher.name ?? ''}',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.profile);
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/student.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 135,
                  ),
                  itemCount: Utils().functionalityListTeacher.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> current =
                        Utils().functionalityListTeacher[index];

                    return GestureDetector(
                      onTap: () {
                        current['onTap'](context);
                      },
                      child: Container(
                        height: 135,
                        width: 165,
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21827E).withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Image.asset(current['image']),
                            ),
                            Text(
                              current['name'],
                              style: GoogleFonts.rubik(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
