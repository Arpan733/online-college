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

  Future<void> addResult({required ResultModel resultModel}) async {
    await ResultFireStore().addResultToFireStore(resultModel: resultModel);
    await getResultList();
  }

  Future<void> updateResult({required ResultModel resultModel}) async {
    await ResultFireStore().updateResultAtFireStore(resultModel: resultModel);
    await getResultList();
  }

  Future<void> deleteResult({required String sid}) async {
    await ResultFireStore().deleteResultFromFireStore(sid: sid);
    await getResultList();
  }

  Future<void> getResultList() async {
    _results = [];
    _isLoading = true;
    notifyListeners();

    List<ResultModel> response = await ResultFireStore().getResultListFromFireStore();

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

  List<Row> buildRow({required List<String> sub, required getMarkController}) {
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
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    makeSPI(l: sub.length, getMarkController: getMarkController);
                  }
                },
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
