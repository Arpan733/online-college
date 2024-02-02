import 'package:flutter/material.dart';
import 'package:online_college/consts/route_name.dart';
import 'package:online_college/screens/assignment_screen.dart';
import 'package:online_college/screens/dashboard_screen.dart';
import 'package:online_college/screens/doubts_screen.dart';
import 'package:online_college/screens/events_screen.dart';
import 'package:online_college/screens/leave_application_screen.dart';
import 'package:online_college/screens/login_screen.dart';
import 'package:online_college/screens/professor_list_screen.dart';
import 'package:online_college/screens/profile_screen.dart';
import 'package:online_college/screens/school_gallary_screen.dart';
import 'package:online_college/screens/school_holiday_screen.dart';
import 'package:online_college/screens/splash_screen.dart';
import 'package:online_college/screens/student_list_screen.dart';
import 'package:online_college/screens/timetable_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DashBoardScreen());
      case RoutesName.profile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileScreen());
      case RoutesName.assignment:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AssignmentScreen());
      case RoutesName.doubts:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DoubtScreen());
      case RoutesName.events:
        return MaterialPageRoute(
            builder: (BuildContext context) => const EventScreen());
      case RoutesName.leaveApplication:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LeaveApplicationScreen());
      case RoutesName.schoolGallery:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SchoolGalleryScreen());
      case RoutesName.schoolHoliday:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SchoolHolidayScreen());
      case RoutesName.studentList:
        return MaterialPageRoute(
            builder: (BuildContext context) => const StudentListScreen());
      case RoutesName.professorList:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfessorListScreen());
      case RoutesName.timetable:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TimeTableScreen());
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined!'),
              ),
            );
          },
        );
    }
  }
}
