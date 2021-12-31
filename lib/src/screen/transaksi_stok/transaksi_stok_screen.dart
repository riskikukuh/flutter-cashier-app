import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/transaksistok_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/models/transaksi_stok_model.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/screen/produk/products_screen.dart';
import 'package:kasir_app/src/screen/transaksi_stok/detail_transaksi_stok_screen.dart';

class TransaksiStokScreen extends StatelessWidget {
  TransaksiStokScreen({Key? key}) : super(key: key);

  final _format = DateFormat('EEEE, d MMM yyyy');
  final formatter = NumberFormat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaksi Stok',
        ),
        actions: [
          InkWell(
            child: const Center(child: Text('New Stok')),
            onTap: () {
              Navigator.of(context).pushNamed('/produkStok');
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: BlocBuilder<TransaksistokBloc, TransaksistokState>(
          builder: (context, state) {
            if (state is TransaksiStokLoadSuccess) {
              if (state.allTransaksiStok.isEmpty) {
                return const Text(
                  'Riwayat Transaksi stok kosong',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                itemCount: state.allTransaksiStok.length,
                itemBuilder: (context, i) {
                  TransaksiStokModel transaksi = state.allTransaksiStok[i];
                  DateTime date =
                      DateTime.fromMillisecondsSinceEpoch(transaksi.tanggal);

                  return Card(
                    margin: const EdgeInsets.only(top: 14),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailTransaksiStokScreen(transaksi: transaksi),
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
                                      transaksi.stok.first.produk.nama,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      transaksi.stok.first.quantity
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
                          if (transaksi.stok.length - 1 > 0)
                            Column(
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  '+ ${transaksi.stok.length - 1} pesanan lainnya',
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
