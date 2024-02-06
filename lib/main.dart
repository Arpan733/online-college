import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_college/providers/holiday_provider.dart';
import 'package:online_college/providers/sign_in_provider.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:online_college/repositories/teacher_shared_preferences.dart';
import 'package:provider/provider.dart';

import 'consts/route_name.dart';
import 'consts/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TeacherSharedPreferences().init();
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
        ChangeNotifierProvider(create: (context) => HolidayProvider()),
      ],
      child: const MaterialApp(
        title: 'Online College',
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
