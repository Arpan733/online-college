import 'package:flutter/material.dart';
import 'package:online_college/model/result_model.dart';
import 'package:online_college/screens/assignments/assignment_detail_screen.dart';
import 'package:online_college/screens/assignments/assignment_screen.dart';
import 'package:online_college/screens/dashboard/dashboard_screen.dart';
import 'package:online_college/screens/dashboard/profile_screen.dart';
import 'package:online_college/screens/doubts/doubt_detail_screen.dart';
import 'package:online_college/screens/doubts/doubts_screen.dart';
import 'package:online_college/screens/events/event_detail_screen.dart';
import 'package:online_college/screens/events/events_screen.dart';
import 'package:online_college/screens/fees/add_edit_fee.dart';
import 'package:online_college/screens/fees/fee_detail_screen.dart';
import 'package:online_college/screens/fees/fee_pay_screen.dart';
import 'package:online_college/screens/fees/fee_receipt_screen.dart';
import 'package:online_college/screens/fees/fees_screen.dart';
import 'package:online_college/screens/leave_application/leave_application_screen.dart';
import 'package:online_college/screens/login/login_screen.dart';
import 'package:online_college/screens/material/material_screen.dart';
import 'package:online_college/screens/meeting/meeting_list_screen.dart';
import 'package:online_college/screens/meeting/meeting_screen.dart';
import 'package:online_college/screens/noticeboard/noticeboard_screen.dart';
import 'package:online_college/screens/professor_list/professor_list_screen.dart';
import 'package:online_college/screens/quiz/quiz_detail_screen.dart';
import 'package:online_college/screens/quiz/quiz_play_screen.dart';
import 'package:online_college/screens/quiz/quiz_question_screen.dart';
import 'package:online_college/screens/quiz/quiz_screen.dart';
import 'package:online_college/screens/results/add_edit_result.dart';
import 'package:online_college/screens/results/result_print_screen.dart';
import 'package:online_college/screens/results/result_screen_for_student.dart';
import 'package:online_college/screens/results/result_screen_for_teacher.dart';
import 'package:online_college/screens/school_gallery/school_gallery_screen.dart';
import 'package:online_college/screens/school_holiday/school_holiday_screen.dart';
import 'package:online_college/screens/splash_screen.dart';
import 'package:online_college/screens/student_list/student_list_screen.dart';
import 'package:online_college/screens/timetable/timetable_screen.dart';
import 'package:online_college/screens/users_details/user_details_screen.dart';

class Routes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String profile = 'profile';
  static const String assignment = 'assignments';
  static const String doubts = 'doubts';
  static const String events = 'events';
  static const String leaveApplication = 'leaveApplication';
  static const String professorList = 'professorList';
  static const String schoolGallery = 'schoolGallery';
  static const String schoolHoliday = 'schoolHoliday';
  static const String studentList = 'studentList';
  static const String timetable = 'timetable';
  static const String fees = 'fees';
  static const String addEditFees = 'addEditFees';
  static const String feeDetail = 'feeDetail';
  static const String feePay = 'feePay';
  static const String feeReceipt = 'feeReceipt';
  static const String resultTeacher = 'resultTeacher';
  static const String resultStudent = 'resultStudent';
  static const String addEditResult = 'addEditResult';
  static const String printResult = 'printResult';
  static const String doubtDetail = 'doubtDetail';
  static const String assignmentDetail = 'assignmentDetail';
  static const String eventDetail = 'eventDetail';
  static const String userDetail = 'userDetail';
  static const String quiz = 'quiz';
  static const String quizPlay = 'quizPlay';
  static const String quizQuestion = 'quizQuestion';
  static const String quizDetail = 'quizDetail';
  static const String meetingList = 'meetingList';
  static const String meeting = 'meeting';
  static const String material = 'material';
  static const String noticeboard = 'noticeboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (BuildContext context) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (BuildContext context) => const LoginScreen());
      case dashboard:
        return MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen());
      case profile:
        return MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen());
      case assignment:
        return MaterialPageRoute(builder: (BuildContext context) => const AssignmentScreen());
      case doubts:
        return MaterialPageRoute(builder: (BuildContext context) => const DoubtScreen());
      case events:
        return MaterialPageRoute(builder: (BuildContext context) => const EventScreen());
      case leaveApplication:
        return MaterialPageRoute(builder: (BuildContext context) => const LeaveApplicationScreen());
      case schoolGallery:
        return MaterialPageRoute(builder: (BuildContext context) => const SchoolGalleryScreen());
      case schoolHoliday:
        return MaterialPageRoute(builder: (BuildContext context) => const SchoolHolidayScreen());
      case studentList:
        return MaterialPageRoute(builder: (BuildContext context) => const StudentListScreen());
      case professorList:
        return MaterialPageRoute(builder: (BuildContext context) => const ProfessorListScreen());
      case timetable:
        return MaterialPageRoute(builder: (BuildContext context) => const TimeTableScreen());
      case fees:
        return MaterialPageRoute(builder: (BuildContext context) => const FeesScreen());
      case addEditFees:
        return MaterialPageRoute(
            builder: (BuildContext context) => AddEditFees(fid: settings.arguments.toString()));
      case feeDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) => FeeDetailScreen(fid: settings.arguments.toString()));
      case feePay:
        return MaterialPageRoute(
            builder: (BuildContext context) => FeePayScreen(fid: settings.arguments.toString()));
      case feeReceipt:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                FeeReceiptScreen(fid: settings.arguments.toString()));
      case resultTeacher:
        return MaterialPageRoute(builder: (BuildContext context) => const ResultScreenForTeacher());
      case resultStudent:
        return MaterialPageRoute(builder: (BuildContext context) => const ResultScreenForStudent());
      case addEditResult:
        return MaterialPageRoute(builder: (BuildContext context) {
          final arguments = settings.arguments as Map<dynamic, dynamic>?;

          final resultModel = (arguments?['resultModel'] as ResultModel?) ?? ResultModel();
          final result = (arguments?['result'] as Result?) ?? Result();

          return AddEditResult(
            resultModel: resultModel,
            result: result,
          );
        });
      case printResult:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ResultPrintScreen(result: settings.arguments as Result));
      case doubtDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                DoubtDetailScreen(did: settings.arguments.toString()));
      case assignmentDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                AssignmentDetailScreen(aid: settings.arguments.toString()));
      case eventDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                EventDetailScreen(eid: settings.arguments.toString()));
      case userDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                UserDetailsScreen(id: settings.arguments.toString()));
      case quiz:
        return MaterialPageRoute(builder: (BuildContext context) => const QuizScreen());
      case quizPlay:
        return MaterialPageRoute(builder: (BuildContext context) => const QuizPlayScreen());
      case quizQuestion:
        return MaterialPageRoute(builder: (BuildContext context) => const QuizQuestionScreen());
      case quizDetail:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                QuizDetailScreen(qid: settings.arguments.toString()));
      case meetingList:
        return MaterialPageRoute(builder: (BuildContext context) => const MeetingListScreen());
      case meeting:
        return MaterialPageRoute(
            builder: (BuildContext context) => MeetingScreen(mid: settings.arguments.toString()));
      case material:
        return MaterialPageRoute(builder: (BuildContext context) => const MaterialScreen());
      case noticeboard:
        return MaterialPageRoute(builder: (BuildContext context) => const NoticeBoardScreen());
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
