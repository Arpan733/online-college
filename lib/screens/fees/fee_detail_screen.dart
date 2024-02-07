import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/route_name.dart';
import 'package:online_college/repositories/fee_provider.dart';
import 'package:provider/provider.dart';

import '../../model/fee_model.dart';

class FeeDetailScreen extends StatefulWidget {
  final FeeModel fee;

  const FeeDetailScreen({super.key, required this.fee});

  @override
  State<FeeDetailScreen> createState() => _FeeDetailScreenState();
}

class _FeeDetailScreenState extends State<FeeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/background 1.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                        ),
                      ),
                      child: Image.asset('assets/images/background.png'),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width, 40),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.fee.title!,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () async {
                        await Provider.of<FeeProvider>(context).deleteFee(fid: widget.fee.fid!);

                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 30,
                        width: 40,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(
                            context, arguments: widget.fee, RoutesName.addEditFees);
                      },
                      child: Container(
                        height: 30,
                        width: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.edit_outlined,
                              color: Color(0xFF6688CA),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Edit',
                              style: GoogleFonts.rubik(
                                color: const Color(0xFF6688CA),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Batch',
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  widget.fee.year!,
                                  style: GoogleFonts.rubik(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Fees Amount',
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  widget.fee.totalAmount!,
                                  style: GoogleFonts.rubik(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Created Date',
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  widget.fee.createdDate!,
                                  style: GoogleFonts.rubik(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Last Date',
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  widget.fee.lastDate!,
                                  style: GoogleFonts.rubik(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Text(
                            'Fee Description: ',
                            style: GoogleFonts.rubik(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: widget.fee.feeDescription!.map((feeDescription) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      feeDescription.title!,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      feeDescription.amount!,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const Divider(),
                          Text(
                            'Paid Students:',
                            style: GoogleFonts.rubik(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: widget.fee.feeDescription!.map((feeDescription) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      feeDescription.title!,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      feeDescription.amount!,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
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
