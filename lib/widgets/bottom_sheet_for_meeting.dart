import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/meeting_model.dart';
import 'package:online_college/providers/meeting_provider.dart';
import 'package:online_college/repositories/meeting_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

bottomSheetForMeeting({
  bool isEdit = false,
  MeetingModel? meetingModel,
  required BuildContext context,
}) {
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  DateTime meetingDateTime = DateTime.now();
  List<String> selectedYears = [];

  if (meetingModel != null) {
    titleController.text = meetingModel.title;
    meetingDateTime = DateTime.parse(meetingModel.time);
    selectedYears = meetingModel.year;
  }

  showModalBottomSheet(
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, set) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 440,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/background 2.png'),
              ),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2855AE),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: titleController,
                          cursorColor: const Color(0xFF6688CA),
                          cursorWidth: 3,
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              color: Color(0xFF6688CA),
                            ),
                            label: Text(
                              'Title',
                              style: GoogleFonts.rubik(
                                color: const Color(0xFF6688CA),
                              ),
                            ),
                            hintText: 'Title',
                            hintStyle: GoogleFonts.rubik(
                              color: const Color(0xFF6688CA),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            child: Text(
                              'Due Date: ',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: meetingDateTime,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 30)),
                                helpText: 'Select the date: ',
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme(
                                          brightness: Brightness.light,
                                          primary: Color(0xFF6688CA),
                                          onPrimary: Colors.white,
                                          secondary: Color(0xFF6688CA),
                                          onSecondary: Colors.white,
                                          error: Color(0xFF6688CA),
                                          onError: Colors.white,
                                          background: Colors.white,
                                          onBackground: Color(0xFF6688CA),
                                          surface: Colors.white,
                                          onSurface: Color(0xFF6688CA),
                                        ),
                                        textTheme: GoogleFonts.rubikTextTheme().copyWith(
                                          bodyMedium: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: const Color(0xFF6688CA),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                set(() {
                                  meetingDateTime = meetingDateTime.copyWith(
                                    day: pickedDate.day,
                                    month: pickedDate.month,
                                    year: pickedDate.year,
                                  );
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(meetingDateTime),
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) * 0.5,
                            child: CheckboxListTile(
                              title: Text(
                                '1st Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedYears.contains('1st Year'),
                              activeColor: Colors.white,
                              checkColor: const Color(0xFF6688CA),
                              onChanged: (value) {
                                if (value != null) {
                                  set(() {
                                    if (value) {
                                      selectedYears.add('1st Year');
                                    } else {
                                      selectedYears.remove('1st Year');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) * 0.5,
                            child: CheckboxListTile(
                              title: Text(
                                '2nd Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedYears.contains('2nd Year'),
                              activeColor: Colors.white,
                              checkColor: const Color(0xFF6688CA),
                              onChanged: (value) {
                                if (value != null) {
                                  set(() {
                                    if (value) {
                                      selectedYears.add('2nd Year');
                                    } else {
                                      selectedYears.remove('2nd Year');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) * 0.5,
                            child: CheckboxListTile(
                              title: Text(
                                '3rd Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedYears.contains('3rd Year'),
                              activeColor: Colors.white,
                              checkColor: const Color(0xFF6688CA),
                              onChanged: (value) {
                                if (value != null) {
                                  set(() {
                                    if (value) {
                                      selectedYears.add('3rd Year');
                                    } else {
                                      selectedYears.remove('3rd Year');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) * 0.5,
                            child: CheckboxListTile(
                              title: Text(
                                '4th Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedYears.contains('4th Year'),
                              activeColor: Colors.white,
                              checkColor: const Color(0xFF6688CA),
                              onChanged: (value) {
                                if (value != null) {
                                  set(() {
                                    if (value) {
                                      selectedYears.add('4th Year');
                                    } else {
                                      selectedYears.remove('4th Year');
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            child: Text(
                              'Time: ',
                              style: GoogleFonts.robotoMono(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(meetingDateTime),
                                helpText: 'Select the time: ',
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme(
                                        brightness: Brightness.light,
                                        primary: Color(0xFF6688CA),
                                        onPrimary: Colors.white,
                                        secondary: Color(0xFF6688CA),
                                        onSecondary: Colors.white,
                                        error: Color(0xFF6688CA),
                                        onError: Colors.white,
                                        background: Colors.white,
                                        onBackground: Color(0xFF6688CA),
                                        surface: Colors.white,
                                        onSurface: Color(0xFF6688CA),
                                      ),
                                      textTheme: GoogleFonts.robotoMonoTextTheme().copyWith(
                                        bodyMedium: GoogleFonts.rubik(
                                          fontSize: 16,
                                          color: const Color(0xFF6688CA),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (time != null) {
                                set(() {
                                  meetingDateTime = meetingDateTime.copyWith(
                                    hour: time.hour,
                                    minute: time.minute,
                                  );
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                DateFormat('hh:mm aa').format(meetingDateTime),
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              margin: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              isLoading = true;
                              set(() {});

                              if (titleController.text.isEmpty) {
                                Utils().showToast(
                                    context: context,
                                    message: 'Please fill the title to add Meeting');
                              } else {
                                if (isEdit) {
                                  String t = await MeetingFireStore().generateToken(
                                    context: context,
                                    channelName: titleController.text.split(" ").join(),
                                    time: meetingDateTime,
                                  );

                                  MeetingModel meeting = MeetingModel(
                                    mid: meetingModel!.mid,
                                    year: selectedYears,
                                    title: titleController.text,
                                    time: meetingDateTime.toString(),
                                    channelName: titleController.text.split(" ").join(),
                                    agoraToken: t,
                                    createdTime: meetingModel.createdTime,
                                  );

                                  if (!context.mounted) return;
                                  await Provider.of<MeetingProvider>(context, listen: false)
                                      .updateMeeting(context: context, meetingModel: meeting);
                                } else {
                                  String mid = const UuidV4().generate().toString();

                                  String t = await MeetingFireStore().generateToken(
                                    context: context,
                                    channelName: titleController.text.split(" ").join(),
                                    time: meetingDateTime,
                                  );

                                  MeetingModel meeting = MeetingModel(
                                    mid: mid,
                                    year: selectedYears,
                                    title: titleController.text,
                                    time: meetingDateTime.toString(),
                                    channelName: titleController.text.split(" ").join(),
                                    agoraToken: t,
                                    createdTime: DateTime.now().toString(),
                                  );

                                  if (!context.mounted) return;
                                  await Provider.of<MeetingProvider>(context, listen: false)
                                      .addMeeting(context: context, meetingModel: meeting);
                                }

                                isLoading = false;
                                set(() {});

                                if (!context.mounted) return;
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              margin: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isEdit ? 'Edit' : 'Add',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      });
    },
  );
}
