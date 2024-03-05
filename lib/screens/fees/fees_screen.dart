import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/routes.dart';
import 'package:online_college/providers/fee_provider.dart';
import 'package:provider/provider.dart';

import '../../consts/user_shared_preferences.dart';
import '../../model/fee_model.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  String sort = 'All';

  List<String> dropDownList = UserSharedPreferences.role == 'teacher'
      ? [
          "All",
          "Created Date",
          "Due Date",
          "Paid By All Student",
          "Not Paid By All Student",
          "1st Year",
          "2nd Year",
          "3rd Year",
          "4th Year"
        ]
      : ["All", "Created Date", "Due Date", "Paid", "Unpaid"];

  List<DropdownMenuItem<String>> dropDowns = [];
  List<FeeModel> showFeeList = [];

  @override
  void initState() {
    for (var element in dropDownList) {
      dropDowns.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            element,
            style: GoogleFonts.rubik(
              color: const Color(0xFF2855AE),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FeeProvider>(context, listen: false).getFeeList(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<FeeProvider>(context, listen: false).getFeeList(context: context);
        setState(() {});
      },
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
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
            Consumer<FeeProvider>(
              builder: (context, fee, _) {
                showFeeList = UserSharedPreferences.role == 'teacher'
                    ? fee.sortingForTeacher(context: context, sort: sort)
                    : fee.sortingForStudent(context: context, sort: sort);

                return StatefulBuilder(
                  builder: (context, set) => CustomScrollView(
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
                          'Fees',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              DropdownButtonFormField<String>(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                value: sort,
                                items: dropDowns,
                                onChanged: (value) {
                                  if (value != null) {
                                    sort = value;
                                    showFeeList = UserSharedPreferences.role == 'teacher'
                                        ? fee.sortingForTeacher(context: context, sort: sort)
                                        : fee.sortingForStudent(context: context, sort: sort);

                                    set(() {});
                                  }
                                },
                                dropdownColor: Colors.white,
                                iconEnabledColor: Colors.white,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.filter_alt_outlined,
                                    color: Color(0xFF2855AE),
                                    size: 20,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF2855AE),
                                    size: 30,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList.builder(
                          itemCount: showFeeList.isEmpty ? 1 : showFeeList.length,
                          itemBuilder: (context, index) {
                            if (fee.isLoading) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2855AE),
                                  ),
                                ),
                              );
                            }

                            if (showFeeList.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: Center(
                                  child: Text(
                                    UserSharedPreferences.role == 'teacher'
                                        ? (sort == 'Paid By All Student'
                                            ? 'There is no fee which is fully paid'
                                            : sort == 'Not Paid By All Student'
                                                ? 'There is no fee remaining which are not paid by students'
                                                : ["1st Year", "2nd Year", "3rd Year", "4th Year"]
                                                        .contains(sort)
                                                    ? 'There is not any fee for $sort students.'
                                                    : 'There is no fee')
                                        : (sort == 'Paid'
                                            ? 'You have not paid any fee.'
                                            : sort == 'Unpaid'
                                                ? 'You paid all fees'
                                                : 'There is no fee'),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }

                            FeeModel f = showFeeList[index];

                            if (UserSharedPreferences.role == 'student') {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black38,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Title',
                                            style: GoogleFonts.rubik(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            f.title!,
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
                                            '₹${f.totalAmount!}',
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
                                            DateFormat('dd/MM/yyyy')
                                                .format(DateTime.parse(f.lastDate!)),
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
                                    ListView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      children: f.feeDescription!.map((fee) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                fee.title!,
                                                style: GoogleFonts.rubik(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                '₹${fee.amount!}',
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, arguments: f.fid, Routes.feePay),
                                      child: Container(
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF6789CA),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              fee.checkPaid(sid: UserSharedPreferences.id, fee: f)
                                                  ? 'Download Fee Receipt'
                                                  : 'About Fee',
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_outlined,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, arguments: f.fid, Routes.feeDetail),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.black38,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Title',
                                              style: GoogleFonts.rubik(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              f.title!,
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
                                              'Batch',
                                              style: GoogleFonts.rubik(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              f.year!,
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
                                              f.totalAmount!,
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
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.parse(f.lastDate!)),
                                              style: GoogleFonts.rubik(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: UserSharedPreferences.role == 'teacher'
            ? GestureDetector(
                onTap: () => Navigator.pushNamed(context, Routes.addEditFees),
                child: Container(
                  height: 60,
                  width: 60,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
