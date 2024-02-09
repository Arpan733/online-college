import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/providers/fee_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../model/fee_model.dart';

class FeeReceiptScreen extends StatefulWidget {
  final FeeModel feeModel;

  const FeeReceiptScreen({super.key, required this.feeModel});

  @override
  State<FeeReceiptScreen> createState() => _FeeReceiptScreenState();
}

class _FeeReceiptScreenState extends State<FeeReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    PaidStudent? ps =
        Provider.of<FeeProvider>(context, listen: false).getStudentData(feeModel: widget.feeModel);

    List<pw.TableRow> row = [];

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
            child: pw.Text(
              'Sr.',
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
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Particulars',
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
              'Amount',
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );

    for (var element in widget.feeModel.feeDescription!) {
      row.add(
        pw.TableRow(
          children: [
            pw.Container(
              height: 5,
            ),
          ],
        ),
      );

      row.add(
        pw.TableRow(
          children: [
            pw.Container(
              width: 20,
              height: 20,
              alignment: pw.Alignment.center,
              child: pw.Text(
                '${widget.feeModel.feeDescription!.indexOf(element) + 1}',
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
                    element.title!,
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
                element.amount!,
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    row.add(
      pw.TableRow(
        children: [
          pw.Container(
            height: 50,
          ),
        ],
      ),
    );

    row.add(
      pw.TableRow(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex('101010'),
          ),
        ),
        children: [
          pw.Container(
            height: 20,
            width: 40,
          ),
          pw.Container(
            height: 20,
            width: 40,
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Total',
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
              widget.feeModel.totalAmount!,
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );

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

          pdf.addPage(
            pw.Page(
              pageFormat: format,
              build: (context) {
                return pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Fee Receipt',
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
                        height: 20,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            height: 20,
                            child: pw.Expanded(
                              child: pw.Container(
                                alignment: pw.Alignment.centerLeft,
                                child: pw.Text(
                                  'Receipt No.: ${ps?.refNo}',
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            height: 20,
                            child: pw.Expanded(
                              child: pw.Container(
                                alignment: pw.Alignment.centerLeft,
                                child: pw.Text(
                                  'Payment Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(ps!.paidTime.toString()))}',
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.Divider(),
                      pw.Container(
                        height: 20,
                        child: pw.Expanded(
                          child: pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              'Student Name: ${UserSharedPreferences.name}',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        height: 20,
                        child: pw.Expanded(
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
                      ),
                      pw.Container(
                        height: 20,
                        child: pw.Expanded(
                          child: pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              'Student Year: ${widget.feeModel.year}',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        height: 20,
                        child: pw.Expanded(
                          child: pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              'Phone No.: ${UserSharedPreferences.phoneNumber}',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(
                        height: 30,
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
                            verticalInside: pw.BorderSide(
                              color: PdfColor.fromHex('101010'),
                            ),
                          ),
                          children: row,
                        ),
                      ),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Container(
                        height: 20,
                        child: pw.Expanded(
                          child: pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              'Paid By: RazorPay',
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(
                        height: 40,
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
                      pw.Container(
                        height: 70,
                        alignment: pw.Alignment.bottomCenter,
                        child: pw.Text(
                          'All above mentioned Amount once paid are non refundable in any case whatsoever.',
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
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
