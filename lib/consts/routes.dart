import 'package:flutter/material.dart';
import 'package:online_college/consts/route_name.dart';
import 'package:online_college/screens/assignments/assignment_screen.dart';
import 'package:online_college/screens/dashboard/dashboard_screen.dart';
import 'package:online_college/screens/dashboard/profile_screen.dart';
import 'package:online_college/screens/doubts/doubts_screen.dart';
import 'package:online_college/screens/events/events_screen.dart';
import 'package:online_college/screens/fees/add_edit_fee.dart';
import 'package:online_college/screens/fees/fee_detail_screen.dart';
import 'package:online_college/screens/fees/fee_pay_screen.dart';
import 'package:online_college/screens/fees/fee_receipt_screen.dart';
import 'package:online_college/screens/fees/fees_screen.dart';
import 'package:online_college/screens/leave_application/leave_application_screen.dart';
import 'package:online_college/screens/login/login_screen.dart';
import 'package:online_college/screens/professor_list/professor_list_screen.dart';
import 'package:online_college/screens/results/add_edit_result.dart';
import 'package:online_college/screens/results/result_screen_for_student.dart';
import 'package:online_college/screens/results/result_screen_for_teacher.dart';
import 'package:online_college/screens/school_gallery/school_gallery_screen.dart';
import 'package:online_college/screens/school_holiday/school_holiday_screen.dart';
import 'package:online_college/screens/splash_screen.dart';
import 'package:online_college/screens/student_list/student_list_screen.dart';
import 'package:online_college/screens/timetable/timetable_screen.dart';

import '../model/fee_model.dart';
import '../model/result_model.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => const SplashScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => const LoginScreen());
      case RoutesName.dashboard:
        return MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen());
      case RoutesName.profile:
        return MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen());
      case RoutesName.assignment:
        return MaterialPageRoute(builder: (BuildContext context) => const AssignmentScreen());
      case RoutesName.doubts:
        return MaterialPageRoute(builder: (BuildContext context) => const DoubtScreen());
      case RoutesName.events:
        return MaterialPageRoute(builder: (BuildContext context) => const EventScreen());
      case RoutesName.leaveApplication:
        return MaterialPageRoute(builder: (BuildContext context) => const LeaveApplicationScreen());
      case RoutesName.schoolGallery:
        return MaterialPageRoute(builder: (BuildContext context) => const SchoolGalleryScreen());
      case RoutesName.schoolHoliday:
        return MaterialPageRoute(builder: (BuildContext context) => const SchoolHolidayScreen());
      case RoutesName.studentList:
        return MaterialPageRoute(builder: (BuildContext context) => const StudentListScreen());
      case RoutesName.professorList:
        return MaterialPageRoute(builder: (BuildContext context) => const ProfessorListScreen());
      case RoutesName.timetable:
        return MaterialPageRoute(builder: (BuildContext context) => const TimeTableScreen());
      case RoutesName.fees:
        return MaterialPageRoute(builder: (BuildContext context) => const FeesScreen());
      case RoutesName.addEditFees:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                AddEditFees(feeModel: settings.arguments as FeeModel?));
      case RoutesName.feeDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                FeeDetailScreen(fee: settings.arguments as FeeModel));
      case RoutesName.feePay:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                FeePayScreen(feeModel: settings.arguments as FeeModel));
      case RoutesName.feeReceipt:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                FeeReceiptScreen(feeModel: settings.arguments as FeeModel));
      case RoutesName.resultTeacher:
        return MaterialPageRoute(builder: (BuildContext context) => const ResultScreenForTeacher());
      case RoutesName.resultStudent:
        return MaterialPageRoute(builder: (BuildContext context) => const ResultScreenForStudent());
      case RoutesName.addEditResult:
        return MaterialPageRoute(builder: (BuildContext context) {
          final arguments = settings.arguments as Map<dynamic, dynamic>?;

          // Provide default values if arguments is null or not a map
          final resultModel = (arguments?['resultModel'] as ResultModel?) ?? ResultModel();
          final result = (arguments?['result'] as Result?) ?? Result();

          // Navigate to the AddEditResult screen with the default values
          return AddEditResult(
            resultModel: resultModel,
            result: result,
          );

          // return AddEditResult(
          //     resultModel: (settings.arguments?['resultModel'] as ResultModel?) ?? ResultModel(),
          //     result: (settings.arguments?['result'] as Result?) ?? Result());
        });
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
