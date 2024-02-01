import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_college/consts/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      'image': 'assets/icons/holidays.png',
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
      'image': 'assets/icons/gallery.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.schoolGallery);
      },
    },
    {
      'name': 'Leave Application',
      'image': 'assets/icons/leave.png',
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
      'image': 'assets/icons/holidays.png',
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
      'image': 'assets/icons/gallery.png',
      'onTap': (BuildContext context) {
        Navigator.pushNamed(context, RoutesName.schoolGallery);
      },
    },
    {
      'name': 'Leave Application',
      'image': 'assets/icons/leave.png',
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

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFF21827E),
      textColor: Colors.white,
      fontSize: 16,
    );
  }
}
