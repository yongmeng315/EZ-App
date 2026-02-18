import 'dart:convert';

import 'package:ezapp/models/country.dart';
import 'package:ezapp/utils/general_utils.dart';
import 'package:ezapp/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../widgets/custom_tff.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceGeneration extends StatefulWidget {
  const InvoiceGeneration({super.key});

  @override
  State<InvoiceGeneration> createState() => _InvoiceGenerationState();
}

class _InvoiceGenerationState extends State<InvoiceGeneration> {
  final GlobalKey<FormState> globalKey = GlobalKey();
  late double height, width;
  final TextEditingController _issuerNameTEC = TextEditingController();
  final TextEditingController _issuerContactNumberTEC = TextEditingController();
  final TextEditingController _issuerEmailTEC = TextEditingController();
  final TextEditingController _issuerAddress1TEC = TextEditingController();
  final TextEditingController _issuerAddress2TEC = TextEditingController();
  final TextEditingController _issuerPostcodeTEC = TextEditingController();
  final TextEditingController _issuerStateTEC = TextEditingController();
  final TextEditingController _issuerCityTEC = TextEditingController();
  final TextEditingController _issuerCountryTEC = TextEditingController();
  final TextEditingController _recipientNameTEC = TextEditingController();
  final TextEditingController _recipientContactNumberTEC =
      TextEditingController();
  final TextEditingController _recipientEmailTEC = TextEditingController();
  final TextEditingController _recipientAddress1TEC = TextEditingController();
  final TextEditingController _recipientAddress2TEC = TextEditingController();
  final TextEditingController _recipientPostcodeTEC = TextEditingController();
  final TextEditingController _recipientStateTEC = TextEditingController();
  final TextEditingController _recipientCityTEC = TextEditingController();
  final TextEditingController _recipientCountryTEC = TextEditingController();

  final TextEditingController _salesTaxTEC = TextEditingController();
  final TextEditingController _shippingNHandlingTEC = TextEditingController();
  final TextEditingController _discountTEC = TextEditingController();

  final FocusNode _issuerCountryFocusNode = FocusNode();
  final FocusNode _recipientCountryFocusNode = FocusNode();

  bool isLoading = false;

  List<Map<String, dynamic>> itemList = [
    {
      'item': TextEditingController(),
      'unit_price': TextEditingController(text: '0.00'),
      'quantity': TextEditingController(text: '0'),
      'total_price': TextEditingController(text: '0.00'),
    },
  ];

