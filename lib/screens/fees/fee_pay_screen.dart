import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/route_name.dart';
import 'package:provider/provider.dart';

import '../../consts/user_shared_preferences.dart';
import '../../model/fee_model.dart';
import '../../repositories/fee_provider.dart';

class FeePayScreen extends StatefulWidget {
  final FeeModel feeModel;

  const FeePayScreen({super.key, required this.feeModel});

  @override
  State<FeePayScreen> createState() => _FeePayScreenState();
}

class _FeePayScreenState extends State<FeePayScreen> {
  @override
  Widget build(BuildContext context) {
    PaidStudent? ps =
        Provider.of<FeeProvider>(context, listen: false).getStudentData(feeModel: widget.feeModel);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              ),
            ),
          ),
          CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 25,
                    ),
                  ),
                ],
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
                            '${widget.feeModel.title!} - ₹${widget.feeModel.totalAmount!}',
                            style: GoogleFonts.rubik(
                              color: Colors.black87,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Provider.of<FeeProvider>(context, listen: false)
                                  .checkPaid(sid: UserSharedPreferences.id, fee: widget.feeModel)
                              ? Text(
                                  'Fee Paid Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(ps!.paidTime.toString()))}',
                                  style: GoogleFonts.rubik(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  'Last Date: ${widget.feeModel.lastDate!}',
                                  style: GoogleFonts.rubik(
                                    color: !DateTime.now().isAfter(DateFormat('dd/MM/yyyy')
                                            .parse(widget.feeModel.lastDate!))
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
                              children: widget.feeModel.feeDescription!.map((fee) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      fee.title!,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      padding: EdgeInsets.only(
                                          top: widget.feeModel.feeDescription?.indexOf(fee) == 0
                                              ? 15
                                              : 10,
                                          bottom: widget.feeModel.feeDescription?.indexOf(fee) ==
                                                  widget.feeModel.feeDescription!.length - 1
                                              ? 15
                                              : 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2855AE).withOpacity(0.2),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                              widget.feeModel.feeDescription?.indexOf(fee) == 0
                                                  ? 20
                                                  : 0),
                                          topLeft: Radius.circular(
                                              widget.feeModel.feeDescription?.indexOf(fee) == 0
                                                  ? 10
                                                  : 0),
                                          bottomRight: Radius.circular(
                                              widget.feeModel.feeDescription?.indexOf(fee) ==
                                                      widget.feeModel.feeDescription!.length - 1
                                                  ? 20
                                                  : 0),
                                          bottomLeft: Radius.circular(
                                              widget.feeModel.feeDescription?.indexOf(fee) ==
                                                      widget.feeModel.feeDescription!.length - 1
                                                  ? 10
                                                  : 0),
                                        ),
                                      ),
                                      child: Text(
                                        '₹${fee.amount!}',
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
                                  .checkPaid(sid: UserSharedPreferences.id, fee: widget.feeModel)) {
                                Navigator.pushNamed(
                                    context, arguments: widget.feeModel, RoutesName.feeReceipt);
                              } else {
                                await Provider.of<FeeProvider>(context, listen: false)
                                    .createPayment(feeModel: widget.feeModel);
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
                                    Provider.of<FeeProvider>(context, listen: false).checkPaid(
                                            sid: UserSharedPreferences.id, fee: widget.feeModel)
                                        ? 'Download PDF'
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
                                    Provider.of<FeeProvider>(context, listen: false).checkPaid(
                                            sid: UserSharedPreferences.id, fee: widget.feeModel)
                                        ? Icons.picture_as_pdf_outlined
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
      ),
    );
  }
}
