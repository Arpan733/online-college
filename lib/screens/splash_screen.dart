import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/sign_in_provider.dart';
import 'package:online_college/providers/student_data_firestore_provider.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllUserProvider>(context, listen: false).getAllUser(context: context);
    });

    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (FirebaseAuth.instance.currentUser != null) {
          bool isSingleDevice = await Provider.of<SignInProvider>(context, listen: false)
              .checkUserDevices(context: context);

          if (isSingleDevice) {
            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.dashboard,
              (route) => false,
            );
          } else {
            if (UserSharedPreferences.role == 'student') {
              if (!mounted) return;
              await Provider.of<StudentDataFireStoreProvider>(context, listen: false)
                  .updateStudentNotificationToken(
                      context: context, notificationToken: '', id: UserSharedPreferences.id);
            } else {
              if (!mounted) return;
              await Provider.of<TeacherDataFireStoreProvider>(context, listen: false)
                  .updateTeacherNotificationToken(
                      context: context, notificationToken: '', id: UserSharedPreferences.id);
            }

            await FirebaseAuth.instance.signOut();
            SharedPreferences preference = await SharedPreferences.getInstance();
            await preference.clear();

            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (route) => false,
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Online\nCollege',
                textAlign: TextAlign.center,
                style: GoogleFonts.macondo(
                  color: Colors.white,
                  fontSize: 74,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(right: 30),
              child: Hero(
                tag: 'student 1',
                child: Image.asset(
                  'assets/images/student 1.png',
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
