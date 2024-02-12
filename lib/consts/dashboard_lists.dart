import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> functionalityListTeacher = [
  {
    'name': 'Students',
    'image': 'assets/icons/student.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.studentList);
    },
  },
  {
    'name': 'Teachers',
    'image': 'assets/icons/professor.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.professorList);
    },
  },
  {
    'name': 'Fees',
    'image': 'assets/icons/fees.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.fees);
    },
  },
  {
    'name': 'Results',
    'image': 'assets/icons/result.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.resultTeacher);
    },
  },
  {
    'name': 'Assignments',
    'image': 'assets/icons/assignment.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.assignment);
    },
  },
  {
    'name': 'School Holidays',
    'image': 'assets/icons/holiday.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.schoolHoliday);
    },
  },
  {
    'name': 'Time Table',
    'image': 'assets/icons/timetable.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.timetable);
    },
  },
  {
    'name': 'Ask Doubts',
    'image': 'assets/icons/doubts.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.doubts);
    },
  },
  {
    'name': 'School Gallery',
    'image': 'assets/icons/school_gallery.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.schoolGallery);
    },
  },
  {
    'name': 'Leave Application',
    'image': 'assets/icons/leave_application.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.leaveApplication);
    },
  },
  {
    'name': 'Events',
    'image': 'assets/icons/event.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.events);
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
        Routes.login,
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
      Navigator.pushNamed(context, Routes.assignment);
    },
  },
  {
    'name': 'School Holidays',
    'image': 'assets/icons/holiday.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.schoolHoliday);
    },
  },
  {
    'name': 'Time Table',
    'image': 'assets/icons/timetable.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.timetable);
    },
  },
  {
    'name': 'Fees',
    'image': 'assets/icons/fees.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.fees);
    },
  },
  {
    'name': 'Results',
    'image': 'assets/icons/result.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.resultStudent);
    },
  },
  {
    'name': 'Ask Doubts',
    'image': 'assets/icons/doubts.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.doubts);
    },
  },
  {
    'name': 'School Gallery',
    'image': 'assets/icons/school_gallery.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.schoolGallery);
    },
  },
  {
    'name': 'Leave Application',
    'image': 'assets/icons/leave_application.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.leaveApplication);
    },
  },
  {
    'name': 'Events',
    'image': 'assets/icons/event.png',
    'onTap': (BuildContext context) {
      Navigator.pushNamed(context, Routes.events);
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
        Routes.login,
        (route) => false,
      );
    },
  },
];
