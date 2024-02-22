import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:online_college/repositories/notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'consts/routes.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

checkPermissions() async {
  await Permission.manageExternalStorage.request();
  await Permission.accessMediaLocation.request();
  await Permission.storage.request();

  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }

  if (await Permission.accessMediaLocation.isDenied) {
    await Permission.accessMediaLocation.request();
  }

  if (await Permission.manageExternalStorage.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserSharedPreferences().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  NotificationServices().requestNotificationPermissions();
  checkPermissions();
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
