import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:kasir_app/src/models/transaksi_model.dart';

class ReportTransaction extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  const ReportTransaction({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _ReportTransactionState createState() => _ReportTransactionState();
}

class _ReportTransactionState extends State<ReportTransaction> {
  final pdf = pw.Document();
  final _now = DateTime.now();
  final _paddingTableHeader = const pw.EdgeInsets.fromLTRB(10, 8, 10, 8);
  final _numberFormat = NumberFormat();
  final _tableColumnWidthSetting = {
    0: const pw.FixedColumnWidth(62),
    1: const pw.FixedColumnWidth(76),
    2: const pw.FixedColumnWidth(60),
    4: const pw.FixedColumnWidth(50),
    5: const pw.FixedColumnWidth(82),
  };

  _savePdf(PdfPageFormat format, pw.PageOrientation orientation,
      List<TransaksiModel> allTransaksi) async {
    try {
      final output = await getExternalStorageDirectory();
      final file = File(
          '${output!.path}/${_now.millisecondsSinceEpoch} KasirApp - Laporan Transaksi Penjualan.pdf');
      await file.writeAsBytes(
          await _generatePdf(format, orientation, allTransaksi: allTransaksi));
      Util.showSnackbar(
          context, 'Berhasil mengekspor laporan transaksi penjualan');
    } on Exception catch (e) {
      Util.showSnackbar(context, e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Transaksi Penjualan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TransaksiBloc, TransaksiState>(
              builder: (context, state) {
                List<TransaksiModel> allTransaksi = [];
                if (state is TransaksiLoadSuccess) {
                  allTransaksi.addAll(state.allTransaksi
                      .where((transaksi) =>
                          transaksi.tanggal >=
                              widget.startDate.millisecondsSinceEpoch &&
                          transaksi.tanggal <=
                              widget.endDate.millisecondsSinceEpoch)
                      .toList());
                }
                return PdfPreview(
                  canDebug: false,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  actions: [
                    PdfPreviewAction(
                      icon: const Icon(Icons.save),
                      onPressed: (context, build, pageFormat) {
                        _savePdf(
                          pageFormat,
                          pw.PageOrientation.landscape,
                          allTransaksi,
                        );
                      },
                    ),
                  ],
                  pdfFileName: 'Laporan Transaksi Penjualan',
                  build: (format) => _generatePdf(
                    format,
                    pw.PageOrientation.landscape,
                    allTransaksi: allTransaksi,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _headerPdf() {
    return pw.Column(
      children: [
        pw.SizedBox(
          width: double.infinity,
          child: pw.Text(
            DateFormat('dd MMMM yyyy').format(_now),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Laporan Transaksi Penjualan',
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColor.fromHex('#2881A1'),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          DateFormat('EEEE, MMMM dd, yyyy').format(widget.startDate) +
              ' - ' +
              DateFormat('EEEE, MMMM dd, yyyy').format(widget.endDate),
          style: pw.TextStyle(
            color: PdfColor.fromHex('#70454C'),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  List<pw.TableRow> _showContent({
    bool withTableHead = false,
    bool withTableFooter = false,
    bool isFirstPage = true,
    List<TransaksiModel> allTransaksi = const [],
  }) {
    int totalHarga = 0;
    if (withTableFooter) {
      for (TransaksiModel transaksi in allTransaksi) {
        totalHarga += transaksi.price;
      }
    }

    return [
      pw.TableRow(
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#DDDDDD'),
        ),
        children: [
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Tanggal',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'No.Transaksi',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Pembeli',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Keterangan',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Jumlah',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Harga',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      for (var i = 0; i < allTransaksi.length; i++)
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: i % 2 != 0 ? PdfColor.fromHex('#F7F7F7') : null,
          ),
          children: [
            pw.Padding(
              padding: _paddingTableHeader,
              child: pw.Column(
                children: [
                  pw.Text(
                    DateFormat('dd/MM/yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          allTransaksi[i].tanggal),
                    ),
                  ),
                ],
              ),
            ),
            pw.Padding(
              padding: _paddingTableHeader,
              child: pw.Column(
                children: [
                  pw.Text(
                    allTransaksi[i].id.toString(),
                  ),
                ],
              ),
            ),
            pw.Padding(
              padding: _paddingTableHeader,
              child: pw.Column(
                children: [
                  pw.Text(
                    allTransaksi[i].pembeli?.nama ?? 'Guest',
                  ),
                ],
              ),
            ),
            pw.Padding(
              padding: _paddingTableHeader,
              child: pw.Column(
                children: [
                  pw.Text(
                    allTransaksi[i].keterangan,
                  ),
                ],
              ),
            ),
            pw.Padding(
              padding: _paddingTableHeader,
              child: pw.Column(
                children: [
                  pw.Text(
                    allTransaksi[i].orders.length.toString(),
                  ),
                ],
              ),
            ),
            pw.Padding(
              padding: _paddingTableHeader,
              child: pw.Column(
                children: [
                  pw.Text(
                    _numberFormat.format(allTransaksi[i].price),
                  ),
                ],
              ),
            ),
          ],
        ),
      pw.TableRow(
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#DDDDDD'),
        ),
        children: [
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Total :',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  _numberFormat.format(totalHarga),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    pw.PageOrientation? orientation, {
    List<TransaksiModel> allTransaksi = const [],
  }) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          orientation: orientation,
          pageFormat: format,
        ),
        build: (context) {
          return [
            _headerPdf(),
            pw.Table(
              columnWidths: _tableColumnWidthSetting,
              children: _showContent(
                withTableHead: true,
                withTableFooter: true,
                allTransaksi: allTransaksi,
                isFirstPage: false,
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
