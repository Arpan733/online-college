import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/model/notice_model.dart';
import 'package:text_scroll/text_scroll.dart';

showDialogForNotice({
  required BuildContext context,
  required NoticeModel notice,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => Navigator.popAndPushNamed(context, Routes.noticeboard),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextScroll(
                  'Notice: ${notice.title}',
                  mode: TextScrollMode.endless,
                  velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                  delayBefore: const Duration(milliseconds: 1000),
                  pauseBetween: const Duration(milliseconds: 500),
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.white,
                  height: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  notice.description,
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (notice.photoUrl != '')
                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: Colors.white,
                        height: 2,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Image.network(
                        notice.photoUrl,
                        alignment: Alignment.center,
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
