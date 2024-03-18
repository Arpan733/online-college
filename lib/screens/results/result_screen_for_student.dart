import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/providers/result_provider.dart';
import 'package:provider/provider.dart';

import '../../consts/routes.dart';

class ResultScreenForStudent extends StatefulWidget {
  const ResultScreenForStudent({super.key});

  @override
  State<ResultScreenForStudent> createState() => _ResultScreenForStudentState();
}

class _ResultScreenForStudentState extends State<ResultScreenForStudent> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ResultProvider>(context, listen: false).getResult(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ResultProvider>(
        builder: (context, result, child) {
          if (result.isLoading) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2855AE),
                ),
              ),
            );
          }

          if (result.result.result!.isEmpty) {
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
                  top: 80,
                  left: MediaQuery.of(context).size.width * 0.5 - 70,
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        height: 125,
                        width: 125,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.black54, Colors.white],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC2D7F2),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  left: MediaQuery.of(context).size.width * 0.5 - 60,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD814),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFFC0C0C0),
                      size: 22,
                    ),
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
                CustomScrollView(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No result available, SORRY!!",
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
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
          }

          List<Widget> r = [];
          result.result.result?.forEach(
            (res) {
              r.add(
                Stack(
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
                      top: 80,
                      left: MediaQuery.of(context).size.width * 0.5 - 70,
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            height: 125,
                            width: 125,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.white, Colors.black54, Colors.white],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                height: 110,
                                width: 110,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC2D7F2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      result.isLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text(
                                              '${((double.parse(res.spi!) - 0.5) * 10).toStringAsFixed(0)}%',
                                              style: GoogleFonts.rubik(
                                                color: Colors.black,
                                                fontSize: 32,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                      Text(
                                        double.parse(res.spi!) > 0.9
                                            ? 'GRADE A'
                                            : double.parse(res.spi!) > 0.8
                                                ? 'GRADE B'
                                                : double.parse(res.spi!) > 0.6
                                                    ? 'GRADE C'
                                                    : double.parse(res.spi!) > 0.33
                                                        ? 'GRADE D'
                                                        : 'GRADE E',
                                        style: GoogleFonts.rubik(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 180,
                      left: MediaQuery.of(context).size.width * 0.5 - 60,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: double.parse(res.spi!) > 0.9
                              ? const Color(0xFFFFD814)
                              : double.parse(res.spi!) > 0.8
                                  ? const Color(0xFFC0C0C0)
                                  : const Color(0xFFCD7F32),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Color(0xFFC0C0C0),
                          size: 22,
                        ),
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
                    CustomScrollView(
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
                                      double.parse(res.spi!) > 0.7
                                          ? 'You are an Excellent,'
                                          : double.parse(res.spi!) > 0.33
                                              ? 'Good job,'
                                              : 'You\'re failed,',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${UserSharedPreferences.name}!!',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '${res.year!} Result',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
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
                                        children: res.data!.map((sub) {
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  sub.subject!,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 100,
                                                padding: EdgeInsets.only(
                                                    top: res.data?.indexOf(sub) == 0 ? 15 : 10,
                                                    bottom: res.data?.indexOf(sub) ==
                                                            res.data!.length - 1
                                                        ? 15
                                                        : 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE6EFFF),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        res.data?.indexOf(sub) == 0 ? 10 : 0),
                                                    bottomLeft: Radius.circular(
                                                        res.data?.indexOf(sub) ==
                                                                res.data!.length - 1
                                                            ? 10
                                                            : 0),
                                                  ),
                                                ),
                                                child: Text(
                                                  '100',
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 100,
                                                padding: EdgeInsets.only(
                                                    top: res.data?.indexOf(sub) == 0 ? 15 : 10,
                                                    bottom: res.data?.indexOf(sub) ==
                                                            res.data!.length - 1
                                                        ? 15
                                                        : 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF6AC259).withOpacity(0.1),
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        res.data?.indexOf(sub) == 0 ? 20 : 0),
                                                    bottomRight: Radius.circular(
                                                        res.data?.indexOf(sub) ==
                                                                res.data!.length - 1
                                                            ? 20
                                                            : 0),
                                                  ),
                                                ),
                                                child: Text(
                                                  sub.marks!,
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
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, arguments: res, Routes.printResult);
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
                                              'Download PDF',
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Icon(
                                              Icons.picture_as_pdf_outlined,
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
            },
          );

          return PageView(
            children: r,
          );
        },
      ),
    );
  }
}
