import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/models/transaksi_stok_model.dart';

class DetailTransaksiStokScreen extends StatelessWidget {
  late final DateTime _date;
  final TransaksiStokModel transaksi;
  DetailTransaksiStokScreen({
    Key? key,
    required this.transaksi,
  }) : super(key: key) {
    _date = DateTime.fromMillisecondsSinceEpoch(transaksi.tanggal);
  }
  final formatter = NumberFormat();
  final _dateFormat = DateFormat('EEEE, d MMMM yyyy, HH:mm WIB');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Transaksi',
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.black12,
        child: ListView(
          // padding: const EdgeInsets.all(14),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nomor Transaksi Stok',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    transaksi.id.toString(),
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Tanggal pembelian',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    transaksi.keterangan,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Catatan Pembelian',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    _dateFormat.format(_date),
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (var order in transaksi.stok)
                    Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                order.produk.nama,
                              ),
                              leading: const Icon(
                                Icons.shopping_bag,
                                color: Colors.grey,
                                size: 32,
                              ),
                              subtitle: Text(
                                order.quantity.toString() +
                                    ' pcs x Rp' +
                                    formatter.format(order.produk.hargaStok),
                              ),
                            ),
                            const Divider(
                              color: Colors.black54,
                            ),
                            const Text(
                              'Total Harga',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp' +
                                  formatter
                                      .format(order.quantity *
                                          order.produk.hargaStok)
                                      .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rincian Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Metode Pembayaran',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Cash',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Harga (${transaksi.stok.length} barang)',
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Rp${formatter.format(transaksi.price)}',
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Bayar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp${formatter.format(transaksi.price)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
