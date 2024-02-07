import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/model/fee_model.dart';
import 'package:online_college/repositories/fee_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

class AddEditFees extends StatefulWidget {
  final FeeModel? feeModel;

  const AddEditFees({super.key, this.feeModel});

  @override
  State<AddEditFees> createState() => _AddEditFeesState();
}

class _AddEditFeesState extends State<AddEditFees> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isEdit = false;

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final yearController = TextEditingController();
  final lastDateController = TextEditingController();

  final title1Controller = TextEditingController();
  final amount1Controller = TextEditingController();
  final title2Controller = TextEditingController();
  final amount2Controller = TextEditingController();
  final title3Controller = TextEditingController();
  final amount3Controller = TextEditingController();
  final title4Controller = TextEditingController();
  final amount4Controller = TextEditingController();
  final title5Controller = TextEditingController();
  final amount5Controller = TextEditingController();

  int noOfData = 1;

  DateTime dateTime = DateTime.now();

  TextEditingController getTitleController({required int i}) {
    return i == 0
        ? title1Controller
        : i == 1
            ? title2Controller
            : i == 2
                ? title3Controller
                : i == 4
                    ? title4Controller
                    : title5Controller;
  }

  TextEditingController getAmountController({required int i}) {
    return i == 0
        ? amount1Controller
        : i == 1
            ? amount2Controller
            : i == 2
                ? amount3Controller
                : i == 4
                    ? amount4Controller
                    : amount5Controller;
  }

  void totalAmountController() {
    amountController.text = '0';

    for (int i = 0; i < noOfData; i++) {
      amountController.text =
          (int.parse(amountController.text) + int.parse(getAmountController(i: i).text)).toString();
    }
  }

  @override
  void initState() {
    if (widget.feeModel != null) {
      isEdit = true;
      titleController.text = widget.feeModel?.title ?? "";
      amountController.text = widget.feeModel?.totalAmount ?? "";
      lastDateController.text = widget.feeModel?.lastDate ?? "";
      yearController.text = widget.feeModel?.year ?? '1st Year';
      noOfData = widget.feeModel?.feeDescription?.length ?? 1;

      int c = 0;

      widget.feeModel?.feeDescription?.forEach((element) {
        getTitleController(i: c).text = element.title!;
        getAmountController(i: c).text = element.amount!;
        c++;
      });

      totalAmountController();

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    } else {
      lastDateController.text = DateFormat('dd/MM/yyyy').format(dateTime);
      yearController.text = '1st Year';
      amount1Controller.text = '0';
      amount2Controller.text = '0';
      amount3Controller.text = '0';
      amount4Controller.text = '0';
      amount5Controller.text = '0';
      totalAmountController();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
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
                isEdit ? 'Edit Fee' : 'Add Fee',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    if (key.currentState != null && key.currentState!.validate()) {
                      if (isEdit) {
                        List<FeeDescription> l = [];

                        for (int i = 0; i < noOfData; i++) {
                          l.add(FeeDescription(
                              title: getTitleController(i: i).text,
                              amount: getAmountController(i: i).text));
                        }

                        FeeModel feeModel = FeeModel(
                          title: titleController.text,
                          lastDate: lastDateController.text,
                          createdDate: widget.feeModel?.createdDate,
                          totalAmount: amountController.text,
                          year: yearController.text,
                          feeDescription: l,
                          paidStudents: widget.feeModel?.paidStudents,
                          fid: widget.feeModel?.fid,
                        );

                        await Provider.of<FeeProvider>(context, listen: false)
                            .updateFee(feeModel: feeModel);

                        if (!mounted) return;
                        Navigator.pop(context);
                      } else {
                        String fid = const UuidV4().generate().toString();
                        List<FeeDescription> l = [];

                        for (int i = 0; i < noOfData; i++) {
                          l.add(FeeDescription(
                              title: getTitleController(i: i).text,
                              amount: getAmountController(i: i).text));
                        }

                        FeeModel feeModel = FeeModel(
                          title: titleController.text,
                          lastDate: lastDateController.text,
                          createdDate: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
                          totalAmount: amountController.text,
                          year: yearController.text,
                          feeDescription: l,
                          paidStudents: [],
                          fid: fid,
                        );

                        await Provider.of<FeeProvider>(context, listen: false)
                            .addFee(feeModel: feeModel);

                        if (!mounted) return;
                        Navigator.pop(context);
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
                          'Done',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Enter the title of the fee';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.black87,
                            ),
                            labelText: 'Title',
                            labelStyle: GoogleFonts.rubik(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: 'Title',
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
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: lastDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.date_range_outlined,
                              color: Colors.black87,
                            ),
                            labelText: 'Last Date',
                            labelStyle: GoogleFonts.rubik(
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
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: dateTime.add(const Duration(days: 1)),
                              firstDate: dateTime.add(const Duration(days: 1)),
                              lastDate: dateTime.add(const Duration(days: 365)),
                              helpText: 'Select the date: ',
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme(
                                        brightness: Brightness.light,
                                        primary: Color(0xFF6688CA),
                                        onPrimary: Colors.white,
                                        secondary: Color(0xFF6688CA),
                                        onSecondary: Colors.white,
                                        error: Color(0xFF6688CA),
                                        onError: Colors.white,
                                        background: Colors.white,
                                        onBackground: Color(0xFF6688CA),
                                        surface: Colors.white,
                                        onSurface: Color(0xFF6688CA),
                                      ),
                                      textTheme: GoogleFonts.rubikTextTheme().copyWith(
                                        bodyMedium: GoogleFonts.rubik(
                                          fontSize: 16,
                                          color: const Color(0xFF6688CA),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null) {
                              setState(() {
                                dateTime = dateTime.copyWith(
                                  day: pickedDate.day,
                                  month: pickedDate.month,
                                  year: pickedDate.year,
                                );

                                lastDateController.text =
                                    DateFormat('dd/MM/yyyy').format(dateTime).toString();
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<String>(
                          value: yearController.text,
                          items: [
                            DropdownMenuItem(
                              value: '1st Year',
                              child: Text(
                                '1st Year',
                                style: GoogleFonts.rubik(
                                  color: Colors.black87,
                                  fontSize: 16,
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
                                  fontSize: 16,
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
                                  fontSize: 16,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              yearController.text = value;
                              setState(() {});
                            }
                          },
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.white,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person_search_outlined,
                              color: Colors.black87,
                            ),
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF2855AE),
                              size: 30,
                            ),
                            labelText: 'Students',
                            labelStyle: GoogleFonts.rubik(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Enter the amount of the fee';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.currency_rupee_outlined,
                              color: Colors.black87,
                            ),
                            labelText: 'Total Amount',
                            labelStyle: GoogleFonts.rubik(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: 'Total Amount',
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
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: noOfData,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 40,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      controller: getTitleController(i: index),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return 'Enter the description of this field of the fee';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.description_outlined,
                                          color: Colors.black87,
                                        ),
                                        labelText: 'Description',
                                        labelStyle: GoogleFonts.rubik(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        hintText: 'Description',
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
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: getAmountController(i: index),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return 'Enter the amount of the fee';
                                        }

                                        return null;
                                      },
                                      onChanged: (value) {
                                        totalAmountController();
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.currency_rupee_outlined,
                                          color: Colors.black87,
                                        ),
                                        labelText: 'Amount',
                                        labelStyle: GoogleFonts.rubik(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        hintText: 'Amount',
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
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  index == noOfData - 1 && noOfData != 5
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (index == noOfData - 1) {
                                                  getTitleController(i: index).text = '';
                                                  getAmountController(i: index).text = '0';
                                                } else {
                                                  for (int i = index; i < noOfData; i++) {
                                                    if (i != noOfData - 1) {
                                                      getTitleController(i: i).text =
                                                          getTitleController(i: i + 1).text;
                                                      getAmountController(i: i).text =
                                                          (getAmountController(i: i + 1).text ??
                                                              '0');
                                                    } else {
                                                      getTitleController(i: i).text = '';
                                                      getAmountController(i: i).text = '0';
                                                    }
                                                  }
                                                }

                                                noOfData--;
                                                totalAmountController();

                                                setState(() {});
                                              },
                                              child: const Icon(
                                                Icons.remove_circle_outline_outlined,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                noOfData++;

                                                setState(() {});
                                              },
                                              child: const Icon(
                                                Icons.add_circle_outline_outlined,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (index == noOfData - 1 && noOfData != 5) {
                                              noOfData++;
                                            } else {
                                              if (index == noOfData - 1) {
                                                getTitleController(i: index).text = '';
                                                getAmountController(i: index).text = '0';
                                              } else {
                                                for (int i = index; i < noOfData; i++) {
                                                  if (i != noOfData - 1) {
                                                    getTitleController(i: i).text =
                                                        getTitleController(i: i + 1).text;
                                                    getAmountController(i: i).text =
                                                        (getAmountController(i: i + 1).text ?? '0');
                                                  } else {
                                                    getTitleController(i: i).text = '';
                                                    getAmountController(i: i).text = '0';
                                                  }
                                                }
                                              }

                                              noOfData--;
                                              totalAmountController();
                                            }

                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.remove_circle_outline_outlined,
                                            color: Colors.black54,
                                          ),
                                        ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
