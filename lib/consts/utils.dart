import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    return emailRegExp.hasMatch(email);
  }

  showToast({required BuildContext context, required String message}) {
    print(message);
    FToast().init(context);
    FToast().showToast(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2855AE).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: GoogleFonts.rubik(
            color: const Color(0xFF2855AE),
            fontSize: 14,
          ),
        ),
      ),
      toastDuration: const Duration(seconds: 2),
    );
    // Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: const Color(0xFF21827E),
    //   textColor: Colors.white,
    //   fontSize: 16,
    // );
  }
}
