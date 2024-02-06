import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/route_name.dart';
import 'package:online_college/model/holiday_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';

import '../providers/holiday_provider.dart';

class Utils {
  List<Map<String, dynamic>> functionalityListTeacher = [
    {
      'name': 'Students',
      'image': 'assets/icons/student.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.studentList);
      },
    },
    {
      'name': 'Teachers',
      'image': 'assets/icons/professor.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.professorList);
      },
    },
    {
      'name': 'Assignments',
      'image': 'assets/icons/assignment.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.assignment);
      },
    },
    {
      'name': 'School Holidays',
      'image': 'assets/icons/holiday.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.schoolHoliday);
      },
    },
    {
      'name': 'Time Table',
      'image': 'assets/icons/timetable.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.timetable);
      },
    },
    {
      'name': 'Ask Doubts',
      'image': 'assets/icons/doubts.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.doubts);
      },
    },
    {
      'name': 'School Gallery',
      'image': 'assets/icons/school_gallery.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.schoolGallery);
      },
    },
    {
      'name': 'Leave Application',
      'image': 'assets/icons/leave_application.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.leaveApplication);
      },
    },
    {
      'name': 'Events',
      'image': 'assets/icons/event.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.events);
      },
    },
    {
      'name': 'Log Out',
      'image': 'assets/icons/logout.png',
      'onTap': (BuildContext context) async {
        await FirebaseAuth.instance.signOut();
        SharedPreferences preference = await SharedPreferences.getInstance();
        await preference.clear();

        if (!context.mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.login,
          (route) => false,
        );
      },
    },
  ];

  List<Map<String, dynamic>> functionalityListStudent = [
    {
      'name': 'Assignments',
      'image': 'assets/icons/assignment.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.assignment);
      },
    },
    {
      'name': 'School Holidays',
      'image': 'assets/icons/holiday.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.schoolHoliday);
      },
    },
    {
      'name': 'Time Table',
      'image': 'assets/icons/timetable.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.timetable);
      },
    },
    {
      'name': 'Ask Doubts',
      'image': 'assets/icons/doubts.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.doubts);
      },
    },
    {
      'name': 'School Gallery',
      'image': 'assets/icons/school_gallery.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.schoolGallery);
      },
    },
    {
      'name': 'Leave Application',
      'image': 'assets/icons/leave_application.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.leaveApplication);
      },
    },
    {
      'name': 'Events',
      'image': 'assets/icons/event.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.events);
      },
    },
    {
      'name': 'Log Out',
      'image': 'assets/icons/logout.png',
      'onTap': (BuildContext context) async {
        await FirebaseAuth.instance.signOut();
        SharedPreferences preference = await SharedPreferences.getInstance();
        await preference.clear();

        if (!context.mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.login,
          (route) => false,
        );
      },
    },
  ];

  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    return emailRegExp.hasMatch(email);
  }

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF21827E),
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  bottomSheet({
    bool isEdit = false,
    String title = '',
    String description = '',
    String hid = '',
    String date = '',
    required BuildContext context,
  }) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    DateTime dateTime = DateTime.now();

    if (title != '' && description != '' && hid != '' && date != '') {
      titleController.text = title;
      descriptionController.text = description;
      dateTime = DateTime.parse(date);
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
              height: 400,
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
              child: Column(
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
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: descriptionController,
                      cursorColor: const Color(0xFF6688CA),
                      cursorWidth: 3,
                      maxLines: 4,
                      style: GoogleFonts.rubik(
                        color: const Color(0xFF6688CA),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.description_outlined,
                          color: Color(0xFF6688CA),
                        ),
                        label: Text(
                          'Description',
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                          ),
                        ),
                        hintText: 'Description',
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
                          'Date: ',
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
                            initialDate: dateTime,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2030),
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
                              dateTime = dateTime.copyWith(
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
                            DateFormat('dd/MM/yyyy').format(dateTime),
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
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          margin: const EdgeInsets.only(top: 30),
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
                          if (titleController.text.isEmpty) {
                            showToast('Please fill the title to add Holiday');
                          } else if (descriptionController.text.isEmpty) {
                            showToast('Please fill the description to add Holiday');
                          } else if (!dateTime.isAfter(DateTime.now())) {
                            showToast('Please choose right date to add Holiday');
                          } else {
                            if (isEdit) {
                              await getHolidayProvider(context).editHoliday(
                                title: titleController.text,
                                description: descriptionController.text,
                                date: dateTime.toString(),
                                hid: hid,
                              );

                              if (!context.mounted) return;
                              await getHolidayProvider(context).getHolidayList();
                            } else {
                              await getHolidayProvider(context).addHoliday(
                                title: titleController.text,
                                description: descriptionController.text,
                                date: dateTime.toString(),
                              );

                              if (!context.mounted) return;
                              await getHolidayProvider(context).getHolidayList();
                            }

                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          margin: const EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isEdit ? 'Edit' : 'Save',
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

  showDialogForHolidayList(
      {required BuildContext context,
      required HolidayModel hc,
      required onEdit,
      required onDelete,
      required onOk}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          height: 240,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextScroll(
                hc.title!,
                mode: TextScrollMode.endless,
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                delayBefore: const Duration(milliseconds: 1000),
                pauseBetween: const Duration(milliseconds: 500),
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                DateFormat('d MMM, EEEE').format(DateTime.parse(hc.date!)),
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.white,
                height: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    hc.description!,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          height: 40,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          height: 40,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Color(0xFF6688CA),
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onOk,
                    child: Container(
                      height: 40,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Ok',
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
            ],
          ),
        ),
      ),
    );
  }
}
