import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/meeting_model.dart';
import 'package:online_college/providers/meeting_provider.dart';
import 'package:online_college/widgets/bottom_sheet_for_meeting.dart';
import 'package:provider/provider.dart';

class MeetingListScreen extends StatefulWidget {
  const MeetingListScreen({super.key});

  @override
  State<MeetingListScreen> createState() => _MeetingListScreenState();
}

class _MeetingListScreenState extends State<MeetingListScreen> {
  String sort = 'All';

  List<String> dropDownList = UserSharedPreferences.role == 'teacher'
      ? [
          "All",
          "Created Time",
          "Meeting Time",
          "Upcoming Meeting",
          "Completed Meeting",
          "1st Year",
          "2nd Year",
          "3rd Year",
          "4th Year"
        ]
      : ["All", "Created Time", "Meeting Time", "Upcoming Meeting", "Completed Meeting"];

  List<DropdownMenuItem<String>> dropDowns = [];
  List<MeetingModel> showMeetingList = [];

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
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<MeetingProvider>(context, listen: false).getMeetingList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<MeetingProvider>(context, listen: false).getMeetingList(context: context);

        if (!context.mounted) return;
        showMeetingList = UserSharedPreferences.role == 'teacher'
            ? Provider.of<MeetingProvider>(context, listen: false)
                .teacherSorting(context: context, sort: sort)
            : Provider.of<MeetingProvider>(context, listen: false)
                .studentSorting(context: context, sort: sort);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
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
            Consumer<MeetingProvider>(
              builder: (context, meeting, _) {
                showMeetingList = UserSharedPreferences.role == 'teacher'
                    ? meeting.teacherSorting(context: context, sort: sort)
                    : meeting.studentSorting(context: context, sort: sort);

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
                          'Meeting',
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
                                    showMeetingList = UserSharedPreferences.role == 'teacher'
                                        ? meeting.teacherSorting(context: context, sort: sort)
                                        : meeting.studentSorting(context: context, sort: sort);

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
                          itemCount: showMeetingList.isEmpty ? 1 : showMeetingList.length,
                          itemBuilder: (context, index) {
                            if (meeting.isLoading) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2855AE),
                                  ),
                                ),
                              );
                            }

                            if (showMeetingList.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: Center(
                                  child: Text(
                                    UserSharedPreferences.role == 'teacher'
                                        ? (["1st Year", "2nd Year", "3rd Year", "4th Year"]
                                                .contains(sort)
                                            ? 'There is not any meeting given by $sort students.'
                                            : 'There is no meeting')
                                        : 'There is no meeting',
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

                            MeetingModel m = showMeetingList[index];

                            return GestureDetector(
                              onTap: () {
                                if (DateTime.now().isAfter(DateTime.parse(m.time)
                                        .subtract(const Duration(minutes: 5))) &&
                                    DateTime.now().isBefore(
                                        DateTime.parse(m.time).add(const Duration(hours: 3)))) {
                                  Navigator.pushNamed(context, arguments: m.mid, Routes.meeting);
                                } else {
                                  if (!DateTime.now().isAfter(DateTime.parse(m.time)
                                      .subtract(const Duration(minutes: 5)))) {
                                    Utils().showToast(
                                        context: context, message: 'Meeting has time to start');
                                  } else if (!DateTime.now().isBefore(
                                      DateTime.parse(m.time).add(const Duration(hours: 3)))) {
                                    Utils()
                                        .showToast(context: context, message: 'Meeting has ended');
                                  }
                                }
                              },
                              onLongPress: () => UserSharedPreferences.role == 'teacher'
                                  ? bottomSheetForMeeting(
                                      context: context, isEdit: true, meetingModel: m)
                                  : null,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 60,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: DateTime.now().isAfter(DateTime.parse(m.time)
                                                .subtract(const Duration(minutes: 5))) &&
                                            DateTime.now().isBefore(DateTime.parse(m.time)
                                                .add(const Duration(hours: 3)))
                                        ? Colors.green.withOpacity(0.2)
                                        : DateTime.parse(m.time).isBefore(
                                                DateTime.now().subtract(const Duration(hours: 3)))
                                            ? Colors.black12
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.black38,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: m.year
                                            .map(
                                              (e) => Container(
                                                margin: const EdgeInsets.only(right: 10),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE6EFFF),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  e,
                                                  style: GoogleFonts.rubik(
                                                    color: const Color(0xFF6789CA),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        m.title,
                                        maxLines: 1,
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.timer_outlined,
                                            color: Colors.black54,
                                            size: 18,
                                          ),
                                          Text(
                                            '  Meeting Time:  ',
                                            style: GoogleFonts.rubik(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('dd/MM/yyyy hh:mm aa')
                                                .format(DateTime.parse(m.time))
                                                .toString(),
                                            style: GoogleFonts.rubik(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
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
                onTap: () => bottomSheetForMeeting(context: context),
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
