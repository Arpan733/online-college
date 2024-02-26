import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/model/event_model.dart';
import 'package:text_scroll/text_scroll.dart';

showDialogForEvent({
  required BuildContext context,
  required EventModel event,
  required String time,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: GestureDetector(
        onTap: () => Navigator.popAndPushNamed(context, arguments: event.eid, Routes.eventDetail),
        child: Container(
          height: 210,
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
              Text(
                'Event 🎉🎉',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextScroll(
                '$time, We have ${event.title} event',
                mode: TextScrollMode.endless,
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                delayBefore: const Duration(milliseconds: 1000),
                pauseBetween: const Duration(milliseconds: 500),
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                DateFormat('d MMM, EEEE - hh:mm aa').format(DateTime.parse(event.dateTime)),
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    event.description,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
