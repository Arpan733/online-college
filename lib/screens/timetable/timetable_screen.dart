import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/model/time_table_model.dart';
import 'package:online_college/providers/time_table_provider.dart';
import 'package:provider/provider.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({Key? key}) : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> with SingleTickerProviderStateMixin {
  String currentYear = '1st Year';
  TabController? tabController;

  int today = DateTime.now().day == DateTime.monday
      ? 0
      : DateTime.now().day == DateTime.tuesday
          ? 1
          : DateTime.now().day == DateTime.wednesday
              ? 3
              : DateTime.now().day == DateTime.thursday
                  ? 4
                  : 5;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TimeTableProvider>(context, listen: false).getTimeTableList(context: context);
    });

    tabController = TabController(length: 5, vsync: this);

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
          Consumer<TimeTableProvider>(
            builder: (context, tt, child) {
              int period = 0;

              TimeTableModel ttData = TimeTableModel(
                year: 'year',
                timetable: Timetable(
                  mon: [Clas(subject: '', time: '')],
                  tue: [Clas(subject: '', time: '')],
                  wed: [Clas(subject: '', time: '')],
                  thu: [Clas(subject: '', time: '')],
                  fri: [Clas(subject: '', time: '')],
                ),
              );

              List<Clas> dayData = [];

              if (UserSharedPreferences.role == 'student') {
                for (var element in tt.timeTableList) {
                  if (element.year == UserSharedPreferences.year) {
                    ttData = element;
                  }
                }
                dayData = tabController?.index == 0
                    ? ttData.timetable.mon
                    : tabController?.index == 1
                        ? ttData.timetable.tue
                        : tabController?.index == 2
                            ? ttData.timetable.wed
                            : tabController?.index == 3
                                ? ttData.timetable.thu
                                : ttData.timetable.fri;
                dayData = dayData.sublist(1);
              } else {
                for (var element in tt.timeTableList) {
                  if (element.year == currentYear) {
                    ttData = element;
                  }
                }
                dayData = tabController?.index == 0
                    ? ttData.timetable.mon
                    : tabController?.index == 1
                        ? ttData.timetable.tue
                        : tabController?.index == 2
                            ? ttData.timetable.wed
                            : tabController?.index == 3
                                ? ttData.timetable.thu
                                : ttData.timetable.fri;
                dayData = dayData.sublist(1);
              }

              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
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
                      'Time Table',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      tt.isLoading
                          ? [
                              SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2855AE),
                                  ),
                                ),
                              ),
                            ]
                          : [
                              if (UserSharedPreferences.role == 'teacher')
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
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
                                              tabController?.index = 0;

                                              for (var element in tt.timeTableList) {
                                                if (element.year == currentYear) {
                                                  ttData = element;
                                                }
                                              }
                                              dayData = tabController?.index == 0
                                                  ? ttData.timetable.mon
                                                  : tabController?.index == 1
                                                      ? ttData.timetable.tue
                                                      : tabController?.index == 2
                                                          ? ttData.timetable.wed
                                                          : tabController?.index == 3
                                                              ? ttData.timetable.thu
                                                              : ttData.timetable.fri;
                                              dayData = dayData.sublist(1);

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
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                child: DefaultTabController(
                                  length: 5,
                                  child: TabBar(
                                    padding: EdgeInsets.zero,
                                    labelPadding: EdgeInsets.zero,
                                    indicatorPadding: EdgeInsets.zero,
                                    splashBorderRadius: BorderRadius.circular(20),
                                    controller: tabController,
                                    indicatorColor: Colors.transparent,
                                    dividerColor: Colors.transparent,
                                    labelStyle: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    unselectedLabelStyle: GoogleFonts.rubik(
                                      color: Colors.black54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    onTap: (value) {
                                      setState(() {});
                                    },
                                    tabs: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: tabController?.index == 0
                                              ? const Color(0xFF6789CA)
                                              : Colors.transparent,
                                        ),
                                        child: const Text(
                                          "Mon",
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: tabController?.index == 1
                                              ? const Color(0xFF6789CA)
                                              : Colors.transparent,
                                        ),
                                        child: const Text(
                                          "Tue",
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: tabController?.index == 2
                                              ? const Color(0xFF6789CA)
                                              : Colors.transparent,
                                        ),
                                        child: const Text(
                                          "Wed",
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: tabController?.index == 3
                                              ? const Color(0xFF6789CA)
                                              : Colors.transparent,
                                        ),
                                        child: const Text(
                                          "Thu",
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: tabController?.index == 4
                                              ? const Color(0xFF6789CA)
                                              : Colors.transparent,
                                        ),
                                        child: const Text(
                                          "Fri",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                height: UserSharedPreferences.role == 'student'
                                    ? MediaQuery.of(context).size.height - 195
                                    : MediaQuery.of(context).size.height - 245,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: dayData.length,
                                  itemBuilder: (context, index) {
                                    Clas c = dayData[index];

                                    if (c.subject != "No Class" &&
                                        c.subject != "Short Break" &&
                                        c.subject != "Lunch Break") {
                                      period++;
                                    }

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFFE1E3E8),
                                        ),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: c.subject != "No Class" &&
                                                  c.subject != "Short Break" &&
                                                  c.subject != "Lunch Break"
                                              ? Colors.white
                                              : c.subject != "No Class"
                                                  ? Colors.green.withOpacity(0.1)
                                                  : Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: const Color(0xFFE1E3E8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  c.subject,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  c.time,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            c.subject != "No Class" &&
                                                    c.subject != "Short Break" &&
                                                    c.subject != "Lunch Break"
                                                ? Text(
                                                    'Period $period',
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    c.subject != "No Class"
                                                        ? 'assets/images/break.png'
                                                        : 'assets/images/beach.png',
                                                    height: 40,
                                                    width: 40,
                                                    fit: BoxFit.cover,
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
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
