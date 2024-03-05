import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/routes.dart';
import 'package:provider/provider.dart';

import '../../consts/user_shared_preferences.dart';
import '../../model/fee_model.dart';
import '../../providers/fee_provider.dart';

class FeePayScreen extends StatefulWidget {
  final String fid;

  const FeePayScreen({super.key, required this.fid});

  @override
  State<FeePayScreen> createState() => _FeePayScreenState();
}

class _FeePayScreenState extends State<FeePayScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FeeProvider>(context, listen: false).getFee(context: context, fid: widget.fid);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<FeeProvider>(context, listen: false)
            .getFee(context: context, fid: widget.fid);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<FeeProvider>(
          builder: (context, fee, child) {
            PaidStudent? ps =
                Provider.of<FeeProvider>(context, listen: false).getStudentData(feeModel: fee.fee);

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  height: 330,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/images/background 3.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/images/background 1.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  top: 290,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                    ),
                  ),
                ),
                fee.isLoading
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF2855AE),
                          ),
                        ),
                      )
                    : CustomScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          const SliverAppBar(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Container(
                                  height: MediaQuery.of(context).size.height - 290,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(top: 200),
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${fee.fee.title!} - ₹${fee.fee.totalAmount!}',
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      fee.checkPaid(sid: UserSharedPreferences.id, fee: fee.fee)
                                          ? Text(
                                              'Fee Paid Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(ps!.paidTime.toString()))}',
                                              style: GoogleFonts.rubik(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : Text(
                                              'Last Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(fee.fee.lastDate!))}',
                                              style: GoogleFonts.rubik(
                                                color: !DateTime.now().isAfter(
                                                        DateFormat('dd/MM/yyyy')
                                                            .parse(fee.fee.lastDate!))
                                                    ? Colors.black54
                                                    : Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        child: ListView(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          children: fee.fee.feeDescription!.map((f) {
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  f.title!,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Container(
                                                  width: 150,
                                                  padding: EdgeInsets.only(
                                                      top: fee.fee.feeDescription?.indexOf(f) == 0
                                                          ? 15
                                                          : 10,
                                                      bottom: fee.fee.feeDescription?.indexOf(f) ==
                                                              fee.fee.feeDescription!.length - 1
                                                          ? 15
                                                          : 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF2855AE).withOpacity(0.2),
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(
                                                          fee.fee.feeDescription?.indexOf(f) == 0
                                                              ? 20
                                                              : 0),
                                                      topLeft: Radius.circular(
                                                          fee.fee.feeDescription?.indexOf(f) == 0
                                                              ? 10
                                                              : 0),
                                                      bottomRight: Radius.circular(
                                                          fee.fee.feeDescription?.indexOf(f) ==
                                                                  fee.fee.feeDescription!.length - 1
                                                              ? 20
                                                              : 0),
                                                      bottomLeft: Radius.circular(
                                                          fee.fee.feeDescription?.indexOf(f) ==
                                                                  fee.fee.feeDescription!.length - 1
                                                              ? 10
                                                              : 0),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '₹${f.amount!}',
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (Provider.of<FeeProvider>(context, listen: false)
                                              .checkPaid(
                                                  sid: UserSharedPreferences.id, fee: fee.fee)) {
                                            Navigator.pushNamed(
                                                context, arguments: widget.fid, Routes.feeReceipt);
                                          } else if (!DateTime.now()
                                              .isAfter(DateTime.parse(fee.fee.lastDate!))) {
                                            await Provider.of<FeeProvider>(context, listen: false)
                                                .createPayment(context: context, feeModel: fee.fee);

                                            if (!context.mounted) return;
                                            await Provider.of<FeeProvider>(context, listen: false)
                                                .getFee(context: context, fid: widget.fid);
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 250,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: const LinearGradient(
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Provider.of<FeeProvider>(context, listen: false)
                                                        .checkPaid(
                                                            sid: UserSharedPreferences.id,
                                                            fee: fee.fee)
                                                    ? 'Download PDF'
                                                    : DateTime.now().isAfter(
                                                            DateTime.parse(fee.fee.lastDate!))
                                                        ? 'Time Left'
                                                        : 'Pay Fees',
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Provider.of<FeeProvider>(context, listen: false)
                                                        .checkPaid(
                                                            sid: UserSharedPreferences.id,
                                                            fee: fee.fee)
                                                    ? Icons.picture_as_pdf_outlined
                                                    : DateTime.now().isAfter(
                                                            DateTime.parse(fee.fee.lastDate!))
                                                        ? Icons.timer_off_outlined
                                                        : Icons.arrow_forward_outlined,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
