import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/cartstok_bloc.dart';
import 'package:kasir_app/src/bloc/transaksistok_bloc.dart';
import 'package:kasir_app/src/resources/util.dart';

class CheckoutStokScreen extends StatelessWidget {
  CheckoutStokScreen({Key? key}) : super(key: key);

  late final formatter = NumberFormat();
  final _keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout Stok',
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: BlocConsumer<TransaksistokBloc, TransaksistokState>(
          listener: (context, state) {
            if (state is PaymentTransaksiStokSuccess) {
              Util.showSnackbar(context, state.message);
              Navigator.of(context).pushNamedAndRemoveUntil('/transaksiStok', (route) => false);
            } else if (state is PaymentTransaksiStokError) {
              Util.showSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is TransaksiStokLoadSuccess) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _keteranganController,
                    decoration: InputDecoration(
                      suffix: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _keteranganController.clear();
                        },
                      ),
                      hintText: 'Keterangan',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Pesanan',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  BlocBuilder<CartstokBloc, CartstokState>(
                    builder: (context, state) {
                      if (state is CartStokLoadSuccess) {
                        return Column(
                          children: [
                            for (var cart in state.cartStok)
                              Card(
                                margin: const EdgeInsets.only(top: 5),
                                child: ListTile(
                                  title: Text(cart.produk.nama),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rp ${formatter.format(cart.produk.hargaStok)} - ${cart.quantity} pcs',
                                          ),
                                          Text(
                                            'Rp ${formatter.format(cart.produk.hargaStok * cart.quantity)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                      return const Text('Pesanan kosong');
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Jumlah yang harus dibayarkan',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      BlocBuilder<CartstokBloc, CartstokState>(
                        builder: (context, state) {
                          int total = 0;
                          if (state is CartStokLoadSuccess) {
                            for (var order in state.cartStok) {
                              total += order.quantity * order.produk.hargaStok;
                            }
                          }
                          return Text(
                            'Rp ${formatter.format(total)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is TransaksiStokLoading) {
              return const CircularProgressIndicator();
            } else if (state is TransaksiStokError) {
              return Text(state.message);
            }

            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: BlocBuilder<CartstokBloc, CartstokState>(
          builder: (context, state) {
            bool _isOrderNotEmpty = false;
            if (state is CartStokLoadSuccess) {
              _isOrderNotEmpty = state.cartStok.isNotEmpty;
            }
            return ElevatedButton(
              child: const Text('Bayar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    _isOrderNotEmpty ? Colors.blue : Colors.grey),
              ),
              onPressed: () {
                if (_isOrderNotEmpty) {
                  context.read<TransaksistokBloc>().add(AddTransaksiStok(
                        keterangan: _keteranganController.text,
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Keranjang masih kosong')));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
