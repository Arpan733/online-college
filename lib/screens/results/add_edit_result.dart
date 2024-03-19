import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/result_provider.dart';
import 'package:online_college/widgets/dialog_for_delete.dart';
import 'package:provider/provider.dart';

import 'package:online_college/model/result_model.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/repositories/user_data_firestore.dart';

class AddEditResult extends StatefulWidget {
  final ResultModel? resultModel;
  final Result? result;

  const AddEditResult({super.key, required this.resultModel, required this.result});

  @override
  State<AddEditResult> createState() => _AddEditResultState();
}

class _AddEditResultState extends State<AddEditResult> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isEdit = false;

  List<Row> rows = [];
  List<ResultModel> results = [];
  List<StudentUserModel> sm = [];
  List<DropdownMenuItem<String>> sd = [];
  List<String> sub = [];

  final yearController = TextEditingController();
  final rollNoController = TextEditingController();
  final spiController = TextEditingController();
  final mark1Controller = TextEditingController();
  final mark2Controller = TextEditingController();
  final mark3Controller = TextEditingController();
  final mark4Controller = TextEditingController();
  final mark5Controller = TextEditingController();
  final mark6Controller = TextEditingController();

  @override
  void initState() {
    results = Provider
        .of<ResultProvider>(context, listen: false)
        .results;
    mark1Controller.text = '0';
    mark2Controller.text = '0';
    mark3Controller.text = '0';
    mark4Controller.text = '0';
    mark5Controller.text = '0';
    mark6Controller.text = '0';
    spiController.text = '0.00';
    yearController.text = '1st Year';

    if (widget.resultModel != null && widget.result != null && widget.result?.data != null) {
      isEdit = true;
      forIsEdit();
    } else {
      sub =
          Provider.of<ResultProvider>(context, listen: false).getSubject(year: yearController.text);
      rows = Provider.of<ResultProvider>(context, listen: false).buildRow(
          sub: sub,
          getMarkController: getMarkController,
          onChange: (value) {
            if (value.isNotEmpty) {
              spiController.text = Provider.of<ResultProvider>(context, listen: false)
                  .makeSPI(l: sub.length, getMarkController: getMarkController);
              setState(() {});
            }
          });
      getStudent();
    }

    super.initState();
  }

  forIsEdit() async {
    yearController.text = widget.result!.year!;
    spiController.text == widget.result?.spi;

    for (int i = 0; i < widget.result!.data!.length; i++) {
      getMarkController(i: i).text = widget.result!.data![i].marks!;
    }

    sub = Provider.of<ResultProvider>(context, listen: false).getSubject(year: yearController.text);
    spiController.text = Provider.of<ResultProvider>(context, listen: false)
        .makeSPI(l: sub.length, getMarkController: getMarkController);
    setState(() {});
    rows = Provider.of<ResultProvider>(context, listen: false).buildRow(
        sub: sub,
        getMarkController: getMarkController,
        onChange: (value) {
          if (value.isNotEmpty) {
            spiController.text = Provider.of<ResultProvider>(context, listen: false)
                .makeSPI(l: sub.length, getMarkController: getMarkController);
            setState(() {});
          }
        });

    StudentUserModel? stu =
    await UserDataFireStore().getStudentData(context: context, id: widget.resultModel!.sid!);
    sm.add(stu!);

    sd.add(
      DropdownMenuItem(
        value: '${stu.rollNo} - ${stu.year} - ${stu.name}',
        child: Text(
          '${stu.rollNo} - ${stu.year} - ${stu.name}',
          style: GoogleFonts.rubik(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
    rollNoController.text = '${stu.rollNo} - ${stu.year} - ${stu.name}';

    sd.removeWhere((element) => element.value == 'No Student');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  TextEditingController getMarkController({required int i}) {
    return i == 0
        ? mark1Controller
        : i == 1
        ? mark2Controller
        : i == 2
        ? mark3Controller
        : i == 4
        ? mark4Controller
        : i == 5
        ? mark5Controller
        : mark6Controller;
  }

  getStudent() {
    sd = [];
    sm = [];

    Provider
        .of<AllUserProvider>(context, listen: false)
        .studentsList
        .forEach(
          (element) {
        if (element.year == yearController.text ||
            (element.year == '4th Year' &&
                ['1st Year', '2nd Year', '3rd Year'].contains(yearController.text)) ||
            (element.year == '3rd Year' &&
                ['1st Year', '2nd Year'].contains(yearController.text)) ||
            (element.year == '2nd Year' && '1st Year' == yearController.text)) {
          sm.add(element);
          sd.add(
            DropdownMenuItem(
              value: '${element.rollNo} - ${element.year} - ${element.name}',
              child: Text(
                '${element.rollNo} - ${element.year} - ${element.name}',
                style: GoogleFonts.rubik(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
      },
    );

    sm.sort(
          (a, b) {
        int aRoll = int.parse(a.rollNo);
        int bRoll = int.parse(b.rollNo);
        return aRoll.compareTo(bRoll);
      },
    );

    sd.sort((a, b) {
      final aLabelInteger = extractIntegerFromLabel(a.value!);
      final bLabelInteger = extractIntegerFromLabel(b.value!);
      return aLabelInteger.compareTo(bLabelInteger);
    });

    List<String> ism = [];
    List<String> isd = [];

    for (var r in results) {
      for (var s in sm) {
        if (s.id == r.sid) {
          for (var element in r.result!) {
            if (element.year == yearController.text) {
              ism.add(s.id);
              isd.add(sd[sm.indexOf(s)].value!);
            }
          }
        }
      }
    }

    for (int i = 0; i < ism.length; i++) {
      if (sm.length == 1 && sd.length == 1) {
        sm = [];
        sd = [];
      } else {
        sm.removeWhere((element) => element.id == ism[i]);
        sd.removeWhere((element) => element.value == isd[i]);
      }
    }

    if (sm.isEmpty && sd.isEmpty) {
      sd.add(
        DropdownMenuItem(
          value: 'No Student',
          child: Text(
            'No Student',
            style: GoogleFonts.rubik(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    rollNoController.text = sd[0].value!;
    setState(() {});
  }

  int extractIntegerFromLabel(String label) {
    final parts = label.split(' - ');
    if (parts.isNotEmpty) {
      final integerValue = int.tryParse(parts[0].trim());
      if (integerValue != null) {
        return integerValue;
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Image.asset(
              'assets/images/background 1.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Form(
            key: key,
            child: CustomScrollView(
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
                    preferredSize: Size(MediaQuery
                        .of(context)
                        .size
                        .width, 40),
                    child: Container(
                      height: 40,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    'Add Result',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: [
                    isEdit
                        ? GestureDetector(
                      onTap: () =>
                          showDialogForDelete(
                            context: context,
                            text: 'Are you sure you want to delete this result?',
                            onDelete: () async {
                              ResultModel resultModel = widget.resultModel!;
                              List<Result> re = widget.resultModel!.result!;
                              Result ree = widget.result!;

                              if (re.length == 1) {
                                await Provider.of<ResultProvider>(context, listen: false)
                                    .deleteResult(
                                  context: context,
                                  sid: resultModel.sid!,
                                );
                              } else if (re.length == 2) {
                                re.remove(ree);

                                resultModel.cpi = re[0].spi;
                                resultModel.result = re;

                                await Provider.of<ResultProvider>(context, listen: false)
                                    .updateResult(context: context, resultModel: resultModel);
                              } else {
                                String cpi =
                                (double.parse(resultModel.cpi!) * re.length).toString();

                                re.remove(ree);
                                cpi = (double.parse(cpi) - double.parse(ree.spi!)).toString();
                                cpi = (double.parse(cpi) / re.length).toString().substring(0, 4);

                                resultModel.result = re;
                                resultModel.cpi = cpi;

                                if (cpi.length > 4) {
                                  cpi = cpi.substring(0, 4);
                                }

                                await Provider.of<ResultProvider>(context, listen: false)
                                    .updateResult(context: context, resultModel: resultModel);
                              }

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
                    )
                        : Container(),
                    GestureDetector(
                      onTap: () {
                        if (sm.isNotEmpty) {
                          if (key.currentState != null && key.currentState!.validate()) {
                            if (isEdit) {
                              List<Datum> datum = [];
                              List<Result> re = widget.resultModel!.result!;
                              String? cpi = '0.0';

                              re.remove(widget.result!);

                              for (int i = 0; i < sub.length; i++) {
                                datum.add(
                                    Datum(subject: sub[i], marks: getMarkController(i: i).text));
                              }

                              re.add(
                                Result(
                                  year: yearController.text,
                                  spi: spiController.text,
                                  data: datum,
                                ),
                              );

                              for (var element in re) {
                                cpi = (double.parse(cpi!) + double.parse(element.spi!)).toString();
                              }

                              cpi = (double.parse(cpi!) / re.length.toDouble()).toString();

                              if (cpi.length > 4) {
                                cpi = cpi.substring(0, 4);
                              }

                              ResultModel resultModel = ResultModel(
                                cpi: cpi,
                                sid: widget.resultModel!.sid,
                                result: re,
                              );

                              Provider.of<ResultProvider>(context, listen: false)
                                  .updateResult(context: context, resultModel: resultModel);
                              Navigator.pop(context);

                              re.clear();
                            } else {
                              List<Datum> datum = [];
                              int c = 0;

                              for (var element in sd) {
                                if (element.value == rollNoController.text) {
                                  c = sd.indexOf(element);
                                }
                              }

                              for (int i = 0; i < sub.length; i++) {
                                datum.add(
                                    Datum(subject: sub[i], marks: getMarkController(i: i).text));
                              }

                              ResultModel? remo;

                              for (var element in results) {
                                if (element.sid == sm[c].id) {
                                  remo = element;
                                }
                              }

                              String cpi = '0.0';
                              List<Result> re = remo?.result ?? [];

                              re.add(
                                Result(
                                  year: yearController.text,
                                  spi: spiController.text,
                                  data: datum,
                                ),
                              );

                              for (var element in re) {
                                cpi = (double.parse(cpi) + double.parse(element.spi!)).toString();
                              }

                              cpi = (double.parse(cpi) / re.length).toString();

                              if (cpi.length > 4) {
                                cpi = cpi.substring(0, 4);
                              }

                              ResultModel resultModel = ResultModel(
                                cpi: cpi,
                                sid: sm[c].id,
                                result: re,
                              );

                              Provider.of<ResultProvider>(context, listen: false).addResult(
                                  context: context,
                                  resultModel: resultModel,
                                  year: yearController.text,
                                  spi: spiController.text);
                              Navigator.pop(context);

                              re.clear();
                            }
                          }
                        }
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
                              Icons.check_outlined,
                              color: Color(0xFF6688CA),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              isEdit ? 'Edit' : 'Add',
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
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      isEdit
                          ? DropdownButtonFormField<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        value: yearController.text,
                        items: [
                          DropdownMenuItem(
                            value: yearController.text,
                            child: Text(
                              yearController.text,
                              style: GoogleFonts.rubik(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {},
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
                      )
                          : DropdownButtonFormField<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        value: yearController.text,
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
                          if (isEdit) {} else if (value != null) {
                            mark1Controller.text = '0';
                            mark2Controller.text = '0';
                            mark3Controller.text = '0';
                            mark4Controller.text = '0';
                            mark5Controller.text = '0';
                            mark6Controller.text = '0';
                            spiController.text = '0.00';

                            yearController.text = value;
                            getStudent();
                            sub = Provider.of<ResultProvider>(context, listen: false)
                                .getSubject(year: yearController.text);
                            rows =
                                Provider.of<ResultProvider>(context, listen: false).buildRow(
                                    sub: sub,
                                    getMarkController: getMarkController,
                                    onChange: (value) {
                                      if (value.isNotEmpty) {
                                        spiController.text = Provider.of<ResultProvider>(
                                            context,
                                            listen: false)
                                            .makeSPI(
                                            l: sub.length,
                                            getMarkController: getMarkController);
                                        setState(() {});
                                      }
                                    });
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
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        value: rollNoController.text,
                        items: sd,
                        onChanged: (value) {
                          if (value != null) {
                            rollNoController.text = value;
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
                      TextFormField(
                        controller: spiController,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Enter the SPI of this result';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.grade_outlined,
                            color: Colors.black87,
                          ),
                          labelText: 'SPI',
                          labelStyle: GoogleFonts.rubik(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'SPI',
                          hintStyle: GoogleFonts.rubik(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: GoogleFonts.rubik(
                          color: const Color(0xFF323643),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: double.parse((75 * sub.length).toString()),
                        child: Column(
                          children: rows,
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
    );
  }
}
