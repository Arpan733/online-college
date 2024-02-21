import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/providers/assignment_provider.dart';
import 'package:online_college/providers/fee_provider.dart';
import 'package:online_college/providers/holiday_provider.dart';
import 'package:online_college/repositories/notifications.dart';
import 'package:provider/provider.dart';

import '../../consts/dashboard_lists.dart';
import '../../consts/user_shared_preferences.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    NotificationServices().firebaseInit(context);
    NotificationServices().setupInteractMessage(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<HolidayProvider>(context, listen: false)
          .checkTomorrowIsHoliday(context: context);

      if (UserSharedPreferences.role == 'student') {
        if (!mounted) return;
        await Provider.of<AssignmentProvider>(context, listen: false)
            .checkRemainingSubmission(context: context);

        if (!mounted) return;
        await Provider.of<FeeProvider>(context, listen: false).checkRemainingFees(context: context);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: 200,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                ),
              ),
              child: FlexibleSpaceBar(
                background: Image.asset('assets/images/background.png'),
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
                )),
            toolbarHeight: 150,
            title: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, ${UserSharedPreferences.name}',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, Routes.profile),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Hero(
                        tag: 'profilePhoto',
                        child: Image.network(
                          UserSharedPreferences.photoUrl,
                          fit: BoxFit.fitHeight,
                          errorBuilder:
                              (BuildContext context, Object error, StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/images/student.png',
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 135,
              ),
              itemCount: UserSharedPreferences.role == 'student'
                  ? functionalityListStudent.length
                  : functionalityListTeacher.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> current = UserSharedPreferences.role == 'student'
                    ? functionalityListStudent[index]
                    : functionalityListTeacher[index];

                Key uniqueKey = ValueKey<String>(current['name']);

                return GestureDetector(
                  onTap: () {
                    current['onTap'](context);
                  },
                  child: Container(
                    key: uniqueKey,
                    height: 135,
                    width: 165,
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FC),
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
        ],
      ),
    );
  }
}