  Future<void> _generateAndDownloadPdf() async {
    try {
      DateTime now = DateTime.now();
      String invoiceNumber = 'INV${DateFormat('yyyyMMdd').format(now)}';
      double subtotalDueByDate = 0;
      double salesTaxRate = GeneralUtils.roundToTwo(
        double.parse(_salesTaxTEC.text),
      );
      double shippingNHandlingFees = GeneralUtils.roundToTwo(
        double.parse(_shippingNHandlingTEC.text),
      );
      double discount = GeneralUtils.roundToTwo(
        double.parse(_discountTEC.text),
      );

      String issuerName = _issuerNameTEC.text.trim().toUpperCase();
      String issuerAddress1 = _issuerAddress1TEC.text.trim().toUpperCase();
      String issuerAddress2 = _issuerAddress2TEC.text.trim().toUpperCase();
      String issuerPostcode = _issuerPostcodeTEC.text.trim().toUpperCase();
      String issuerCity = _issuerCityTEC.text.trim().toUpperCase();
      String issuerState = _issuerStateTEC.text.trim().toUpperCase();
      String issuerContactNumber = _issuerContactNumberTEC.text
          .trim()
          .toUpperCase();
      String issuerEmail = _issuerEmailTEC.text.trim();

      String recipientName = _recipientNameTEC.text.trim().toUpperCase();
      String recipientAddress1 = _recipientAddress1TEC.text
          .trim()
          .toUpperCase();
      String recipientAddress2 = _recipientAddress2TEC.text
          .trim()
          .toUpperCase();
      String recipientPostcode = _recipientPostcodeTEC.text
          .trim()
          .toUpperCase();
      String recipientCity = _recipientCityTEC.text.trim().toUpperCase();
      String recipientState = _recipientStateTEC.text.trim().toUpperCase();
      String recipientContactNumber = _recipientContactNumberTEC.text
          .trim()
          .toUpperCase();
      String recipientEmail = _recipientEmailTEC.text.trim();

      // Load fonts with fallback handling
      pw.Font? playfairBold;
      pw.Font? notoSansRegular;
      pw.Font? notoSansBold;

      try {
        playfairBold = await PdfGoogleFonts.playfairDisplayBold();
        notoSansRegular = await PdfGoogleFonts.notoSansRegular();
        notoSansBold = await PdfGoogleFonts.notoSansBold();
      } catch (e) {
        debugPrint("Error loading Google Fonts: $e");
      }

      final regularFont = notoSansRegular ?? pw.Font.helvetica();
      final boldFont = notoSansBold ?? pw.Font.helveticaBold();

      pw.TextStyle regularTextStyle = pw.TextStyle(
        font: regularFont,
        fontSize: 8,
        fontWeight: pw.FontWeight.normal,
      );
      pw.TextStyle boldTextStyle = pw.TextStyle(
        font: boldFont,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      );
      pw.TextStyle titleTextStyle = pw.TextStyle(
        font: boldFont,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      );
      pw.TextStyle tableHeaderTextStyle = pw.TextStyle(
        font: boldFont,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      );

      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: notoSansRegular ?? pw.Font.helvetica(),
          bold: notoSansBold ?? pw.Font.helveticaBold(),
        ),
      );

