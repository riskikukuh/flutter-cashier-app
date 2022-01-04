import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/bloc/transaksistok_bloc.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportProfit extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  const ReportProfit({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _ReportProfitState createState() => _ReportProfitState();
}

class _ReportProfitState extends State<ReportProfit> {
  final pdf = pw.Document();
  final _now = DateTime.now();
  final _paddingTableHeader = const pw.EdgeInsets.fromLTRB(10, 8, 10, 8);
  final _numberFormat = NumberFormat();
  final _tableColumnWidthSetting = {
    0: const pw.FixedColumnWidth(100),
    1: const pw.FixedColumnWidth(100),
    2: const pw.FixedColumnWidth(100),
  };

  _savePdf(PdfPageFormat format, pw.PageOrientation orientation, int pendapatan,
      int pengeluaran) async {
    try {
      final output = await getExternalStorageDirectory();
      final file = File(
          '${output!.path}/${_now.millisecondsSinceEpoch} KasirApp - Laporan Laba Rugi.pdf');
      await file.writeAsBytes(await _generatePdf(format, orientation,
          pendapatan: pendapatan, pengeluaran: pengeluaran));
      Util.showSnackbar(context, 'Berhasil mengekspor laporan laba rugi');
    } on Exception catch (e) {
      Util.showSnackbar(context, e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Laba Rugi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<TransaksiBloc, TransaksiState>(
              listener: (context, state) {},
              builder: (context, state) {
                int pendapatan = 0;
                if (state is TransaksiLoadSuccess) {
                  state.allTransaksi
                      .where((transaksi) =>
                          transaksi.tanggal >=
                              widget.startDate.millisecondsSinceEpoch &&
                          transaksi.tanggal <=
                              widget.endDate.millisecondsSinceEpoch)
                      .forEach((transaksi) {
                    pendapatan += transaksi.price;
                  });
                }
                return BlocBuilder<TransaksistokBloc, TransaksistokState>(
                  builder: (context, state) {
                    int pengeluaran = 0;
                    if (state is TransaksiStokLoadSuccess) {
                      state.allTransaksiStok
                          .where((transaksi) =>
                              transaksi.tanggal >=
                                  widget.startDate.millisecondsSinceEpoch &&
                              transaksi.tanggal <=
                                  widget.endDate.millisecondsSinceEpoch)
                          .forEach((transaksi) {
                        pengeluaran += transaksi.price;
                      });
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
                              pw.PageOrientation.portrait,
                              pendapatan,
                              pengeluaran,
                            );
                          },
                        ),
                      ],
                      pdfFileName: 'Laporan Laba Rugi',
                      build: (format) => _generatePdf(
                        format,
                        pw.PageOrientation.portrait,
                        pendapatan: pendapatan,
                        pengeluaran: pengeluaran,
                      ),
                    );
                  },
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
          'Laporan Laba Rugi',
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
      ],
    );
  }

  List<pw.TableRow> _showContent({
    int pendapatan = 0,
    int pengeluaran = 0,
  }) {
    return [
      pw.TableRow(
        children: [
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Pendapatan',
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
              children: [],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Rp' + _numberFormat.format(pendapatan),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      pw.TableRow(
        children: [
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Pengeluaran',
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
              children: [],
            ),
          ),
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Rp' + _numberFormat.format(pengeluaran),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      pw.TableRow(
        children: [
          pw.Padding(
            padding: _paddingTableHeader,
            child: pw.Column(
              children: [
                pw.Text(
                  'Laba/Rugi Bersih',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#70454C'),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
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
                  'Rp' + _numberFormat.format(pendapatan - pengeluaran),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#70454C'),
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
    int pendapatan = 0,
    int pengeluaran = 0,
  }) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          orientation: orientation,
          pageFormat: format,
        ),
        build: (context) {
          return pw.Column(
            children: [
              _headerPdf(),
              pw.SizedBox(height: 25),
              pw.Table(
                columnWidths: _tableColumnWidthSetting,
                children: _showContent(
                  pendapatan: pendapatan,
                  pengeluaran: pengeluaran,
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}
