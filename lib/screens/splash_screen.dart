import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/providers/teacher_data_local_storage_provider.dart';
import 'package:online_college/repositories/teacher_shared_preferences.dart';

import '../consts/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    TeacherSharedPreferences().init();
    TeacherSharedPreferencesProvider().getAllData();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   RoutesName.dashboard,
        //   (route) => false,
        // );
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.dashboard,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.login,
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
      backgroundColor: const Color(0xFF21827E),
      body: Column(
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
            height: 20,
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
    );
  }
}
