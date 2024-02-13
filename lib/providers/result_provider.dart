import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts/subjects.dart';
import '../model/result_model.dart';
import '../repositories/result_firestore.dart';

class ResultProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<ResultModel> _results = [];

  List<ResultModel> get results => _results;

  ResultModel _result = ResultModel();

  ResultModel get result => _result;

  Future<void> addResult({required BuildContext context, required ResultModel resultModel}) async {
    await ResultFireStore().addResultToFireStore(context: context, resultModel: resultModel);
    await getResultList(context: context);
  }

  Future<void> updateResult(
      {required BuildContext context, required ResultModel resultModel}) async {
    await ResultFireStore().updateResultAtFireStore(context: context, resultModel: resultModel);
    await getResultList(context: context);
  }

  Future<void> deleteResult({required BuildContext context, required String sid}) async {
    await ResultFireStore().deleteResultFromFireStore(context: context, sid: sid);
    await getResultList(context: context);
  }

  Future<void> getResult({required BuildContext context}) async {
    _result = ResultModel();
    _isLoading = true;
    notifyListeners();

    ResultModel? response = await ResultFireStore().getResultFromFireStore(context: context);

    if (response != null) {
      _result = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getResultList({required BuildContext context}) async {
    _results = [];
    _isLoading = true;
    notifyListeners();

    List<ResultModel> response =
        await ResultFireStore().getResultListFromFireStore(context: context);

    if (response.isNotEmpty) {
      _results = response;
    }

    _isLoading = false;
    notifyListeners();
  }

  List<String> getSubject({required String year}) {
    List<String> sub = year == '1st Year'
        ? year1
        : year == '2nd Year'
            ? year2
            : year == '3rd Year'
                ? year3
                : year4;

    return sub;
  }

  String makeSPI({required int l, required getMarkController}) {
    int a = 0;

    for (int i = 0; i < l; i++) {
      a += int.parse(getMarkController(i: i).text);
    }

    return ((a / (l * 10)) + 0.05).toString().substring(0, 4);
  }

  List<Row> buildRow({required List<String> sub, required getMarkController, required onChange}) {
    List<Row> rows = [];

    for (int i = 0; i < sub.length; i++) {
      rows.add(
        Row(
          children: [
            Flexible(
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(text: sub[i]),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.currency_rupee_outlined,
                    color: Colors.black87,
                  ),
                  labelText: 'Subject',
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
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: TextFormField(
                controller: getMarkController(i: i),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: onChange,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the Marks for ${sub[i]} subject';
                  } else if (int.parse(value) > 100) {
                    return 'Enter the correct Marks for ${sub[i]} subject';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.currency_rupee_outlined,
                    color: Colors.black87,
                  ),
                  labelText: 'Marks (100)',
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
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }
}
