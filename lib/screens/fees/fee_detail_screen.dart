import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/providers/fee_provider.dart';
import 'package:online_college/repositories/user_data_firestore.dart';
import 'package:online_college/widgets/dialog_for_delete.dart';
import 'package:provider/provider.dart';

class FeeDetailScreen extends StatefulWidget {
  final String fid;

  const FeeDetailScreen({super.key, required this.fid});

  @override
  State<FeeDetailScreen> createState() => _FeeDetailScreenState();
}

class _FeeDetailScreenState extends State<FeeDetailScreen> {
  late FeeProvider provider;
  bool isLoading = false;
  List<StudentUserModel> paidStudentsData = [];

  @override
  void initState() {
    provider = Provider.of<FeeProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await provider.getFee(context: context, fid: widget.fid);
      getStudents();
    });

    super.initState();
  }

  getStudents() async {
    paidStudentsData = [];
    setState(() {
      isLoading = true;
    });

    if (provider.fee.paidStudents != null) {
      for (var element in provider.fee.paidStudents!) {
        StudentUserModel? s =
            await UserDataFireStore().getStudentData(context: context, id: element.sid!);

        if (s != null) {
          setState(() {
            paidStudentsData.add(s);
          });
        }
      }
    }

    paidStudentsData.sort();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await provider.getFee(context: context, fid: widget.fid);
        getStudents();

        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<FeeProvider>(
          builder: (context, fee, child) => Stack(
            children: [
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/background 1.png',
                  fit: BoxFit.fitWidth,
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
                              fee.fee.title!,
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            actions: [
                              if (fee.isLoading &&
                                  DateTime.now().isAfter(DateTime.parse(fee.fee.lastDate!)))
                                GestureDetector(
                                  onTap: () => showDialogForDelete(
                                    context: context,
                                    text: 'Are you sure you want to delete ${fee.fee.title} fee?',
                                    onDelete: () async {
                                      await fee.deleteFee(context: context, fid: widget.fid);

                                      if (!context.mounted) return;
                                      Navigator.pop(context);

                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                    },
                                    onOk: () => Navigator.pop(context),
                                  ),
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
                                onTap: () async {
                                  Navigator.pushNamed(
                                      context, arguments: widget.fid, Routes.addEditFees);

                                  await provider.getFee(context: context, fid: widget.fid);
                                  getStudents();
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
                                            fee.fee.year!,
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
                                            fee.fee.totalAmount!,
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
                                            fee.fee.createdDate!,
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
                                            fee.fee.lastDate!,
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
                                      children: fee.fee.feeDescription!.map((feeDescription) {
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 575,
                                      child: isLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xFF2855AE),
                                              ),
                                            )
                                          : paidStudentsData.isEmpty
                                              ? Center(
                                                  child: Text(
                                                    'No one has paid fees.',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: paidStudentsData.length,
                                                  itemBuilder: (context, index) {
                                                    StudentUserModel su = paidStudentsData[index];

                                                    return Container(
                                                      height: 80,
                                                      padding: const EdgeInsets.all(10),
                                                      margin: const EdgeInsets.only(bottom: 20),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(
                                                          color: Colors.black38,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            height: 60,
                                                            width: 60,
                                                            decoration: const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              gradient: LinearGradient(
                                                                begin: Alignment.centerRight,
                                                                end: Alignment.centerLeft,
                                                                colors: [
                                                                  Color(0xFF2855AE),
                                                                  Color(0xFF7292CF)
                                                                ],
                                                              ),
                                                            ),
                                                            clipBehavior: Clip.antiAlias,
                                                            child: Image.network(
                                                              su.photoUrl,
                                                              fit: BoxFit.fitHeight,
                                                              errorBuilder: (BuildContext context,
                                                                  Object error,
                                                                  StackTrace? stackTrace) {
                                                                return Image.asset(
                                                                  'assets/images/student.png',
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  su.name,
                                                                  style: GoogleFonts.rubik(
                                                                    color: Colors.black87,
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '+91 ${su.phoneNumber}',
                                                                  style: GoogleFonts.rubik(
                                                                    color: Colors.black54,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            su.rollNo,
                                                            style: GoogleFonts.rubik(
                                                              color: Colors.black87,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
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
        ),
      ),
    );
  }
}
