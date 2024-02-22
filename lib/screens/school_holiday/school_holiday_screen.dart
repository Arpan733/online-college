import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/model/holiday_model.dart';
import 'package:online_college/providers/holiday_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../consts/user_shared_preferences.dart';
import '../../widgets/bottom_sheet_for_holiday.dart';
import '../../widgets/dialog_for_holiday.dart';

class SchoolHolidayScreen extends StatefulWidget {
  const SchoolHolidayScreen({Key? key}) : super(key: key);

  @override
  State<SchoolHolidayScreen> createState() => _SchoolHolidayScreenState();
}

class _SchoolHolidayScreenState extends State<SchoolHolidayScreen> {
  List<HolidayModel> showList = [];
  bool isSelected = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HolidayProvider>(context, listen: false).getHolidayList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<HolidayProvider>(context, listen: false).getHolidayList(context: context);
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<HolidayProvider>(
          builder: (context, holiday, child) {
            List<HolidayModel> mainList = [];
            List<DateTime> dateTimeList = [];

            for (var element in holiday.holidays) {
              if (DateTime.parse(element.date!).month == holiday.focusedDay.month) {
                mainList.add(element);
                dateTimeList.add(DateTime.parse(element.date!));
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
                        'Holiday',
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
                            TableCalendar(
                              firstDay: DateTime(DateTime.now().year - 2, DateTime.now().month,
                                  DateTime.now().day),
                              lastDay: DateTime(DateTime.now().year + 2, DateTime.now().month,
                                  DateTime.now().day),
                              focusedDay: holiday.focusedDay,
                              calendarFormat: CalendarFormat.month,
                              rowHeight: 50,
                              calendarStyle: CalendarStyle(
                                defaultTextStyle: GoogleFonts.rubik(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                holidayDecoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                holidayTextStyle: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                outsideTextStyle: GoogleFonts.rubik(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                selectedDecoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                  ),
                                ),
                                selectedTextStyle: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: const Color(0xFF6688CA).withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                todayTextStyle: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              daysOfWeekHeight: 30,
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: GoogleFonts.rubik(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                weekendStyle: GoogleFonts.rubik(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              holidayPredicate: (DateTime date) {
                                if ((date.weekday == DateTime.sunday) ||
                                    (dateTimeList.any((element) => element.day == date.day))) {
                                  return true;
                                }

                                return false;
                              },
                              onHeaderTapped: (dateTime) {
                                isSelected = false;
                                showList.clear();

                                setState(() {});
                              },
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: GoogleFonts.rubik(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                leftChevronMargin: const EdgeInsets.only(right: 50),
                                leftChevronIcon: const Icon(
                                  Icons.chevron_left_outlined,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                rightChevronMargin: const EdgeInsets.only(left: 50),
                                rightChevronIcon: const Icon(
                                  Icons.chevron_right_outlined,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                headerMargin: const EdgeInsets.only(bottom: 5),
                              ),
                              selectedDayPredicate: (day) {
                                return isSameDay(holiday.selectedDay, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                showList = [];

                                for (var element in mainList) {
                                  if (DateTime.parse(element.date!).day == selectedDay.day) {
                                    showList.add(element);
                                  }
                                }

                                isSelected = true;

                                setState(() {
                                  holiday.setFocusDay(focusedDay);
                                  holiday.setSelectedDay(selectedDay);
                                });
                              },
                              onPageChanged: (focusedDay) {
                                holiday.setFocusDay(focusedDay);
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'List of Holiday',
                              style: GoogleFonts.rubik(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
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
                        itemCount: showList.isNotEmpty ? showList.length : mainList.length,
                        itemBuilder: (context, index) {
                          HolidayModel hc = showList.isNotEmpty ? showList[index] : mainList[index];

                          return GestureDetector(
                            onLongPress: () => showDialogForHolidayList(
                              context: context,
                              hc: hc,
                              onEdit: () async {
                                if (!context.mounted) return;
                                Navigator.pop(context);

                                await bottomSheetForHoliday(
                                  context: context,
                                  title: hc.title!,
                                  description: hc.description!,
                                  date: hc.date!,
                                  hid: hc.hid!,
                                  isEdit: true,
                                );
                              },
                              onDelete: () async {
                                await Provider.of<HolidayProvider>(context, listen: false)
                                    .deleteHoliday(context: context, hid: hc.hid!);

                                if (!context.mounted) return;
                                Navigator.pop(context);

                                if (!context.mounted) return;
                                await Provider.of<HolidayProvider>(context, listen: false)
                                    .getHolidayList(context: context);
                              },
                              onOk: () {
                                Navigator.pop(context);
                              },
                            ),
                            onTap: () {
                              DateTime sd = DateTime.parse(hc.date!);
                              holiday.setSelectedDay(sd);

                              showList = [];

                              for (var element in mainList) {
                                if (DateTime.parse(element.date!).day == holiday.selectedDay?.day) {
                                  showList.add(element);
                                }
                              }

                              isSelected = true;

                              setState(() {});
                            },
                            child: Container(
                              height: 80,
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hc.title ?? '',
                                    style: GoogleFonts.rubik(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('d MMMM')
                                            .format(DateTime.parse(hc.date!))
                                            .toString(),
                                        style: GoogleFonts.rubik(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('EEEE').format(DateTime.parse(hc.date!)),
                                        style: GoogleFonts.rubik(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
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
                onTap: () async {
                  await bottomSheetForHoliday(
                    context: context,
                  );
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
              )
            : null,
      ),
    );
  }
}
