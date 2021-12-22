import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/models/transaksi_model.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/screen/transaksi/detail_transaksi_screen.dart';

class TransaksiScreen extends StatelessWidget {
  TransaksiScreen({Key? key}) : super(key: key);

  final _format = DateFormat('EEEE, d MMM yyyy');
  final formatter = NumberFormat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaksi',
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: BlocBuilder<TransaksiBloc, TransaksiState>(
          builder: (context, state) {
            if (state is TransaksiLoadSuccess) {
              if (state.allTransaksi.isEmpty) {
                return const Text(
                  'Riwayat Transaksi kosong',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                itemCount: state.allTransaksi.length,
                itemBuilder: (context, i) {
                  TransaksiModel transaksi = state.allTransaksi[i];
                  DateTime date =
                      DateTime.fromMillisecondsSinceEpoch(transaksi.tanggal);

                  return Card(
                    margin: const EdgeInsets.only(top: 14),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DetailTransaksiScreen(transaksi: transaksi),
                          ));
                        },
                        title: Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              _format.format(date),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            const Divider(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.grey,
                                  size: 32,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaksi.orders.first.produk.nama,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        transaksi.orders.first.quantity
                                                .toString() +
                                            ' pcs',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (transaksi.orders.length - 1 > 0)
                              Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    '+ ${transaksi.orders.length - 1} pesanan lainnya',
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                ],
                              ),
                            const Divider(),
                            const Text(
                              'Total belanja',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp' + formatter.format(transaksi.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
