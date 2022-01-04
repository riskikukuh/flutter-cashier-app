import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/screen/report/report_profit.dart';
import 'package:kasir_app/src/screen/report/report_transaction.dart';

class ReportDatePicker extends StatefulWidget {
  final ReportDatePickerType type;
  const ReportDatePicker({
    Key? key,
    this.type = ReportDatePickerType.transaksi,
  }) : super(key: key);

  @override
  _ReportDatePickerState createState() => _ReportDatePickerState();
}

class _ReportDatePickerState extends State<ReportDatePicker> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == ReportDatePickerType.transaksi
              ? 'Laporan Transaksi Penjualan'
              : 'Laporan Laba Rugi',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tanggal Awal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _startDateController,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () async {
                  final DateTime? startDatePicked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (startDatePicked != null) {
                    setState(() {
                      _startDate = startDatePicked;
                      _startDateController.text =
                          DateFormat.yMd().format(startDatePicked);
                    });
                  } else {
                    _startDate = null;
                    _startDateController.text = '';
                  }
                },
                icon: const Icon(Icons.date_range),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tanggal Akhir',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _endDateController,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () async {
                  final DateTime? endDatePicked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (endDatePicked != null) {
                    setState(() {
                      _endDate = endDatePicked;
                      _endDateController.text =
                          DateFormat.yMd().format(endDatePicked);
                    });
                  } else {
                    _endDate = null;
                    _endDateController.text = '';
                  }
                },
                icon: const Icon(Icons.date_range),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: MaterialButton(
          color: _startDate != null && _endDate != null
              ? Colors.blue
              : Colors.grey,
          child: const Text(
            'Generate',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            if (_startDate != null && _endDate != null) {
              if (widget.type == ReportDatePickerType.transaksi) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReportTransaction(
                    startDate: _startDate!,
                    endDate: _endDate!,
                  ),
                ));
              } else if (widget.type == ReportDatePickerType.labaRugi) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReportProfit(
                    startDate: _startDate!,
                    endDate: _endDate!,
                  ),
                ));
              }
            }
          },
        ),
      ),
    );
  }
}
