import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/assignment_provider.dart';
import 'package:online_college/providers/doubt_provider.dart';
import 'package:online_college/providers/event_provider.dart';
import 'package:online_college/providers/fee_provider.dart';
import 'package:online_college/providers/holiday_provider.dart';
import 'package:online_college/providers/leave_application_provider.dart';
import 'package:online_college/providers/result_provider.dart';
import 'package:online_college/providers/school_gallery_provider.dart';
import 'package:online_college/providers/sign_in_provider.dart';
import 'package:online_college/providers/student_data_firestore_provider.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:online_college/providers/time_table_provider.dart';
import 'package:provider/provider.dart';

import 'consts/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserSharedPreferences().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignInProvider()),
        ChangeNotifierProvider(create: (context) => TeacherDataFireStoreProvider()),
        ChangeNotifierProvider(create: (context) => StudentDataFireStoreProvider()),
        ChangeNotifierProvider(create: (context) => HolidayProvider()),
        ChangeNotifierProvider(create: (context) => AllUserProvider()),
        ChangeNotifierProvider(create: (context) => FeeProvider()),
        ChangeNotifierProvider(create: (context) => ResultProvider()),
        ChangeNotifierProvider(create: (context) => DoubtProvider()),
        ChangeNotifierProvider(create: (context) => AssignmentProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => LeaveApplicationProvider()),
        ChangeNotifierProvider(create: (context) => SchoolGalleryProvider()),
        ChangeNotifierProvider(create: (context) => TimeTableProvider()),
      ],
      child: const MaterialApp(
        title: 'Online College',
        initialRoute: Routes.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}

// {
// "type": "service_account",
// "project_id": "online-college-da0ab",
// "private_key_id": "b3db91e0d95a1b579d22c31a3093459fa9088e19",
// "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQClpqxbcxP4oHI9\nnrl+ulqpr6K1/t46LUJfSP3w/X1DmznmNtrtSE5zMVu3y6C+GQ1F/MdQCpTzj6lJ\n/km3WU6fWNg/4PYpYuk6V/8GcnX6wMGGavGOboQ8Y1yrzIA7bt6OjYib4BTa8rWx\n5kdHgP7qTwVm+zD/gitXYqo8qGuy86bLGrzQjT5Z111gleIouJw4DMOtY+tC7A4O\ntaDqTrsdxgaKuGpba9AB9lZfkcW0A3U1He5yPWujkLkkm2P/DZSpTOxZ7NkMKJHT\nZ5Gvmby6kDnqYafTGhcy9tS7N9SkU4we35L+VfmezrVSLrWyz5rpv1HmGuPnKNRM\n+LnXMENzAgMBAAECggEAQUOIH6WYxjmMmOt6wMuyIa2hqRunuXsQbdMnvbVZj3PO\nXX3aRmdZBTh6ntC63XqoSJ09d7MbmVROCemGaJbmi5Bo7s32njqqkgKOZx9cjTU5\nafijgA7ZyaMKJWO2V/Qn+jkYC/W+sb6zSEpmZe0UQgNtKPQpi1lhMxYb5Tcj64ZB\n0/ZgoIOAwBnZgqkO+pAfxroH9zLJKA2DFj0z5NIzFCtmGtYpIyQpdePZ5nWBP6mz\nrZ9W/nYENs0HiU39VBgOMxNTyAcNT/ElbQ1J3ScnzZ4dJLmL4wk5fbkPcp1nbozq\njQXu42nCyhpuZouLyvtIo7CuVOthM/pjtanFu0b8CQKBgQDc23lCh9aJ+Ka7qnaH\nTomVPIonV6tIodiq1QnkfxGSTBSi+2QU3ZizJ4bD3nctQe3Yw/W4yIVVSh2gPN7S\nmEc3Ns6C6dzKkgUa8NcQiKaCleoriQfWdepjjQIeMDTc1Hf7DeJnVtU8gs6yBqCO\n1N8Sg3XKwfpFKhVuvhBTmgZD6QKBgQDAAmWm7joOPBLbZkE0+Or+r3eUKvtaIVlk\nqlUitmugDvIQaKKTRrx08u6FXAOpNGGiBU5LoDNysN0+oIE/YdBSQyQyAvgTIIpp\n+qy2Xo5TnviMTB3ppiWUI+K/AN4xvQvVvEnlQxxwycGYb4+JWTJ5QBP/rUn1MgCy\nJyldqEd++wKBgQCvcnJL1dkqVasuXeY26r8FHMirJEvfMSML4p0vNXph+6pRJt+E\na90IRRgbtTh7bWpizpj/J9wzuuL6DiD8rxez1wgKm3lYOtNvaW+PpN6R0kHqP7tI\nNPf0CWprTORRoT+G4qq+aQ6QOWG1ruoRTS3AaUpDvgDwvNO126rgnvTnMQKBgQCo\njbIknz4xnsTC+vnFAbpwxyIG3NB3p4zs1KYV6eOCx3vxsZj+BnuLgnKmeUbxc309\nmMDJnKFtTht6TbYIKNqSTERq7rZNPCSlshuJoGn6uDPiHTOpF2QnrnTvTVjAev73\nqumHq6k8za/4G/76CGZJkFm9+aZR64o22i/y+rWAnwKBgAz+n1ZeFNomDuX1l2rz\n/Q2bonD+Go32qAFAXPZg1qeRH6MdJYeqaLCXmGR6zi6VICKbKmkzOaHZ6ngESFBa\npsfXIqWSsk1xNUHMrFE73GT3osyd9lL4fcGysH0xnsU+6d+lWLPUURi7nqp8KrE8\naAb6NAHhIPx0hDqMDA2l/zMW\n-----END PRIVATE KEY-----\n",
// "client_email": "online-college-da0ab@appspot.gserviceaccount.com",
// "client_id": "105465966987017371388",
// "auth_uri": "https://accounts.google.com/o/oauth2/auth",
// "token_uri": "https://oauth2.googleapis.com/token",
// "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
// "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/online-college-da0ab%40appspot.gserviceaccount.com",
// "universe_domain": "googleapis.com"
// }
