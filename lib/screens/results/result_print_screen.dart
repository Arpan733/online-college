import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../model/result_model.dart';

class ResultPrintScreen extends StatefulWidget {
  final Result result;

  const ResultPrintScreen({super.key, required this.result});

  @override
  State<ResultPrintScreen> createState() => _ResultPrintScreenState();
}

class _ResultPrintScreenState extends State<ResultPrintScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (PdfPageFormat format) async {
          final pdf = pw.Document(
            version: PdfVersion.pdf_1_4,
            compress: true,
          );

          final sign = pw.MemoryImage(
            (await rootBundle.load('assets/images/sign.png')).buffer.asUint8List(),
          );

          List<pw.TableRow> row = [];
          int total = 0;

          row.add(
            pw.TableRow(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColor.fromHex('101010'),
                ),
              ),
              verticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.Container(
                  width: 20,
                  height: 20,
                  alignment: pw.Alignment.center,
                  color: PdfColor.fromHex('808080'),
                  child: pw.Text(
                    'Sr.',
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.Container(
                  height: 20,
                  child: pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                      alignment: pw.Alignment.center,
                      color: PdfColor.fromHex('808080'),
                      child: pw.Text(
                        'Subjects',
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  height: 20,
                  width: 50,
                  alignment: pw.Alignment.center,
                  color: PdfColor.fromHex('808080'),
                  child: pw.Text(
                    'Maximum Marks',
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                pw.Container(
                  height: 20,
                  width: 50,
                  alignment: pw.Alignment.center,
                  color: PdfColor.fromHex('808080'),
                  child: pw.Text(
                    'Obtained Marks',
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );

          for (var element in widget.result.data!) {
            total += int.parse(element.marks!);

            row.add(
              pw.TableRow(
                children: [
                  pw.Container(
                    width: 20,
                    height: 20,
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '${widget.result.data!.indexOf(element) + 1}',
                      style: const pw.TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 20,
                    child: pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          element.subject!,
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 20,
                    width: 40,
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      '100',
                      style: const pw.TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 20,
                    width: 40,
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      element.marks!,
                      style: const pw.TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          pdf.addPage(
            pw.Page(
              margin: const pw.EdgeInsets.all(20),
              pageFormat: format,
              build: (context) {
                return pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Result of ${widget.result.year}',
                        style: const pw.TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      pw.Text(
                        'Online College',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Divider(),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Expanded(
                        child: pw.Table(
                          border: pw.TableBorder(
                            bottom: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            top: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            left: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            right: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            horizontalInside: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                          ),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  height: 20,
                                  width: 200,
                                  padding: const pw.EdgeInsets.only(left: 20),
                                  child: pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      'Name: ${UserSharedPreferences.name}',
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  height: 20,
                                  padding: const pw.EdgeInsets.only(left: 20),
                                  child: pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      '${widget.result.year}',
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  height: 20,
                                  width: 200,
                                  padding: const pw.EdgeInsets.only(left: 20),
                                  child: pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      'Father Name: ${UserSharedPreferences.fatherName}',
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  height: 20,
                                  padding: const pw.EdgeInsets.only(left: 20),
                                  child: pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      'Roll No.: ${UserSharedPreferences.rollNo}',
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  height: 20,
                                  width: 200,
                                  padding: const pw.EdgeInsets.only(left: 20),
                                  child: pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      'Id: ${UserSharedPreferences.id}',
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  height: 20,
                                  padding: const pw.EdgeInsets.only(left: 20),
                                  child: pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      'DOB: ${UserSharedPreferences.dateOfBirth}',
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Divider(),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Expanded(
                        child: pw.Table(
                          border: pw.TableBorder(
                            bottom: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            top: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            left: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            right: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            horizontalInside: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                            verticalInside: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                          ),
                          children: row,
                        ),
                      ),
                      pw.Container(
                        height: 20,
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('ccffff'),
                          border: pw.Border.all(
                            color: PdfColor.fromHex('101010'),
                          ),
                        ),
                        child: pw.Text(
                          'Marks Obtained : $total Out Of ${widget.result.data!.length * 100}',
                          style: const pw.TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Divider(),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Container(
                        height: 50,
                        padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('ffff99'),
                          border: pw.Border.all(
                            color: PdfColor.fromHex('101010'),
                          ),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Percentage: ${((double.parse(widget.result.spi!) - 0.5) * 10).toStringAsFixed(0)}',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            pw.Text(
                              'Result: ${double.parse(widget.result.spi!) - 0.5 > 0.33 ? 'PASS' : 'FAIL'}',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Divider(),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Container(
                        height: 50,
                        child: pw.Row(
                          children: [
                            pw.Container(
                              width: 150,
                              child: pw.Image(
                                sign,
                                fit: pw.BoxFit.fitHeight,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Container(
                        height: 20,
                        child: pw.Expanded(
                          child: pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              'Signature by Center Head',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Divider(),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Container(
                        width: 500,
                        alignment: pw.Alignment.bottomCenter,
                        child: pw.Row(
                          children: [
                            pw.Text(
                              'Note:  ',
                              style: pw.TextStyle(
                                color: PdfColor.fromHex('ff0000'),
                              ),
                            ),
                            pw.Text(
                              'Neither webmaster nor result Hosting is responsible for any inadvertent error\nthat may crept in the result being published on NET.The results published on\nnet are immediate information for Students. This cannot be treated as original\nmark sheet Until Stamped By School Office',
                              textAlign: pw.TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );

          return pdf.save();
        },
      ),
    );
  }
}
