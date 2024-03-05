import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/model/fee_model.dart';
import 'package:text_scroll/text_scroll.dart';

showDialogForFee({
  required BuildContext context,
  required FeeModel feeModel,
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
        onTap: () {
          Navigator.popAndPushNamed(context, arguments: feeModel.fid, Routes.feePay);
        },
        child: Container(
          height: 115,
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
                'Fee Due',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextScroll(
                '$time is due date for ${feeModel.title} rupees of ${feeModel.totalAmount}',
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
                feeModel.lastDate!,
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
