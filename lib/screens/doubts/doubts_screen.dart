import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/model/doubt_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/doubt_provider.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../consts/routes.dart';
import '../../consts/user_shared_preferences.dart';
import '../../widgets/bottom_sheet_for_doubt.dart';

class DoubtScreen extends StatefulWidget {
  const DoubtScreen({Key? key}) : super(key: key);

  @override
  State<DoubtScreen> createState() => _DoubtScreenState();
}

class _DoubtScreenState extends State<DoubtScreen> {
  String currentYear = '1st Year';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllUserProvider>(context, listen: false).getAllUser(context: context);
      Provider.of<DoubtProvider>(context, listen: false).getDoubtList(context: context);
    });

    super.initState();
  }

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
          Consumer<DoubtProvider>(
            builder: (context, doubt, child) {
              List<DoubtModel> ds = [];

              if (UserSharedPreferences.role == 'student') {
                for (var element in doubt.doubts) {
                  if (element.year == UserSharedPreferences.year) {
                    ds.add(element);
                  }
                }
              } else {
                for (var element in doubt.doubts) {
                  if (element.year == currentYear) {
                    ds.add(element);
                  }
                }
              }

              return CustomScrollView(
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
                      'Doubts',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (UserSharedPreferences.role == 'teacher')
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            children: [
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  value: currentYear,
                                  items: [
                                    DropdownMenuItem(
                                      value: '1st Year',
                                      child: Text(
                                        '1st Year',
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '2nd Year',
                                      child: Text(
                                        '2nd Year',
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '3rd Year',
                                      child: Text(
                                        '3rd Year',
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '4th Year',
                                      child: Text(
                                        '4th Year',
                                        style: GoogleFonts.rubik(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      currentYear = value;
                                      setState(() {});
                                    }
                                  },
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.white,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xFF2855AE),
                                      size: 30,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    sliver: SliverList.builder(
                      itemCount: ds.isEmpty ? 1 : ds.length,
                      itemBuilder: (context, index) {
                        if (doubt.isLoading) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2855AE),
                              ),
                            ),
                          );
                        }

                        if (ds.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: Text(
                                'There is no doubts in your class',
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

                        DoubtModel d = ds[index];
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6EFFF),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  d.subject,
                                  style: GoogleFonts.rubik(
                                    color: const Color(0xFF6789CA),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: TextScroll(
                                          d.title,
                                          mode: TextScrollMode.endless,
                                          velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                                          delayBefore: const Duration(milliseconds: 1000),
                                          pauseBetween: const Duration(milliseconds: 500),
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
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
                                      DateFormat('dd/MM/yyyy HH:mm aa')
                                          .format(DateTime.parse(d.createdTime))
                                          .toString(),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, arguments: d, Routes.doubtDetail),
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                        colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                      ),
                                    ),
                                    child: Text(
                                      'DETAILS',
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: UserSharedPreferences.role == 'student'
          ? GestureDetector(
              onTap: () => bottomSheetForDoubt(context: context),
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
    );
  }
}