      // Build invoice content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              /// Issuer Info
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(issuerName, style: boldTextStyle),
                  pw.Text('$issuerAddress1,', style: regularTextStyle),
                  if (_issuerAddress2TEC.text != '')
                    pw.Text('$issuerAddress2,', style: regularTextStyle),
                  pw.Text(
                    '$issuerPostcode, $issuerCity,',
                    style: regularTextStyle,
                  ),
                  pw.Text(issuerState, style: regularTextStyle),
                  pw.Text(issuerContactNumber, style: boldTextStyle),
                  pw.Text(issuerEmail, style: boldTextStyle),
                ],
              ),

              pw.Container(
                height: 24,
                margin: pw.EdgeInsets.fromLTRB(0, 24, 0, 24),
                padding: pw.EdgeInsets.fromLTRB(8, 0, 8, 0),
                constraints: pw.BoxConstraints(minWidth: 1),
                decoration: pw.BoxDecoration(color: PdfColors.blueAccent),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(invoiceNumber, style: titleTextStyle),
                    pw.Text(
                      DateFormat('dd MMM yyyy').format(now),
                      style: titleTextStyle,
                    ),
                  ],
                ),
              ),

              pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text('BILL TO', style: boldTextStyle),
                      ),
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text('SHIP TO', style: boldTextStyle),
                      ),
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text('INSTRUCTIONS', style: boldTextStyle),
                      ),
                    ],
                  ),

                  pw.Divider(),

                  pw.Row(
                    children: [
                      /// Recipient Info
                      pw.SizedBox(
                        width: 200,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(recipientName, style: boldTextStyle),
                            pw.Text(
                              '$recipientAddress1,',
                              style: regularTextStyle,
                            ),
                            if (_recipientAddress2TEC.text != '')
                              pw.Text(
                                '$recipientAddress2,',
                                style: regularTextStyle,
                              ),
                            pw.Text(
                              '$recipientPostcode, $recipientCity,',
                              style: regularTextStyle,
                            ),
                            pw.Text(recipientState, style: regularTextStyle),
                            pw.Text(
                              recipientContactNumber,
                              style: boldTextStyle,
                            ),
                            pw.Text(recipientEmail, style: boldTextStyle),
                          ],
                        ),
                      ),

                      /// Issuer Info
                      pw.SizedBox(
                        width: 200,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(issuerName, style: boldTextStyle),
                            pw.Text(
                              '$issuerAddress1,',
                              style: regularTextStyle,
                            ),
                            if (_issuerAddress2TEC.text != '')
                              pw.Text(
                                '$issuerAddress2,',
                                style: regularTextStyle,
                              ),
                            pw.Text(
                              '$issuerPostcode, $issuerCity,',
                              style: regularTextStyle,
                            ),
                            pw.Text(issuerState, style: regularTextStyle),
                            pw.Text(issuerContactNumber, style: boldTextStyle),
                            pw.Text(issuerEmail, style: boldTextStyle),
                          ],
                        ),
                      ),

                      pw.SizedBox(
                        width: 200,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Attention: $recipientName',
                              style: regularTextStyle,
                            ),
                            pw.Text(
                              'Contact No.: $recipientContactNumber',
                              style: regularTextStyle,
                            ),
                            pw.Text(
                              'Email: $recipientEmail',
                              style: regularTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.Container(
                height: 24,
                margin: pw.EdgeInsets.fromLTRB(0, 20, 0, 16),
                padding: pw.EdgeInsets.fromLTRB(8, 0, 8, 0),
                constraints: pw.BoxConstraints(minWidth: 1),
                decoration: pw.BoxDecoration(color: PdfColors.blueAccent),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('NO', style: tableHeaderTextStyle),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text('ITEM', style: tableHeaderTextStyle),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'UNIT PRICE (RM)',
                        style: tableHeaderTextStyle,
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('QUANTITY', style: tableHeaderTextStyle),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'TOTAL PRICE (RM)',
                        style: tableHeaderTextStyle,
                      ),
                    ),
                  ],
                ),
              ),

              /// Item List
              ...itemList.map((e) {
                String no = (itemList.indexOf(e) + 1).toString();
                TextEditingController itemTEC = e['item'];
                TextEditingController unitPriceTEC = e['unit_price'];
                TextEditingController quantityTEC = e['quantity'];
                TextEditingController totalPriceTEC = e['total_price'];
                double unitPrice = GeneralUtils.roundToTwo(
                  double.parse(unitPriceTEC.text),
                );
                double quantity = GeneralUtils.roundToTwo(
                  double.parse(quantityTEC.text),
                );
                double totalPrice = GeneralUtils.roundToTwo(
                  double.parse(totalPriceTEC.text),
                );

                subtotalDueByDate += totalPrice;

                return pw.Padding(
                  padding: pw.EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(no, style: regularTextStyle),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              itemTEC.text.trim(),
                              style: regularTextStyle,
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              unitPrice.toStringAsFixed(2),
                              textAlign: pw.TextAlign.end,
                              style: regularTextStyle,
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              quantity.toStringAsFixed(2),
                              textAlign: pw.TextAlign.end,
                              style: regularTextStyle,
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              totalPrice.toStringAsFixed(2),
                              textAlign: pw.TextAlign.end,
                              style: regularTextStyle,
                            ),
                          ),
                        ],
                      ),
                      pw.Divider(color: PdfColors.grey, thickness: 0.5),
                    ],
                  ),
                );
              }),

              /// Total Section
              pw.Padding(
                padding: pw.EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Builder(
                    builder: (context) {
                      double salesTax = subtotalDueByDate * salesTaxRate / 100;
                      double totalDueByDate =
                          subtotalDueByDate +
                          salesTax +
                          shippingNHandlingFees -
                          discount;

                      return pw.Container(
                        width: 200,
                        alignment: pw.Alignment.centerRight,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('SUBTOTAL', style: regularTextStyle),
                                pw.Text(
                                  'RM${GeneralUtils.roundToTwo(subtotalDueByDate).toStringAsFixed(2)}',
                                  style: regularTextStyle,
                                ),
                              ],
                            ),
                            pw.Divider(color: PdfColors.grey, thickness: 0.5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('SALES TAX', style: regularTextStyle),
                                pw.Text(
                                  'RM${GeneralUtils.roundToTwo(salesTax).toStringAsFixed(2)}',
                                  style: regularTextStyle,
                                ),
                              ],
                            ),
                            pw.Divider(color: PdfColors.grey, thickness: 0.5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'SHIPPING & HANDLING',
                                  style: regularTextStyle,
                                ),
                                pw.Text(
                                  'RM${GeneralUtils.roundToTwo(shippingNHandlingFees).toStringAsFixed(2)}',
                                  style: regularTextStyle,
                                ),
                              ],
                            ),
                            pw.Divider(color: PdfColors.grey, thickness: 0.5),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('Discount', style: regularTextStyle),
                                pw.Text(
                                  '-RM${GeneralUtils.roundToTwo(discount).toStringAsFixed(2)}',
                                  style: regularTextStyle,
                                ),
                              ],
                            ),
                            pw.Divider(
                              // color: PdfColors.grey,
                              thickness: 0.5,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'TOTAL DUE BY DATE',
                                  style: regularTextStyle,
                                ),
                                pw.Text(
                                  'RM${GeneralUtils.roundToTwo(totalDueByDate).toStringAsFixed(2)}',
                                  style: regularTextStyle,
                                ),
                              ],
                            ),
                            pw.Divider(
                              // color: PdfColors.grey,
                              thickness: 0.5,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),)
            ];
          },
          footer: (pw.Context context) {
            final regularFont = notoSansRegular ?? pw.Font.helvetica();
            return pw.Column(
              children: [
                pw.SizedBox(height: 10),
                pw.Text(
                  "Page ${context.pageNumber} of ${context.pagesCount}",
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      );

      final timestamp = now.millisecondsSinceEpoch;
      final fileName =
          'RMSGold_GoldCertificate_${invoiceNumber}_$timestamp.pdf';

      final pdfBytes = await pdf.save();
      final base64Pdf = base64Encode(pdfBytes);

      String? customSavedPath;

      customSavedPath = await FlutterFileSaver().writeFileAsBytes(
        fileName: fileName,
        bytes: base64Decode(base64Pdf),
      );

      if (mounted) {
        if (customSavedPath != null) {
          String successMsg = "PDF Saved successfully";

          // try {
          //   successMsg = successLoc(customSavedPath);
          // } catch (e) {
          //   ErrorLog error = ErrorLog(
          //     platformType: PlatformType.mobile,
          //     message: e.toString(),
          //     functionName: 'receiptPage_generateAndDownloadPdf_success_msg',
          //     timeCreated: DateTime.now(),
          //   );
          //   await ErrorLog.addErrorLog(error);
          //   debugPrint("Error calling pdf_saved_success function: $e");
          // }

          print('pdf save successfully');
          // GeneralUtils.showOverlayNotification(
          //   context,
          //   successMsg,
          //   isError: false,
          //   isSuccess: true,
          // );
        }
      }
    } catch (e) {
      debugPrint("Error generating or sharing PDF: $e");
      // if (mounted) {
      //   String errorMsg = "Error saving PDF: $e";
      //   final dynamic errorLoc = loc['pdf_saved_error'];
      //   if (errorLoc is String) {
      //     errorMsg = errorLoc;
      //   } else if (errorLoc is Function) {
      //     try {
      //       errorMsg = errorLoc(e.toString());
      //     } catch (err) {
      //       debugPrint("Error calling pdf_saved_error function: $err");
      //     }
      //   }
      //
      //   GeneralUtils.showOverlayNotification(context, errorMsg, isError: true);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Widget _buildIssuerInfoFillWidget() {
      return SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Issuer',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
            Text.rich(
              TextSpan(
                text: 'Issuer Name',
                children: [
                  TextSpan(
                    text: '*',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Container(
              width: 160,
              constraints: BoxConstraints(minHeight: 36),
              child: CustomTff(
                controller: _issuerNameTEC,
                textInputType: TextInputType.text,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Fill Name';
                  }

                  return null;
                },
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Issuer Contact Number',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 200,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _issuerContactNumberTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill Contact Number';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Issuer Email',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 200,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _issuerEmailTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill Email';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Issuer Address 1',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 200,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _issuerAddress1TEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill Address 1';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Issuer Address 2',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 200,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _issuerAddress2TEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          // if (value == null) {
                          //   return 'Please Fill Address 2';
                          // }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Issuer Postcode',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 160,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _issuerPostcodeTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill Postcode';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Issuer State',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 160,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _issuerStateTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill State';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Issuer City',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 160,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _issuerCityTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill City';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Issuer Country',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 160,
                      constraints: BoxConstraints(minHeight: 36),
                      child: Autocomplete<Country>(
                        focusNode: _issuerCountryFocusNode,
                        textEditingController: _issuerCountryTEC,
                        optionsMaxHeight: 200,
                        displayStringForOption: (Country c) => c.name,

                        optionsBuilder: (TextEditingValue value) {
                          if (value.text.isEmpty) {
                            return GeneralUtils
                                .defaultCountries; //Iterable.empty();
                          }

                          return GeneralUtils.defaultCountries.where(
                            (item) => item.name.toLowerCase().contains(
                              value.text.toLowerCase(),
                            ),
                          );
                        },
                        fieldViewBuilder:
                            (
                              context,
                              textController,
                              focusNode,
                              onFieldSubmitted,
                            ) {
                              return CustomTff(
                                focusNode: focusNode,
                                controller: textController,
                                textInputType: TextInputType.text,
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Fill Country';
                                  }

                                  return null;
                                },
                              );
                            },
                        optionsViewOpenDirection: OptionsViewOpenDirection.up,
                        optionsViewBuilder: (context, onSelected, options) {
                          return Material(
                            elevation: 4,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    title: Text(option.name),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          );
                        },

                        onSelected: (selection) {
                          _issuerCountryTEC.text = selection.name;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildRecipientInfoFillWidget() {
      return SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipient',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
            Text.rich(
              TextSpan(
                text: 'Recipient Name',
                children: [
                  TextSpan(
                    text: '*',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Container(
              width: 160,
              constraints: BoxConstraints(minHeight: 36),
              child: CustomTff(
                controller: _recipientNameTEC,
                textInputType: TextInputType.text,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Fill Name';
                  }

                  return null;
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Recipient Contact Number',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 200,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _recipientContactNumberTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill Contact Number';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Recipient Email',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 200,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _recipientEmailTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill Email';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Recipient Address 1',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 200,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _recipientAddress1TEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill Address 1';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipient Address 2',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 200,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _recipientAddress2TEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          // if (value == null) {
                          //   return 'Please Fill Address 2';
                          // }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Recipient Postcode',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 160,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _recipientPostcodeTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill Postcode';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Recipient State',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 160,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _recipientStateTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill State';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Recipient City',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 160,
                      constraints: BoxConstraints(minHeight: 36),
                      child: CustomTff(
                        controller: _recipientCityTEC,
                        textInputType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Fill City';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Recipient Country',
                        children: [
                          TextSpan(
                            text: '*',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      width: 160,
                      constraints: BoxConstraints(minHeight: 36),
                      child: Autocomplete<Country>(
                        focusNode: _recipientCountryFocusNode,
                        textEditingController: _recipientCountryTEC,
                        optionsMaxHeight: 200,
                        displayStringForOption: (Country c) => c.name,
                        optionsBuilder: (TextEditingValue value) {
                          if (value.text.isEmpty) {
                            return GeneralUtils
                                .defaultCountries; //Iterable.empty();
                          }

                          return GeneralUtils.defaultCountries.where(
                            (item) => item.name.toLowerCase().contains(
                              value.text.toLowerCase(),
                            ),
                          );
                        },
                        fieldViewBuilder:
                            (
                              context,
                              textController,
                              focusNode,
                              onFieldSubmitted,
                            ) {
                              return CustomTff(
                                focusNode: focusNode,
                                controller: textController,
                                textInputType: TextInputType.text,
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Fill Country';
                                  }

                                  return null;
                                },
                              );
                            },
                        optionsViewOpenDirection: OptionsViewOpenDirection.up,
                        optionsViewBuilder: (context, onSelected, options) {
                          return Material(
                            elevation: 4,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    title: Text(option.name),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          );
                        },

                        onSelected: (selection) {
                          _recipientCountryTEC.text = selection.name;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Form(
      key: globalKey,
      child: StatefulBuilder(
        builder: (context, setStateCal) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // generate button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).primaryColor,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(16),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (!globalKey.currentState!.validate()) {
                        return;
                      }

                      // generate the invoice
                      await _generateAndDownloadPdf();

                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Create'),
                  ),
                ],
              ),

              Expanded(
                child: ListView(
                  children: [
                    // issuer & recipient info
                    ResponsiveLayout.isLargeScreen(context)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildIssuerInfoFillWidget(),
                              SizedBox(width: 24),
                              _buildRecipientInfoFillWidget(),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildIssuerInfoFillWidget(),
                              _buildRecipientInfoFillWidget(),
                            ],
                          ),

                    SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Sales Tax'),

                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: CustomTff(
                                    controller: _salesTaxTEC,
                                    textInputType: TextInputType.text,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: (value) {
                                      // if (value == null) {
                                      //   return 'Please Fill Name';
                                      // }

                                      return null;
                                    },
                                  ),
                                ),
                                Text('%'),
                              ],
                            ),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Shipping & Handling Fees (RM)'),

                            SizedBox(
                              width: 160,
                              child: CustomTff(
                                controller: _shippingNHandlingTEC,
                                textInputType: TextInputType.text,
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                validator: (value) {
                                  // if (value == null) {
                                  //   return 'Please Fill Name';
                                  // }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Discount (RM)'),

                            SizedBox(
                              width: 160,
                              child: CustomTff(
                                controller: _discountTEC,
                                textInputType: TextInputType.text,
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                validator: (value) {
                                  // if (value == null) {
                                  //   return 'Please Fill Name';
                                  // }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // invoice info
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 48,
                                  child: Text(
                                    'No.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 320,
                                  child: Text(
                                    'Item',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Unit Price (RM)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Quantity',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Total (RM)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),

                            // item list
                            ...itemList.map((e) {
                              String no = (itemList.indexOf(e) + 1).toString();
                              TextEditingController itemTEC = e['item'];
                              TextEditingController unitPriceTEC =
                                  e['unit_price'];
                              TextEditingController quantityTEC = e['quantity'];
                              TextEditingController totalPriceTEC =
                                  e['total_price'];

                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      child: Text(
                                        no,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 320,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          8,
                                          0,
                                        ),
                                        child: CustomTff(
                                          controller: itemTEC,
                                          textInputType: TextInputType.text,
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                          validator: (value) {
                                            // if (value == null) {
                                            //   return 'Please Fill Name';
                                            // }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          8,
                                          0,
                                        ),
                                        child: CustomTff(
                                          controller: unitPriceTEC,
                                          textInputType: TextInputType.text,
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                          onTap: () {
                                            if (unitPriceTEC.text == '0.00' ||
                                                unitPriceTEC.text == '0') {
                                              unitPriceTEC.text = '';
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              unitPriceTEC.text = '0.00';
                                              totalPriceTEC.text =
                                                  GeneralUtils.roundToTwo(
                                                    double.parse(
                                                          quantityTEC.text,
                                                        ) *
                                                        0,
                                                  ).toString();
                                              unitPriceTEC.text = '';
                                              return;
                                            }
                                            if (value.length == 2 &&
                                                value.startsWith('0') &&
                                                !value.endsWith('.')) {
                                              unitPriceTEC.text =
                                                  '0.${value[1]}';
                                            }
                                            // if (unitPriceTEC.text.isEmpty) {
                                            //   unitPriceTEC.text = '0.00';
                                            // }
                                            // if (_previousMeterTEC.text.isEmpty) {
                                            //   _previousMeterTEC.text = '0.00';
                                            // }
                                            if (quantityTEC.text != '') {
                                              totalPriceTEC.text =
                                                  GeneralUtils.roundToTwo(
                                                    double.parse(
                                                          quantityTEC.text,
                                                        ) *
                                                        double.parse(value),
                                                  ).toString();
                                            }
                                          },
                                          onTapUpOutside: (event) {
                                            if (unitPriceTEC.text.isEmpty ||
                                                double.parse(
                                                      unitPriceTEC.text,
                                                    ) ==
                                                    0) {
                                              unitPriceTEC.text = '0.00';
                                            } else {
                                              unitPriceTEC.text =
                                                  GeneralUtils.roundToTwo(
                                                    double.parse(
                                                      unitPriceTEC.text,
                                                    ),
                                                  ).toStringAsFixed(2);
                                            }
                                            FocusScope.of(context).unfocus();
                                          },
                                          inputFormatters: [
                                            GeneralUtils
                                                .allowTwoDecimalPlacesOnly,
                                          ],
                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          8,
                                          0,
                                        ),
                                        child: CustomTff(
                                          controller: quantityTEC,
                                          textInputType: TextInputType.text,
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                          onTap: () {
                                            if (quantityTEC.text == '0.00' ||
                                                quantityTEC.text == '0') {
                                              quantityTEC.text = '';
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              quantityTEC.text = '0.00';
                                              totalPriceTEC.text =
                                                  GeneralUtils.roundToTwo(
                                                    double.parse(
                                                          quantityTEC.text,
                                                        ) *
                                                        0,
                                                  ).toString();
                                              quantityTEC.text = '';
                                              return;
                                            }
                                            if (value.length == 2 &&
                                                value.startsWith('0') &&
                                                !value.endsWith('.')) {
                                              quantityTEC.text =
                                                  '0.${value[1]}';
                                            }
                                            // if (unitPriceTEC.text.isEmpty) {
                                            //   unitPriceTEC.text = '0.00';
                                            // }
                                            // if (_previousMeterTEC.text.isEmpty) {
                                            //   _previousMeterTEC.text = '0.00';
                                            // }
                                            if (unitPriceTEC.text != '') {
                                              totalPriceTEC.text =
                                                  GeneralUtils.roundToTwo(
                                                    double.parse(
                                                          unitPriceTEC.text,
                                                        ) *
                                                        double.parse(value),
                                                  ).toString();
                                            }
                                          },
                                          onTapUpOutside: (event) {
                                            if (quantityTEC.text.isEmpty ||
                                                double.parse(
                                                      quantityTEC.text,
                                                    ) ==
                                                    0) {
                                              quantityTEC.text = '0.00';
                                            } else {
                                              quantityTEC.text =
                                                  GeneralUtils.roundToTwo(
                                                    double.parse(
                                                      quantityTEC.text,
                                                    ),
                                                  ).toStringAsFixed(2);
                                            }
                                            FocusScope.of(context).unfocus();
                                          },
                                          inputFormatters: [
                                            GeneralUtils
                                                .allowTwoDecimalPlacesOnly,
                                          ],
                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          8,
                                          0,
                                        ),
                                        child: CustomTff(
                                          controller: totalPriceTEC,
                                          textInputType: TextInputType.text,
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                          readOnly: true,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      style: ButtonStyle(
                                        iconColor: WidgetStatePropertyAll(
                                          Colors.red,
                                        ),
                                        foregroundColor: WidgetStatePropertyAll(
                                          Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        itemList.removeWhere(
                                          (item) => item == e,
                                        );
                                        setStateCal(() {});
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // add item button
              TextButton.icon(
                iconAlignment: IconAlignment.start,
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                  ),
                ),
                onPressed: () {
                  itemList.add({
                    'item': TextEditingController(),
                    'unit_price': TextEditingController(text: '0.00'),
                    'quantity': TextEditingController(text: '0'),
                    'total_price': TextEditingController(text: '0.00'),
                  });
                  setStateCal(() {});
                },
                label: Text('Add Item'),
                icon: Icon(Icons.add),
              ),

              SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}
